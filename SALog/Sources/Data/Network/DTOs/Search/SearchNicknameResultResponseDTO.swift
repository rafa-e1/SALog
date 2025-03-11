//
//  SearchNicknameResultResponseDTO.swift
//  SALog
//
//  Created by RAFA on 3/10/25.
//

import Foundation

struct SearchNicknameResultResponseDTO: Decodable {
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
