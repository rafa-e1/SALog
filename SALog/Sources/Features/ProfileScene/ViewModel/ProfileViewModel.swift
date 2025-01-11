//
//  ProfileViewModel.swift
//  SALog
//
//  Created by RAFA on 1/12/25.
//

import Foundation

final class ProfileViewModel {

    // MARK: - Properties

    private(set) var selectedTab: ProfileMenuTab = .basicInfo {
        didSet { onTabChanged?(selectedTab) }
    }

    var onTabChanged: ((ProfileMenuTab) -> Void)?

    // MARK: - Helpers

    func changeTab(to tab: ProfileMenuTab) {
        guard selectedTab != tab else { return }
        selectedTab = tab
    }
}
