//
//  ProfileCell.swift
//  SALog
//
//  Created by RAFA on 1/7/25.
//

import UIKit

final class ProfileCell: BaseCollectionViewCell {

    // MARK: - Properties

    private let followerTitle = UILabel()
    private let followerCountLabel = UILabel()
    private let followerStackView = UIStackView()

    private let mannerLevelCircularView = UIView()
    private let profileImageView = UIImageView()

    private let nicknameLabel = UILabel()
    private let clanNameLabel = UILabel()
    private let officialClanImageView = UIImageView()
    private let clanStackView = UIStackView()

    private let blackListTitle = UILabel()
    private let blackListCountLabel = UILabel()
    private let blackListStackView = UIStackView()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setTapGestures()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc private func handleImageTap() {
        let fullScreen = ProfileImageFullScreenView()
        fullScreen.modalTransitionStyle = .crossDissolve
        fullScreen.modalPresentationStyle = .overFullScreen
        fullScreen.image = profileImageView.image
        window?.rootViewController?.present(fullScreen, animated: true)
    }

    // MARK: - Helpers

    private func setTapGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleImageTap))
        profileImageView.addGestureRecognizer(tap)
    }

    // MARK: - UI

    override func setStyle() {
        followerTitle.do {
            $0.text = "팔로워"
            $0.textColor = .lightGray
            $0.font = .systemFont(ofSize: 15, weight: .regular)
            $0.textAlignment = .center
        }

        followerCountLabel.do {
            $0.text = "576"
            $0.textColor = .label
            $0.font = .systemFont(ofSize: 20, weight: .semibold)
            $0.textAlignment = .center
        }

        followerStackView.configureStackView(
            addArrangedSubviews: [followerTitle, followerCountLabel]
        )

        mannerLevelCircularView.do {
            // TODO: 매너 레벨에 따라 다른 배경색 표시
            $0.backgroundColor = .best
//            $0.backgroundColor = .veryGood
//            $0.backgroundColor = .good
//            $0.backgroundColor = .normal
//            $0.backgroundColor = .bad
//            $0.backgroundColor = .concerned
//            $0.backgroundColor = .worst
            $0.layer.cornerRadius = 108 / 2
            $0.clipsToBounds = true
        }

        profileImageView.do {
            $0.image = UIImage(systemName: "questionmark.circle.dashed")
            $0.tintColor = .darkGray
            $0.backgroundColor = .background
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 100 / 2
            $0.clipsToBounds = true
            $0.isUserInteractionEnabled = true
        }

        nicknameLabel.do {
            $0.text = "지올"
            $0.textColor = .label
            $0.font = .systemFont(ofSize: 20, weight: .medium)
            $0.textAlignment = .center
        }

        clanNameLabel.do {
            $0.text = "grim"
            $0.textColor = .lightGray
            $0.font = .systemFont(ofSize: 15, weight: .medium)
            $0.textAlignment = .center
        }

        officialClanImageView.do {
            $0.image = .officialClanBadge
            $0.contentMode = .scaleAspectFit
        }

        clanStackView.configureStackView(
            addArrangedSubviews: [clanNameLabel, officialClanImageView],
            axis: .horizontal,
            alignment: .center,
            distribution: .fill,
            spacing: 5
        )

        blackListTitle.do {
            $0.text = "블랙 리스트"
            $0.textColor = .lightGray
            $0.font = .systemFont(ofSize: 15, weight: .regular)
            $0.textAlignment = .center
        }

        blackListCountLabel.do {
            $0.text = "35"
            $0.textColor = .label
            $0.font = .systemFont(ofSize: 20, weight: .semibold)
            $0.textAlignment = .center
        }

        blackListStackView.configureStackView(
            addArrangedSubviews: [blackListTitle, blackListCountLabel]
        )
    }

    override func setHierarchy() {
        contentView.addSubviews(
            followerStackView,
            mannerLevelCircularView,
            profileImageView,
            nicknameLabel,
            clanStackView,
            blackListStackView
        )
    }

    override func setLayout() {
        followerStackView.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.left.equalTo(16)
        }

        mannerLevelCircularView.snp.makeConstraints {
            $0.center.equalTo(profileImageView)
            $0.size.equalTo(108)
        }

        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            $0.left.equalTo(followerStackView.snp.right).offset(16)
            $0.size.equalTo(100)
        }

        nicknameLabel.snp.makeConstraints {
            $0.centerX.equalTo(profileImageView)
            $0.top.equalTo(profileImageView.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        officialClanImageView.snp.makeConstraints {
            $0.size.equalTo(15)
        }

        clanStackView.snp.makeConstraints {
            $0.centerX.equalTo(nicknameLabel)
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(5)
        }

        blackListStackView.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.left.equalTo(profileImageView.snp.right).offset(16)
            $0.right.equalTo(-16)
        }
    }
}
