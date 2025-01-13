//
//  NetworkService.swift
//  SALog
//
//  Created by RAFA on 1/13/25.
//

import Moya

protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        _ target: TargetType,
        completion: @escaping (Result<T, Error>) -> Void
    )
}

final class NetworkService: NetworkServiceProtocol {

    private let provider: MoyaProvider<MultiTarget>

    init(provider: MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>()) {
        self.provider = provider
    }

    func request<T: Decodable>(
        _ target: TargetType,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        provider.request(MultiTarget(target)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(
                        T.self,
                        from: response.data
                    )
                    print("DEBUG: Decoded Data - \(decodedData)")
                    completion(.success(decodedData))
                } catch {
                    print("DEBUG: Decoding error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
