//
//  SearchUseCase.swift
//  SALog
//
//  Created by RAFA on 3/11/25.
//

import Foundation

protocol SearchUseCaseProtocol {
    func searchByNickname(_ nickname: String) async throws -> SearchNicknameResult
    func searchByClan(_ clanName: String) async throws -> SearchClanResult
}

final class SearchUseCase: SearchUseCaseProtocol {

    private let repository: SearchRepositoryProtocol

    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }

    func searchByNickname(_ nickname: String) async throws -> SearchNicknameResult {
        try await repository.searchByNickname(nickname)
    }

    func searchByClan(_ clanName: String) async throws -> SearchClanResult {
        try await repository.searchByClan(clanName)
    }
}
