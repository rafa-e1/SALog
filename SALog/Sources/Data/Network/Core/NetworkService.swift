//
//  NetworkService.swift
//  SALog
//
//  Created by RAFA on 1/13/25.
//

import Moya

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ target: TargetType) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {

    private let provider: MoyaProvider<MultiTarget>

    init(provider: MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>()) {
        self.provider = provider
    }

    func request<T: Decodable>(_ target: TargetType) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(MultiTarget(target)) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: response.data)
                        print("DEBUG: Decoded Response - \(decodedData)")
                        continuation.resume(returning: decodedData)
                    } catch {
                        print("DEBUG: Decoding Error - \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    print("DEBUG: Network Request Error - \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
