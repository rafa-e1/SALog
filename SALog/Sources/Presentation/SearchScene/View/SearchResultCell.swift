//
//  SearchResultCell.swift
//  SALog
//
//  Created by RAFA on 1/16/25.
//

import UIKit

import Kingfisher

final class SearchResultCell: BaseTableViewCell {

    // MARK: - Properties

    private let profileImage = UIImageView()
    private let nameLabel = UILabel()

    // MARK: - Helpers

    func configure(type: SearchType, user: User? = nil, clan: Clan? = nil) {
        switch type {
        case .nickname:
            guard let user = user else { return }

            setProfileImage(from: user.userImageURL)
            nameLabel.text = user.userNickname
        case .clan:
            guard let clan = clan else { return }

            nameLabel.text = clan.clanName
        }
    }

    private func setProfileImage(from urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            profileImage.image = UIImage(systemName: "person")
            return
        }

        profileImage.kf.setImage(with: url)
    }

    // MARK: - UI

    override func setStyle() {
        super.setStyle()

        profileImage.do {
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 20
        }

        nameLabel.do {
            $0.font = .systemFont(ofSize: 17, weight: .medium)
            $0.textColor = .black
        }
    }

    override func setHierarchy() {
        contentView.addSubviews(profileImage, nameLabel)
    }

    override func setLayout() {
        profileImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(16)
            $0.size.equalTo(40)
        }

        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImage)
            $0.left.equalTo(profileImage.snp.right).offset(10)
        }
    }
}
