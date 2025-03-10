//
//  SearchClanUseCase.swift
//  SALog
//
//  Created by RAFA on 3/10/25.
//

import Foundation

protocol SearchClanUseCaseProtocol {
    func execute(clanName: String) async throws -> SearchClanResult
}

final class SearchClanUseCase: SearchClanUseCaseProtocol {

    private let repository: SearchRepositoryProtocol

    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }

    func execute(clanName: String) async throws -> SearchClanResult {
        return try await repository.searchByClan(clanName)
    }
}
