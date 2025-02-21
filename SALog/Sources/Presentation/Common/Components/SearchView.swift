//
//  SearchView.swift
//  SALog
//
//  Created by RAFA on 1/6/25.
//

import UIKit

protocol SearchViewDelegate: AnyObject {
    func didChangeSearchText(_ text: String)
}

final class SearchView: BaseView {

    // MARK: - Properties

    weak var delegate: SearchViewDelegate?

    let textField = UITextField()
    private let leftImageView = UIImageView()
    private let leftView = UIView()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setAddTargets()
        setDelegates()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc private func textFieldDidChange() {
        delegate?.didChangeSearchText(textField.text ?? "")
    }

    // MARK: - Helpers

    private func setAddTargets() {
        textField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
    }

    private func setDelegates() {
        textField.delegate = self
    }

    // MARK: - UI

    override func setStyle() {
        textField.do {
            $0.placeholder = "닉네임을 입력해 주세요"
            $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            $0.textColor = .darkGray
            $0.clearButtonMode = .whileEditing
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 12
            $0.layer.masksToBounds = true
            $0.tintColor = .black
            $0.leftView = leftView
            $0.leftViewMode = .always
            $0.spellCheckingType = .no
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
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

// MARK: - UITextFieldDelegate

extension SearchView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
