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
    private let clanMark1Image = UIImageView()
    private let clanMark2Image = UIImageView()
    private let nameLabel = UILabel()

    // MARK: - Helpers

    func configure(type: SearchType, user: CharacterInfo? = nil, clan: ClanInfo? = nil) {
        switch type {
        case .nickname:
            guard let user = user else { return }

            profileImage.isHidden = false
            clanMark1Image.isHidden = true
            clanMark2Image.isHidden = true
            setProfileImage(from: user.userImageURL)
            nameLabel.text = user.userNickname
        case .clan:
            guard let clan = clan else { return }

            profileImage.isHidden = true
            clanMark1Image.isHidden = false
            clanMark2Image.isHidden = false
            setClanImages(clanMark1: clan.clanMark1, clanMark2: clan.clanMark2)
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

    private func setClanImages(
        clanMark1 clanMark1URLString: String?,
        clanMark2 clanMark2URLString: String?
    ) {
        guard let clanMark1URLString = clanMark1URLString,
              let clanMark2URLString = clanMark2URLString,
              let clanMark1 = URL(string: clanMark1URLString),
              let clanMark2 = URL(string: clanMark2URLString)
        else {
            clanMark1Image.image = UIImage(systemName: "person")
            return
        }

        clanMark1Image.kf.setImage(with: clanMark1)
        clanMark2Image.kf.setImage(with: clanMark2)
    }

    // MARK: - UI

    override func setStyle() {
        super.setStyle()

        [profileImage, clanMark1Image, clanMark2Image].forEach {
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
        contentView.addSubviews(profileImage, clanMark1Image, nameLabel)
        clanMark1Image.addSubview(clanMark2Image)
    }

    override func setLayout() {
        profileImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(16)
            $0.size.equalTo(40)
        }

        clanMark1Image.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(16)
            $0.size.equalTo(40)
        }

        clanMark2Image.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(30)
        }

        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImage)
            $0.left.equalTo(profileImage.snp.right).offset(10)
        }
    }
}
