//
//  BaseViewController.swift
//  SALog
//
//  Created by RAFA on 1/3/25.
//

import UIKit

import RxSwift
import SnapKit
import Then

class BaseViewController: UIViewController {

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setStyle()
        setHierarchy()
        setLayout()
    }

    func setStyle() { view.backgroundColor = .background }

    func setHierarchy() {}

    func setLayout() {}
}
