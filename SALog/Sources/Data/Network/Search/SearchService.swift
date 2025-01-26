//
//  SearchService.swift
//  SALog
//
//  Created by RAFA on 1/13/25.
//

import Foundation

protocol SearchServiceProtocol {
    func searchByNickname(
        _ nickname: String,
        completion: @escaping (Result<[User], Error>) -> Void
    )

    func searchByClanName(
        _ clanName: String,
        completion: @escaping (Result<[Clan], Error>) -> Void
    )
}

final class SearchService: SearchServiceProtocol {

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func searchByNickname(
        _ nickname: String,
        completion: @escaping (Result<[User], Error>) -> Void
    ) {
        networkService.request(
            SearchTarget.searchByNickname(nickname: nickname)
        ) { (result: Result<BaseResponse<NicknameSearchResponseDTO>, Error>) in
            switch result {
            case .success(let response):
                guard let characterInfo = response.result?.characterInfo,
                      !characterInfo.isEmpty
                else {
                    print("DEBUG: 캐릭터를 찾을 수 없습니다.")
                    completion(.success([]))
                    return
                }

                let characters = characterInfo.map { $0.toDomain() }
                completion(.success(characters))
            case .failure(let error):
                print("DEBUG: 에러 발생 - \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    func searchByClanName(
        _ clanName: String,
        completion: @escaping (Result<[Clan], any Error>) -> Void
    ) {
        networkService.request(
            SearchTarget.searchByClan(clanName: clanName)
        ) { (result: Result<BaseResponse<ClanNameSearchResponseDTO>, Error>) in
            switch result {
            case .success(let response):
                guard let clanInfo = response.result?.clanInfo,
                      !clanInfo.isEmpty
                else {
                    print("DEBUG: 클랜을 찾을 수 없습니다.")
                    completion(.success([]))
                    return
                }

                let clans = clanInfo.map { $0.toDomain() }
                completion(.success(clans))
            case .failure(let error):
                print("DEBUG: 에러 발생 - \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}
