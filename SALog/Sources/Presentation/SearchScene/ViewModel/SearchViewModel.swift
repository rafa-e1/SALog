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
}

protocol SearchViewModelOutput {
    var results: Observable<[SearchResultType]> { get }
    var filteredResults: Observable<[SearchResultType]> { get }
    var isLoading: Observable<Bool> { get }
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
    }

    // MARK: - Output

    struct Output: SearchViewModelOutput {
        let results: Observable<[SearchResultType]>
        let filteredResults: Observable<[SearchResultType]>
        let isLoading: Observable<Bool>
        let errorMessage: Observable<String>
    }

    // MARK: - Properties

    private let useCase: SearchUseCaseProtocol

    private let searchResultsRelay = BehaviorRelay<[SearchResultType]>(value: [])
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let errorMessageRelay = PublishRelay<String>()

    private let disposeBag = DisposeBag()

    // MARK: - Initializer

    init(useCase: SearchUseCaseProtocol) {
        self.useCase = useCase
    }

    // MARK: - Helpers

    func transform(input: SearchViewModelInput) -> SearchViewModelOutput {
        Observable
            .combineLatest(
                input.searchType,
                input.query.debounce(
                    .milliseconds(300),
                    scheduler: MainScheduler.instance
                )
            )
            .flatMapLatest { [weak self] type, query -> Observable<[SearchResultType]> in
                guard let self = self else { return .just([]) }

                if query.isEmpty {
                    self.isLoadingRelay.accept(false)
                    return .just([])
                }

                self.isLoadingRelay.accept(true)

                return self.fetchSearchResults(type: type, query: query)
                    .observe(on: MainScheduler.instance)
                    .do(
                        onNext: { _ in self.isLoadingRelay.accept(false) },
                        onError: { _ in self.isLoadingRelay.accept(false) },
                        onCompleted: { self.isLoadingRelay.accept(false) }
                    )
                    .catch { error in
                        self.errorMessageRelay.accept(error.localizedDescription)
                        return .just([])
                    }
            }
            .bind(to: searchResultsRelay)
            .disposed(by: disposeBag)

        input.selectResult
            .subscribe(onNext: { [weak self] result in
                self?.handleResultsSelection(result)
            })
            .disposed(by: disposeBag)

        let filteredResults: Observable<[SearchResultType]> = Observable.combineLatest(
            searchResultsRelay.asObservable(),
            input.searchType
        ).map { [weak self] results, type in
            guard let self = self else { return [] }

            return results.filter {
                $0.isMatchingType(type)
            }.sorted {
                self.sortSearchResults($0, $1)
            }
        }

        return Output(
            results: searchResultsRelay.asObservable(),
            filteredResults: filteredResults,
            isLoading: isLoadingRelay.asObservable(),
            errorMessage: errorMessageRelay.asObservable()
        )
    }

    private func fetchSearchResults(
        type: SearchType,
        query: String
    ) -> Observable<[SearchResultType]> {
        switch type {
        case .nickname: return searchNickname(query: query)
        case .clan:     return searchClan(query: query)
        }
    }

    private func searchNickname(query: String) -> Observable<[SearchResultType]> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }

            Task {
                do {
                    let result = try await self.useCase.searchByNickname(query)
                    let searchResults = result.result.characterInfo.map {
                        SearchResultType.nickname($0)
                    }

                    observer.onNext(searchResults)
                    observer.onCompleted()
                } catch {
                    self.errorMessageRelay.accept(error.localizedDescription)
                    observer.onNext([])
                    observer.onCompleted()
                }
            }

            return Disposables.create()
        }
    }

    private func searchClan(query: String) -> Observable<[SearchResultType]> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            Task {
                do {
                    let result = try await self.useCase.searchByClan(query)
                    let searchResults = result.result.clanInfo.map {
                        SearchResultType.clan($0)
                    }

                    observer.onNext(searchResults)
                    observer.onCompleted()
                } catch {
                    self.errorMessageRelay.accept(error.localizedDescription)
                    observer.onNext([])
                    observer.onCompleted()
                }
            }

            return Disposables.create()
        }
    }

    private func sortSearchResults(
        _ lhs: SearchResultType,
        _ rhs: SearchResultType
    ) -> Bool {
        switch (lhs, rhs) {
        case (.nickname(let lhsInfo), .nickname(let rhsInfo)):
            return lhsInfo.userNexonSN < rhsInfo.userNexonSN
        case (.clan(let lhsInfo), .clan(let rhsInfo)):
            return lhsInfo.clanID < rhsInfo.clanID
        default:
            return false
        }
    }

    private func handleResultsSelection(_ result: SearchResultType) {
        switch result {
        case .nickname(let characterInfo):
            print("DEBUG: \(characterInfo.userNickname)")
        case .clan(let clanInfo):
            print("DEBUG: \(clanInfo.clanName)")
        }
    }
}
