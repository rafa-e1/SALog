//
//  SearchResult.swift
//  SALog
//
//  Created by RAFA on 3/10/25.
//

import Foundation

struct SearchResult {
    let rtnCode: Int
    let message: String?
    let result: CharacterListResult
}

struct CharacterListResult {
    let characterInfo: [CharacterInfo]
    let totalCount: Int
    let pageNumber: Int
}
