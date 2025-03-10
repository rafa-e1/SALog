//
//  ClanResponseDTO.swift
//  SALog
//
//  Created by RAFA on 1/26/25.
//

import Foundation

struct ClanResponseDTO: Decodable {
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

extension ClanResponseDTO {

    func toDomain() -> ClanInfo {
        return ClanInfo(
            clanID: clanID,
            clanName: clanName,
            clanMark1: clanMark1,
            clanMark2: clanMark2
        )
    }
}
