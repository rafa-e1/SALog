//
//  ProfileMenuTabCell.swift
//  SALog
//
//  Created by RAFA on 1/8/25.
//

import UIKit

protocol ProfileMenuTabCellDelegate: AnyObject {
    func didSelectTab(_ cell: ProfileMenuTabCell, index: Int)
}

final class ProfileMenuTabCell: BaseCollectionReusableView {

    // MARK: - Properties

    weak var delegate: ProfileMenuTabCellDelegate?
    private let menuTabs = ProfileMenuTab.allCases
    private var selectedIndex: Int = 0

    // MARK: - UI Properties

    private let menuStackView = UIStackView()
    private var menuButtons: [UIButton] = []

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
        delegate?.didSelectTab(self, index: sender.tag)
        updateSelectedButton(to: sender.tag)
    }

    // MARK: - Helpers

    func configureSelectedTab(_ selectedTab: ProfileMenuTab) {
        let index = menuTabs.firstIndex(of: selectedTab) ?? 0
        updateSelectedButton(to: index)
    }

    private func updateSelectedButton(to index: Int) {
        for (i, button) in menuButtons.enumerated() {
            button.isSelected = (i == index)
            button.setTitleColor(
                button.isSelected ? .black : .lightGray,
                for: .normal
            )
        }
        selectedIndex = index
    }

    private func configureMenuButtons() {
        for (index, tab) in menuTabs.enumerated() {
            let button = UIButton(type: .custom)
            button.setTitle(tab.title, for: .normal)
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
    }

    // MARK: - UI

    override func setStyle() {
        super.setStyle()
        
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
