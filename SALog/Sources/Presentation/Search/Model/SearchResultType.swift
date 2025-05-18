//
//  SearchResultType.swift
//  SALog
//
//  Created by RAFA on 3/10/25.
//

import Foundation

enum SearchResultType {
    case nickname(CharacterInfo)
    case clan(ClanInfo)
}

extension SearchResultType {
    
    func isMatchingType(_ type: SearchType) -> Bool {
        switch (self, type) {
        case (.nickname, .nickname), (.clan, .clan): return true
        default: return false
        }
    }
}
