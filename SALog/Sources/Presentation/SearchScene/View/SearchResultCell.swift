//
//  SearchResultCell.swift
//  SALog
//
//  Created by RAFA on 1/16/25.
//

import UIKit

import Kingfisher

final class SearchResultCell: BaseTableViewCell, ConfigurableCell {

    // MARK: - Properties

    typealias DataType = SearchResultType

    private let profileImage = UIImageView()
    private let clanMark1Image = UIImageView()
    private let clanMark2Image = UIImageView()
    private let nameLabel = UILabel()

    // MARK: - Helpers

    func configure(with data: SearchResultType) {
        switch data {
        case .nickname(let characterInfo):
            configureUser(characterInfo)
        case .clan(let clanInfo):
            configureClan(clanInfo)
        }
    }

    private func configureUser(_ characterInfo: CharacterInfo) {
        profileImage.isHidden = false
        clanMark1Image.isHidden = true
        clanMark2Image.isHidden = true

        guard let url = URL(string: characterInfo.userImageURL) else {
            return
        }

        profileImage.kf.setImage(with: url)
        nameLabel.text = characterInfo.userNickname
    }

    private func configureClan(_ clanInfo: ClanInfo) {
        profileImage.isHidden = true
        clanMark1Image.isHidden = false
        clanMark2Image.isHidden = false

        guard let clanMark1URL = URL(string: clanInfo.clanMark1),
              let clanMark2URL = URL(string: clanInfo.clanMark2)
        else {
            return
        }

        clanMark1Image.kf.setImage(with: clanMark1URL)
        clanMark2Image.kf.setImage(with: clanMark2URL)
        nameLabel.text = clanInfo.clanName
    }

    // MARK: - UI

    override func prepareForReuse() {
        super.prepareForReuse()

        profileImage.kf.cancelDownloadTask()
        clanMark1Image.kf.cancelDownloadTask()
        clanMark2Image.kf.cancelDownloadTask()
        profileImage.image = nil
        clanMark1Image.image = nil
        clanMark2Image.image = nil
        nameLabel.text = nil
    }

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
