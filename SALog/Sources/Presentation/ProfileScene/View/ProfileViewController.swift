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

    private let userNickname = "지올"
    private var isTitleSet = false
    private let viewModel: ProfileViewModel

    // MARK: - Initializer

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        bindings()
        setNavigationBarStyle()
        setDelegates()
        registerCells()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Bindings

    private func bindings() {
        viewModel.onTabChanged = { [weak self] _ in
            self?.collectionView.reloadData()
        }
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

        collectionView.register(
            ProfileMenuTabReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileMenuTabReusableView.identifier
        )

        collectionView.register(
            ProfileBasicInfoCell.self,
            forCellWithReuseIdentifier: ProfileBasicInfoCell.identifier
        )

        collectionView.register(
            ProfileMapLevelCell.self,
            forCellWithReuseIdentifier: ProfileMapLevelCell.identifier
        )

        collectionView.register(
            ProfileRankInfoCell.self,
            forCellWithReuseIdentifier: ProfileRankInfoCell.identifier
        )

        collectionView.register(
            ProfileMatchHistoryCell.self,
            forCellWithReuseIdentifier: ProfileMatchHistoryCell.identifier
        )
    }

    // MARK: - UI

    private func setNavigationBarStyle() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .background
        appearance.shadowColor = nil

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isTranslucent = false

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

// MARK: - UIScrollViewDelegate

extension ProfileViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let triggerOffset: CGFloat = 200
        let currentOffset = scrollView.contentOffset.y

        if currentOffset > triggerOffset && !isTitleSet {
            navigationItem.title = userNickname
            isTitleSet = true
        } else if currentOffset <= triggerOffset && isTitleSet {
            navigationItem.title = nil
            isTitleSet = false
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

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
        if indexPath.section == 0 {
            return collectionView.dequeueReusableCell(
                withReuseIdentifier: ProfileCell.identifier,
                for: indexPath
            )
        } else {
            switch viewModel.selectedTab {
            case .basicInfo:
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: ProfileBasicInfoCell.identifier,
                    for: indexPath
                )
            case .mapLevel:
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: ProfileMapLevelCell.identifier,
                    for: indexPath
                )
            case .rankInfo:
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: ProfileRankInfoCell.identifier,
                    for: indexPath
                )
            case .matchHistory:
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: ProfileMatchHistoryCell.identifier,
                    for: indexPath
                )
            }
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader && indexPath.section == 1 {
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ProfileMenuTabReusableView.identifier,
                for: indexPath
            ) as? ProfileMenuTabReusableView else {
                return UICollectionReusableView()
            }

            header.delegate = self
            header.configureSelectedTab(viewModel.selectedTab)

            return header
        }
        return UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileViewController: UICollectionViewDelegate {}

// MARK: - UICollectionViewCompositionalLayout

private extension ProfileViewController {

    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch sectionIndex {
            case 0:
                return self.createProfileSection()
            case 1:
                return self.createContentSection()
            default:
                return nil
            }
        }
    }

    private func createProfileSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)

        return section
    }

    private func createMenuTabSection() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )

        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        headerItem.pinToVisibleBounds = true

        return headerItem
    }

    private func createContentSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [createMenuTabSection()]

        return section
    }
}

// MARK: - ProfileMenuTabDelegate

extension ProfileViewController: ProfileMenuTabDelegate {

    func didSelectTab(_ cell: ProfileMenuTabReusableView, index: Int) {
        let selectedTab = ProfileMenuTab.allCases[index]
        viewModel.changeTab(to: selectedTab)
    }
}
