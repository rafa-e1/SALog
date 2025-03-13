//
//  SearchUseCase.swift
//  SALog
//
//  Created by RAFA on 3/11/25.
//

import Foundation

protocol SearchUseCaseProtocol {
    func searchByNickname(_ nickname: String, page: Int) async throws -> SearchNicknameResult
    func searchByClan(_ clanName: String, page: Int) async throws -> SearchClanResult
}

final class SearchUseCase: SearchUseCaseProtocol {

    private let repository: SearchRepositoryProtocol

    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }

    func searchByNickname(_ nickname: String, page: Int) async throws -> SearchNicknameResult {
        try await repository.searchByNickname(nickname, page: page)
    }

    func searchByClan(_ clanName: String, page: Int) async throws -> SearchClanResult {
        try await repository.searchByClan(clanName, page: page)
    }
}
