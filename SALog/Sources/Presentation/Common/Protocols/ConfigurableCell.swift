//
//  ConfigurableCell.swift
//  SALog
//
//  Created by RAFA on 3/12/25.
//

import Foundation

protocol ConfigurableCell {
    associatedtype DataType
    func configure(with data: DataType)
}
