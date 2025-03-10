//
//  SearchNicknameUseCase.swift
//  SALog
//
//  Created by RAFA on 3/10/25.
//

import Foundation

final class SearchNicknameUseCase {

    private let repository: SearchRepositoryProtocol

    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }

    func execute(nickname: String) async throws -> SearchResult {
        return try await repository.searchByNickname(nickname)
    }
}
