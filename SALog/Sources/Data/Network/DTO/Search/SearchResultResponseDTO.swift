//
//  SearchResultResponseDTO.swift
//  SALog
//
//  Created by RAFA on 3/10/25.
//

import Foundation

struct SearchResultResponseDTO: Decodable {
    let rtnCode: Int
    let message: String?
    let result: CharacterListResultResponseDTO

    enum CodingKeys: CodingKey {
        case rtnCode
        case message
        case result
    }
}

struct CharacterListResultResponseDTO: Decodable {
    let characterInfo: [CharacterInfoResponseDTO]
    let totalCount: Int
    let pageNumber: Int

    enum CodingKeys: String, CodingKey {
        case characterInfo = "characterInfo"
        case totalCount = "total_cnt"
        case pageNumber = "page_no"
    }
}

extension SearchResultResponseDTO {

    func toDomain() -> SearchNicknameResult {
        return .init(rtnCode: rtnCode, message: message, result: result.toDomain())
    }
}

extension CharacterListResultResponseDTO {

    func toDomain()-> CharacterListResult {
        return .init(
            characterInfo: characterInfo.map { $0.toDomain() },
            totalCount: totalCount,
            pageNumber: pageNumber
        )
    }
}
