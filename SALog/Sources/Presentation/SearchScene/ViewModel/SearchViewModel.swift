//
//  SearchViewModel.swift
//  SALog
//
//  Created by RAFA on 1/13/25.
//

import RxCocoa
import RxSwift

protocol SearchViewModelInput {
    var searchType: Observable<SearchType> { get }
    var query: Observable<String> { get }
    var selectResult: Observable<SearchResultType> { get }
    var loadNextPage: Observable<Void> { get }
}

protocol SearchViewModelOutput {
    var filteredResults: Observable<[SearchResultType]> { get }
    var isLoading: Observable<Bool> { get }
    var isLoadingMore: Observable<Bool> { get }
    var errorMessage: Observable<String> { get }
}

protocol SearchViewModelProtocol {
    func transform(input: SearchViewModelInput) -> SearchViewModelOutput
}

final class SearchViewModel: SearchViewModelProtocol {

    // MARK: - Input

    struct Input: SearchViewModelInput {
        let searchType: Observable<SearchType>
        let query: Observable<String>
        let selectResult: Observable<SearchResultType>
        let loadNextPage: Observable<Void>
    }

    // MARK: - Output

    struct Output: SearchViewModelOutput {
        let filteredResults: Observable<[SearchResultType]>
        let isLoading: Observable<Bool>
        let isLoadingMore: Observable<Bool>
        let errorMessage: Observable<String>
    }

    // MARK: - Pagination State

    private struct PaginationState {
        var currentPage = 1
        var hasMorePage = true
        var currentType: SearchType = .nickname
        var currentQuery: String = ""
        var resultsPerPage = 15

        mutating func reset(type: SearchType) {
            currentPage = 1
            hasMorePage = true
            currentType = type
        }

        mutating func nextPage() {
            currentPage += 1
        }

        mutating func updateHasMorePage(resultsCount: Int) {
            hasMorePage = resultsCount >= resultsPerPage
        }
    }

    // MARK: - Properties

    private let useCase: SearchUseCaseProtocol
    private var paginationState = PaginationState()
    private let disposeBag = DisposeBag()

    private let searchResultsRelay = BehaviorRelay<[SearchResultType]>(value: [])
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let isLoadingMoreRelay = BehaviorRelay<Bool>(value: false)
    private let errorMessageRelay = PublishRelay<String>()

    // MARK: - Initializer

    init(useCase: SearchUseCaseProtocol) {
        self.useCase = useCase
    }

    // MARK: - Helpers

    func transform(input: SearchViewModelInput) -> SearchViewModelOutput {
        configureSearchQuery(from: input)
        configurePagination(from: input)
        configureResultSelection(from: input)

        return Output(
            filteredResults: createFilteredResultsObservable(from: input),
            isLoading: isLoadingRelay.asObservable(),
            isLoadingMore: isLoadingMoreRelay.asObservable(),
            errorMessage: errorMessageRelay.asObservable()
        )
    }
}

// MARK: - Configuration

private extension SearchViewModel {

    func createFilteredResultsObservable(
        from input: SearchViewModelInput
    ) -> Observable<[SearchResultType]> {
        Observable.combineLatest(
            searchResultsRelay.asObservable(),
            input.searchType
        ).map { results, type in
            return results.filter { $0.isMatchingType(type) }
        }
    }

    func configureSearchQuery(from input: SearchViewModelInput) {
        Observable
            .combineLatest(
                input.searchType,
                input.query.debounce(
                    .milliseconds(300),
                    scheduler: MainScheduler.instance
                )
            )
            .do(onNext: { [weak self] type, query in
                guard let self = self else { return }

                self.paginationState.currentQuery = query

                if query.isEmpty {
                    self.isLoadingRelay.accept(false)
                    self.searchResultsRelay.accept([])
                } else {
                    self.isLoadingRelay.accept(true)
                    self.paginationState.reset(type: type)
                }
            })
            .filter { _, query in !query.isEmpty }
            .flatMapLatest { [weak self] type, query -> Observable<[SearchResultType]> in
                guard let self = self else { return .just([]) }

                return self.fetchSearchResults(type: type, query: query, page: 1)
                    .observe(on: MainScheduler.instance)
                    .do(onCompleted: { self.isLoadingRelay.accept(false) })
            }
            .bind(to: searchResultsRelay)
            .disposed(by: disposeBag)
    }

