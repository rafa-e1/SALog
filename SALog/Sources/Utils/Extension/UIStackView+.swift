//
//  UIStackView+.swift
//  SALog
//
//  Created by RAFA on 1/3/25.
//

import UIKit

extension UIStackView {

    func configureStackView(
        addArrangedSubviews: [UIView]? = nil,
        axis: NSLayoutConstraint.Axis = .vertical,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fillEqually,
        spacing: CGFloat = 0
    ) {
        addArrangedSubviews?.forEach(addArrangedSubview)
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
    }
}
