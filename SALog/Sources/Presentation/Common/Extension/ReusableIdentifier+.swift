//
//  ReusableIdentifier+.swift
//  SALog
//
//  Created by RAFA on 1/3/25.
//

import UIKit

protocol ReusableIdentifier: AnyObject { }

extension ReusableIdentifier where Self: UIView {

    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: ReusableIdentifier { }
extension UITableViewCell: ReusableIdentifier { }
