//
//  SearchViewModel.swift
//  SALog
//
//  Created by RAFA on 1/13/25.
//

import RxCocoa
import RxSwift

protocol SearchViewModelDelegate: AnyObject {
    func didUpdateSearchResults()
    func didEncounterError(_ error: Error)
}

final class SearchViewModel {

    // MARK: - Properties

    weak var delegate: SearchViewModelDelegate?
    private let searchService: SearchServiceProtocol

    private(set) var searchNicknameResults: [CharacterInfo] = []
    private(set) var searchClanNameResults: [Clan] = []
    private(set) var searchType: SearchType = .nickname
    private var currentQuery: String = ""

    // MARK: - Initializer

    init(searchService: SearchServiceProtocol = SearchService()) {
        self.searchService = searchService
    }

    // MARK: - Helpers

    func updateSearchType(_ type: SearchType) {
        searchType = type
        search(query: currentQuery)
    }

    func search(query: String) {
        currentQuery = query
        guard !query.isEmpty else {
            searchNicknameResults = []
            searchClanNameResults = []
            delegate?.didUpdateSearchResults()
            return
        }

        switch searchType {
        case .nickname:
            searchService.searchByNickname(query) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let characters):
                    self.searchNicknameResults = characters
                    self.delegate?.didUpdateSearchResults()
                case .failure(let error):
                    self.delegate?.didEncounterError(error)
                }
            }
        case .clan:
            searchService.searchByClanName(query) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let clans):
                    self.searchClanNameResults = clans
                    self.delegate?.didUpdateSearchResults()
                case .failure(let error):
                    self.delegate?.didEncounterError(error)
                }
            }
        }
    }
}
