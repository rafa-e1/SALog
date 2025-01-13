//
//  BaseResponse.swift
//  SALog
//
//  Created by RAFA on 1/13/25.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    let rtnCode: Int
    let message: String
    let result: T?

    enum CodingKeys: CodingKey {
        case rtnCode
        case message
        case result
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rtnCode = try container.decode(Int.self, forKey: .rtnCode)
        message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
        result = try container.decodeIfPresent(T.self, forKey: .result)
    }
}
