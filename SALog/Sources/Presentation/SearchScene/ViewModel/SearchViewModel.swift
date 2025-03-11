//
//  SearchViewModel.swift
//  SALog
//
//  Created by RAFA on 1/13/25.
//

import RxCocoa
import RxSwift

protocol SearchViewModelProtocol {
    func transform(input: SearchViewModel.Input) -> SearchViewModel.Output
}

final class SearchViewModel: SearchViewModelProtocol {

    // MARK: - Properties

    private let searchNicknameUseCase: SearchNicknameUseCaseProtocol
    private let searchClanUseCase: SearchClanUseCaseProtocol

    private let searchResultsRelay = BehaviorRelay<[SearchResultType]>(value: [])
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let errorMessageRelay = PublishRelay<String>()

    private let disposeBag = DisposeBag()

    // MARK: - Initializer

    init(
        searchNicknameUseCase: SearchNicknameUseCaseProtocol,
        searchClanUseCase: SearchClanUseCaseProtocol
    ) {
        self.searchNicknameUseCase = searchNicknameUseCase
        self.searchClanUseCase = searchClanUseCase
    }

    // MARK: - Input

    struct Input {
        let searchType: Observable<SearchType>
        let query: Observable<String>
    }

    // MARK: - Output

    struct Output {
        let results: Observable<[SearchResultType]>
        let isLoading: Observable<Bool>
        let errorMessage: Observable<String>
    }

    // MARK: - Helpers

    func transform(input: Input) -> Output {
        Observable
            .combineLatest(
                input.searchType,
                input.query.debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            )
            .do(onNext: { [weak self] _, _ in
                self?.isLoadingRelay.accept(true)
            })
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

        return Output(
            results: searchResultsRelay.asObservable(),
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
                    let result = try await self.searchNicknameUseCase.execute(nickname: query)
                    observer.onNext(result.result.characterInfo.map {
                        SearchResultType.nickname($0)
                    })

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
                    let result = try await self.searchClanUseCase.execute(clanName: query)
                    observer.onNext(result.result.clanInfo.map {
                        SearchResultType.clan($0)
                    })

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
}
