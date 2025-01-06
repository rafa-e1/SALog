//
//  SearchView.swift
//  SALog
//
//  Created by RAFA on 1/6/25.
//

import UIKit

final class SearchView: BaseView {

    // MARK: - Properties

    private let textField = UITextField()
    private let leftImageView = UIImageView()
    private let leftView = UIView()

    // MARK: - UI

    override func setStyle() {
        textField.do {
            $0.placeholder = "닉네임을 입력해주세요"
            $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            $0.textColor = .darkGray
            $0.clearButtonMode = .whileEditing
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 12
            $0.layer.masksToBounds = true
            $0.tintColor = .black
            $0.leftView = leftView
            $0.leftViewMode = .always
        }

        leftImageView.do {
            $0.image = UIImage(systemName: "magnifyingglass")
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .systemGray
        }

        self.do {
            $0.layer.cornerRadius = 12
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.2
            $0.layer.shadowOffset = CGSize(width: 0, height: 4)
            $0.layer.shadowRadius = 4
            $0.layer.masksToBounds = false
            $0.backgroundColor = .white
        }
    }

    override func setHierarchy() {
        leftView.addSubview(leftImageView)
        addSubview(textField)
    }

    override func setLayout() {
        leftImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(24)
        }

        leftView.snp.makeConstraints {
            $0.size.equalTo(40)
        }

        textField.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
            $0.height.equalTo(40)
        }
    }

    // MARK: - Helpers

    func updatePlaceholder(_ placeholder: String) {
        textField.placeholder = placeholder
    }
}
