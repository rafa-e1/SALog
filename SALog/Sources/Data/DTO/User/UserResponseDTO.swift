//
//  UserResponseDTO.swift
//  SALog
//
//  Created by RAFA on 1/13/25.
//

import Foundation

struct UserResponseDTO: Decodable {
    let userNexonSN: Int?
    let userNickname: String?
    let userImageURL: String?

    enum CodingKeys: String, CodingKey {
        case userNexonSN = "user_nexon_sn"
        case userNickname = "user_nick"
        case userImageURL = "user_img"
    }
}

extension UserResponseDTO {
    
    func toDomain() -> User {
        return User(
            userNexonSN: userNexonSN ?? -1,
            userNickname: userNickname ?? "Unknown",
            userImageURL: userImageURL ?? ""
        )
    }
}
