//
//  SearchViewModel.swift
//  SALog
//
//  Created by RAFA on 1/13/25.
//

import Foundation

protocol SearchViewModelDelegate: AnyObject {
    func didUpdateSearchResults()
    func didEncounterError(_ error: Error)
}

final class SearchViewModel {

    // MARK: - Properties

    weak var delegate: SearchViewModelDelegate?
    private let searchService: SearchServiceProtocol

    private(set) var searchResults: [User] = []
    private(set) var searchType: SearchType = .nickname

    // MARK: - Initializer

    init(searchService: SearchServiceProtocol = SearchService()) {
        self.searchService = searchService
    }

    // MARK: - Helpers

    func updateSearchType(_ type: SearchType) {
        searchType = type
    }

    func search(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            delegate?.didUpdateSearchResults()
            return
        }

        switch searchType {
        case .nickname:
            searchService.searchByNickname(query) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let characters):
                    self.searchResults = characters
                    self.delegate?.didUpdateSearchResults()
                case .failure(let error):
                    self.delegate?.didEncounterError(error)
                }
            }
        case .clan: break
        }
    }
}