    func configurePagination(from input: SearchViewModelInput) {
        input.loadNextPage
            .withLatestFrom(input.query)
            .filter { [weak self] query in
                guard let self = self,
                      !query.isEmpty,
                      !self.isLoadingRelay.value,
                      !self.isLoadingMoreRelay.value,
                      self.paginationState.hasMorePage
                else {
                    return false
                }

                return true
            }
            .withLatestFrom(input.searchType)
            .flatMapLatest { [weak self] _ -> Observable<[SearchResultType]> in
                guard let self = self else { return .just([]) }

                self.isLoadingMoreRelay.accept(true)
                self.paginationState.nextPage()

                return self.fetchSearchResults(
                    type: self.paginationState.currentType,
                    query: self.paginationState.currentQuery,
                    page: self.paginationState.currentPage
                )
                .observe(on: MainScheduler.instance)
                .do(
                    onNext: { [weak self] results in
                        guard let self = self else { return }

                        if results.isEmpty {
                            self.paginationState.hasMorePage = false
                        } else {
                            self.updateResults(with: results)
                        }

                        self.isLoadingMoreRelay.accept(false)
                    },
                    onCompleted: { [weak self] in
                        self?.isLoadingMoreRelay.accept(false)
                    }
                )
            }
            .subscribe()
            .disposed(by: disposeBag)
    }

    func configureResultSelection(from input: SearchViewModelInput) {
        input.selectResult
            .subscribe(onNext: { [weak self] result in
                self?.handleResultsSelection(result)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Data Fetching

private extension SearchViewModel {

    func fetchSearchResults(
        type: SearchType,
        query: String,
        page: Int
    ) -> Observable<[SearchResultType]> {
        Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }

            Task {
                do {
                    let results = try await self.loadResults(
                        type: type,
                        query: query,
                        page: page
                    )

                    await MainActor.run {
                        observer.onNext(results)
                        observer.onCompleted()
                    }
                } catch {
                    await MainActor.run {
                        self.handleError(error)
                        observer.onNext([])
                        observer.onCompleted()
                    }
                }
            }

            return Disposables.create()
        }
    }

    func loadResults(
        type: SearchType,
        query: String,
        page: Int
    ) async throws -> [SearchResultType] {
        let results: [SearchResultType]

        switch type {
        case .nickname:
            let result = try await useCase.searchByNickname(query, page: page)
            results = result.result.characterInfo.map { .nickname($0) }
        case .clan:
            let result = try await useCase.searchByClan(query, page: page)
            results = result.result.clanInfo.map { .clan($0) }
        }

        paginationState.updateHasMorePage(resultsCount: results.count)

        return results
    }
}

// MARK: - Event Handling

private extension SearchViewModel {

    func handleResultsSelection(_ result: SearchResultType) {
        switch result {
        case .nickname(let info):
            print("DEBUG: \(info.userNickname)")
        case .clan(let info):
            print("DEBUG: \(info.clanName)")
        }
    }

    func handleError(_ error: Error) {
        errorMessageRelay.accept(error.localizedDescription)
        isLoadingRelay.accept(false)
        isLoadingMoreRelay.accept(false)
    }
}

// MARK: - Search Results Helper

private extension SearchViewModel {

    func updateResults(with newResults: [SearchResultType]) {
        let currentResults = searchResultsRelay.value
        let uniqueIds = Set(currentResults.map { getUniqueIdentifier(for: $0) })
        let uniqueNewResults = newResults.filter {
            !uniqueIds.contains(getUniqueIdentifier(for: $0))
        }

        searchResultsRelay.accept(currentResults + uniqueNewResults)
    }

    func getUniqueIdentifier(for result: SearchResultType) -> String {
        switch result {
        case .nickname(let info): return info.userNickname
        case .clan(let info)    : return info.clanName
        }
    }
}
