//
//  SearchResultCell.swift
//  SALog
//
//  Created by RAFA on 1/16/25.
//

import UIKit

final class SearchResultCell: BaseTableViewCell {

    // MARK: - Properties

    private let nameLabel = UILabel()

    // MARK: - Helpers

    func configure(type: SearchType, user: User? = nil, clan: Clan? = nil) {
        switch type {
        case .nickname:
            guard let user = user else { return }

            nameLabel.text = user.userNickname
        case .clan:
            guard let clan = clan else { return }

            nameLabel.text = clan.clanName
        }
    }

    // MARK: - UI

    override func setStyle() {
        super.setStyle()

        nameLabel.do {
            $0.font = .systemFont(ofSize: 17, weight: .medium)
            $0.textColor = .black
        }
    }

    override func setHierarchy() {
        contentView.addSubview(nameLabel)
    }

    override func setLayout() {
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.left.equalTo(16)
        }
    }
}
