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

    func searchByNickname(_ nickname: String, page: Int) async throws -> SearchNicknameResult {
        let response: SearchNicknameResultResponseDTO = try await network.request(
            SearchEndPoint.searchByNickname(nickname: nickname, page: page)
        )

        return response.toDomain()
    }

    func searchByClan(_ clanName: String, page: Int) async throws -> SearchClanResult {
        let response: SearchClanResultResponseDTO = try await network.request(
            SearchEndPoint.searchByClan(clanName: clanName, page: page)
        )

        return response.toDomain()
    }
}
