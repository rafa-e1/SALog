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
        ) { (result: Result<BaseResponse<SearchResponseDTO>, Error>) in
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
}
