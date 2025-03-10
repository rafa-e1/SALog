//
//  CharacterInfoResponseDTO.swift
//  SALog
//
//  Created by RAFA on 1/13/25.
//

import Foundation

struct CharacterInfoResponseDTO: Decodable {
    let userNexonSN: Int
    let userNickname: String
    let userImageURL: String

    enum CodingKeys: String, CodingKey {
        case userNexonSN = "user_nexon_sn"
        case userNickname = "user_nick"
        case userImageURL = "user_img"
    }
}

extension CharacterInfoResponseDTO {

    func toDomain() -> CharacterInfo {
        return CharacterInfo(
            userNexonSN: userNexonSN,
            userNickname: userNickname,
            userImageURL: userImageURL
        )
    }
}
