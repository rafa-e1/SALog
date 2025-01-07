//
//  ProfileImageFullScreenView.swift
//  SALog
//
//  Created by RAFA on 1/7/25.
//

import UIKit

final class ProfileImageFullScreenView: BaseViewController {

    // MARK: - Properties

    private let closeButton = UIButton(type: .system)
    private let imageView = UIImageView()

    var image: UIImage? {
        didSet { imageView.image = image }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setAddTargets()
        setTapGestures()
    }

    // MARK: - Actions

    @objc private func dismissFullScreen() {
        dismiss(animated: true)
    }

    // MARK: - Helpers

    private func setAddTargets() {
        closeButton.addTarget(
            self,
            action: #selector(dismissFullScreen),
            for: .touchUpInside
        )
    }

    private func setTapGestures() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissFullScreen)
        )

        view.addGestureRecognizer(tapGesture)
    }

    // MARK: - UI

    override func setStyle() {
        super.setStyle()

        closeButton.setImage(
            UIImage(systemName: "xmark.circle.fill")?
                .withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
                .applyingSymbolConfiguration(
                    UIImage.SymbolConfiguration(
                        pointSize: 40,
                        weight: .medium
                    )
                ),
            for: .normal
        )

        imageView.do {
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .darkGray
            $0.isUserInteractionEnabled = true
        }
    }

    override func setHierarchy() {
        view.addSubview(imageView)
        imageView.addSubview(closeButton)
    }

    override func setLayout() {
        closeButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.right.equalTo(-20)
        }

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
