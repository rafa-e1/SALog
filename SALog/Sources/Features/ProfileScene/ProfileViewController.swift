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
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    )

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBarButtonItems()
        setDelegates()
        registerCells()
    }

    // MARK: - Helpers

    private func setDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func registerCells() {
        collectionView.register(
            ProfileCell.self,
            forCellWithReuseIdentifier: ProfileCell.identifier
        )
    }

    // MARK: - UI

    private func setNavigationBarButtonItems() {
        let rightBarButton = UIBarButtonItem(customView: copyButton)
        navigationItem.rightBarButtonItem = rightBarButton
    }

    override func setStyle() {
        copyButton.do {
            $0.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
            $0.tintColor = .black
        }

        collectionView.backgroundColor = .background
    }

    override func setHierarchy() {
        view.addSubview(collectionView)
    }

    override func setLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileViewController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileCell.identifier,
            for: indexPath
        ) as? ProfileCell else {
            return UICollectionViewCell()
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileViewController: UICollectionViewDelegate {}

// MARK: - UICollectionViewCompositionalLayout

private extension ProfileViewController {

    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }

    func sectionProvider(
        sectionIndex: Int,
        environment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)

        return section
    }
}
