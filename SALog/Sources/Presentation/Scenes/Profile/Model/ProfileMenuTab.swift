//
//  ProfileMenuTab.swift
//  SALog
//
//  Created by RAFA on 1/12/25.
//

import Foundation

enum ProfileMenuTab: CaseIterable {
    case basicInfo, mapLevel, rankInfo, matchHistory

    var title: String {
        switch self {
        case .basicInfo: return "기본 정보"
        case .mapLevel: return "맵 숙련도"
        case .rankInfo: return "랭크전 정보"
        case .matchHistory: return "매칭 기록"
        }
    }
}
