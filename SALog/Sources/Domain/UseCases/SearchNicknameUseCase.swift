//
//  SearchNicknameUseCase.swift
//  SALog
//
//  Created by RAFA on 3/10/25.
//

import Foundation

protocol SearchNicknameUseCaseProtocol {
    func execute(nickname: String) async throws -> SearchNicknameResult
}

final class SearchNicknameUseCase: SearchNicknameUseCaseProtocol {

    private let repository: SearchRepositoryProtocol

    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }

    func execute(nickname: String) async throws -> SearchNicknameResult {
        return try await repository.searchByNickname(nickname)
    }
}
