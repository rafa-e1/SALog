//
//  UIButton+.swift
//  SALog
//
//  Created by RAFA on 1/6/25.
//

import UIKit

extension UIButton {

    func createRadioButton(_ title: String, isSelected: Bool) {
        var configuration = UIButton.Configuration.plain()
        configuration.title = title
        configuration.baseForegroundColor = isSelected ? .systemOrange : .systemGray
        configuration.image = UIImage(
            systemName: isSelected ? "checkmark.circle.fill" : "circle"
        )
        configuration.imagePadding = 8
        configuration.imagePlacement = .leading
        configuration.buttonSize = .medium
        self.configuration = configuration
    }
}
