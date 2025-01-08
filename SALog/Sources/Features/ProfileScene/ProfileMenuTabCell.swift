//
//  ProfileMenuTabCell.swift
//  SALog
//
//  Created by RAFA on 1/8/25.
//

import UIKit

final class ProfileMenuTabCell: BaseCollectionReusableView {

    // MARK: - Properties

    private let menuStackView = UIStackView()
    private var menuButtons: [UIButton] = []

    private let menu = ["기본 정보", "맵 숙련도", "랭크전 정보", "매칭 기록"]
    private var selectedIndex: Int = 0

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureMenuButtons()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc private func handleButtonTap(_ sender: UIButton) {
        updateSelectedButton(to: sender.tag)
    }

    // MARK: - Helpers

    private func updateSelectedButton(to index: Int) {
        menuButtons[selectedIndex].isSelected = false
        selectedIndex = index
        menuButtons[selectedIndex].isSelected = true
    }

    private func configureMenuButtons() {
        for (index, title) in menu.enumerated() {
            let button = UIButton(type: .custom)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.black, for: .selected)
            button.setTitleColor(.lightGray, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            button.tag = index
            button.addTarget(
                self,
                action: #selector(handleButtonTap),
                for: .touchUpInside
            )

            menuStackView.addArrangedSubview(button)
            menuButtons.append(button)
        }

        updateSelectedButton(to: 0)
    }

    // MARK: - UI

    override func setStyle() {
        menuStackView.configureStackView(
            axis: .horizontal,
            spacing: 10
        )
    }

    override func setHierarchy() {
        addSubview(menuStackView)
    }

    override func setLayout() {
        menuStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
