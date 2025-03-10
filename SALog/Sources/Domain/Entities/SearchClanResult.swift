//
//  SearchClanResult.swift
//  SALog
//
//  Created by RAFA on 3/10/25.
//

import Foundation

struct SearchClanResult {
    let message: String?
    let result: ClanListResult
}

struct ClanListResult {
    let clanInfo: [ClanInfo]
    let totalCount: Int
    let pageNumber: Int
}
