//
//  SearchRepositoryProtocol.swift
//  SALog
//
//  Created by RAFA on 3/10/25.
//

import Foundation

protocol SearchRepositoryProtocol {
    func searchByNickname(_ nickname: String) async throws -> SearchNicknameResult
}
