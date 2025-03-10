//
//  SearchRepository.swift
//  SALog
//
//  Created by RAFA on 3/10/25.
//

import Foundation

final class SearchRepository: SearchRepositoryProtocol {

    private let network: NetworkServiceProtocol

    init(network: NetworkServiceProtocol) {
        self.network = network
    }

    func searchByNickname(_ nickname: String) async throws -> SearchNicknameResult {
        let response: SearchResultResponseDTO = try await network.request(
            SearchTarget.searchByNickname(nickname: nickname)
        )

        return response.toDomain()
    }
}
