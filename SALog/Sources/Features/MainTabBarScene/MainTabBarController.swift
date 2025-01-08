//
//  MainTabBarController.swift
//  SALog
//
//  Created by RAFA on 1/3/25.
//

import UIKit

final class MainTabBarController: UITabBarController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewControllers()
    }

    // MARK: - Helpers

    private func configureViewControllers() {
        let search = createNavigationController(
            title: "",
            unselectedImage: "magnifyingglass",
            selectedImage: "magnifyingglass",
            rootViewController: SearchViewController()
        )
        search.setNavigationBarHidden(true, animated: false)

        let blackList = createNavigationController(
            title: "",
            unselectedImage: "person.crop.circle.badge.xmark",
            selectedImage: "person.crop.circle.badge.xmark",
            rootViewController: BlackListViewController()
        )

        let profile = createNavigationController(
            title: "",
            unselectedImage: "person",
            selectedImage: "person.fill",
            rootViewController: ProfileViewController()
        )

        viewControllers = [search, blackList, profile]
    }

    private func createNavigationController(
        title: String,
        unselectedImage: String,
        selectedImage: String,
        rootViewController: UIViewController
    ) -> UINavigationController {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .background
        appearance.shadowImage = UIImage()
        appearance.shadowColor = nil

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .systemOrange

        let tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: unselectedImage),
            selectedImage: UIImage(systemName: selectedImage)
        )

        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem = tabBarItem
        navigationController.navigationBar.tintColor = .black
        navigationController.navigationBar.topItem?.title = ""

        return navigationController
    }
}
