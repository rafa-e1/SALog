//
//  SearchResultCell.swift
//  SALog
//
//  Created by RAFA on 1/16/25.
//

import UIKit

final class SearchResultCell: BaseTableViewCell {

    // MARK: - Properties

    private let nicknameLabel = UILabel()

    // MARK: - Helpers

    func configure(_ user: User) {
        nicknameLabel.text = user.userNickname
    }

    // MARK: - UI

    override func setStyle() {
        super.setStyle()

        nicknameLabel.do {
            $0.font = .systemFont(ofSize: 17, weight: .medium)
            $0.textColor = .black
        }
    }

    override func setHierarchy() {
        contentView.addSubview(nicknameLabel)
    }

    override func setLayout() {
        nicknameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.left.equalTo(16)
        }
    }
}
