//
//  ClanInfoResponseDTO.swift
//  SALog
//
//  Created by RAFA on 1/26/25.
//

import Foundation

struct ClanInfoResponseDTO: Decodable {
    let clanID: String
    let clanName: String
    let clanMark1: String
    let clanMark2: String

    enum CodingKeys: String, CodingKey {
        case clanID = "clan_id"
        case clanName = "clan_name"
        case clanMark1 = "clan_mark1"
        case clanMark2 = "clan_mark2"
    }
}
