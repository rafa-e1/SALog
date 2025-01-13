//
//  BaseView.swift
//  SALog
//
//  Created by RAFA on 1/3/25.
//

import UIKit

import SnapKit
import Then

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        setStyle()
        setHierarchy()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setStyle() { backgroundColor = .background }

    func setHierarchy() {}

    func setLayout() {}
}
