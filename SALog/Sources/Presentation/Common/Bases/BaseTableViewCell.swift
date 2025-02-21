//
//  BaseTableViewCell.swift
//  SALog
//
//  Created by RAFA on 1/16/25.
//

import UIKit

import SnapKit
import Then

class BaseTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setStyle()
        setHierarchy()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setStyle() { contentView.backgroundColor = .background }

    func setHierarchy() {}

    func setLayout() {}
}
