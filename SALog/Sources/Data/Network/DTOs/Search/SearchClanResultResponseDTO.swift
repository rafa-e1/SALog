//
//  SearchClanResultResponseDTO.swift
//  SALog
//
//  Created by RAFA on 3/10/25.
//

import Foundation

struct SearchClanResultResponseDTO: Decodable {
    let message: String?
    let result: ClanListResultResponseDTO

    enum CodingKeys: CodingKey {
        case message
        case result
    }
}

struct ClanListResultResponseDTO: Decodable {
    let clanInfo: [ClanInfoResponseDTO]
    let totalCount: Int
    let pageNumber: Int

    enum CodingKeys: String, CodingKey {
        case clanInfo = "clanInfo"
        case totalCount = "total_cnt"
        case pageNumber = "page_no"
    }
}
