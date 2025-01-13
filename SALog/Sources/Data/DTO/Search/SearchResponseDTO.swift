//
//  SearchResponseDTO.swift
//  SALog
//
//  Created by RAFA on 1/13/25.
//

import Foundation

struct SearchResponseDTO: Decodable {
    let characterInfo: [UserResponseDTO]?

    enum CodingKeys: String, CodingKey {
        case characterInfo = "characterInfo"
    }
}
