//
//  ClanNameSearchResponseDTO.swift
//  SALog
//
//  Created by RAFA on 1/26/25.
//

import Foundation

struct ClanNameSearchResponseDTO: Decodable {
    let clanInfo: [ClanResponseDTO]?

    enum CodingKeys: String, CodingKey {
        case clanInfo = "clanInfo"
    }
}
