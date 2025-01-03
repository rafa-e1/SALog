//
//  UIView+.swift
//  SALog
//
//  Created by RAFA on 1/3/25.
//

import UIKit

extension UIView {

    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
