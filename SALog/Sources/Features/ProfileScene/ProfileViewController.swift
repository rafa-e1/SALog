//
//  ProfileViewController.swift
//  SALog
//
//  Created by RAFA on 1/3/25.
//

import UIKit

final class ProfileViewController: BaseViewController {

    // MARK: - Properties

    private let copyButton = UIButton(type: .system)

    // MARK: - UI

    override func setStyle() {
        super.setStyle()

        copyButton.do {
            $0.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
            $0.tintColor = .black
        }

        let rightBarButton = UIBarButtonItem(customView: copyButton)
        navigationItem.rightBarButtonItem = rightBarButton
    }
}
