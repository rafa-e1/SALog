//
//  SearchViewController.swift
//  SALog
//
//  Created by RAFA on 1/3/25.
//

import UIKit

final class SearchViewController: BaseViewController {

    // MARK: - Properties

    private let nicknameButton = UIButton()
    private let clanNameButton = UIButton()
    private let radioButtonsStackView = UIStackView()
    private let searchBar = SearchView()

    private var isNicknameSelected = true {
        didSet { updateUIForSelection() }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setAddTargets()
    }

    // MARK: - Actions

    @objc private func nicknameButtonTapped() {
        guard !isNicknameSelected else { return }
        isNicknameSelected = true
    }

    @objc private func clanNameButtonTapped() {
        guard isNicknameSelected else { return }
        isNicknameSelected = false
    }

    // MARK: - UI

    override func setStyle() {
        super.setStyle()

        nicknameButton.createRadioButton("닉네임", isSelected: isNicknameSelected)
        clanNameButton.createRadioButton("클랜명", isSelected: !isNicknameSelected)

        radioButtonsStackView.configureStackView(
            addArrangedSubviews: [nicknameButton, clanNameButton],
            axis: .horizontal,
            alignment: .trailing
        )
    }

    override func setHierarchy() {
        view.addSubviews(radioButtonsStackView, searchBar)
    }

    override func setLayout() {
        radioButtonsStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.right.equalTo(-16)
        }

        searchBar.snp.makeConstraints {
            $0.top.equalTo(radioButtonsStackView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    // MARK: - Helpers

    private func setAddTargets() {
        nicknameButton.addTarget(
            self,
            action: #selector(nicknameButtonTapped),
            for: .touchUpInside
        )

        clanNameButton.addTarget(
            self,
            action: #selector(clanNameButtonTapped),
            for: .touchUpInside
        )
    }

    private func updateUIForSelection() {
        UIView.animate(withDuration: 0.3) {
            self.nicknameButton.createRadioButton(
                "닉네임",
                isSelected: self.isNicknameSelected
            )

            self.clanNameButton.createRadioButton(
                "클랜명",
                isSelected: !self.isNicknameSelected
            )

            self.searchBar.updatePlaceholder(
                self.isNicknameSelected ? "닉네임을 입력해 주세요" : "클랜명을 입력해 주세요"
            )
        }
    }
}
