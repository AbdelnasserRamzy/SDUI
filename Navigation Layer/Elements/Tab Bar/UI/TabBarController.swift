//
//  TabBarController.swift
//  iosApp
//
//  Created by Shrouk Yasser on 10/12/2025.
//

import UIKit.UITabBarController

// MARK: - TabBarController
final class TabBarController: UITabBarController {
    // MARK: - Views
    private let customTabBarBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 35
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
        view.layer.masksToBounds = false
        return view
    }()
    

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarViews()
        setupTabBarAppearance()
        setupCustomTabBarBackground()
        setupTabBarItems()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutCustomTabBarBackground()
    }
    
    // MARK: - Setup Methods
    private func setupTabBarViews() {
        var views = [UIViewController]()
        for item in TabItem.allCases {
//            let view = NavigationController(rootViewController: item.view)
//            views.append(view)
        }
        viewControllers = views
    }
    
    private func setupTabBarAppearance() {
        tabBar.isTranslucent = true
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.backgroundColor = .clear
        tabBar.tintColor = TabItem.selectedColor
        tabBar.unselectedItemTintColor = TabItem.color
    }
    
    private func setupCustomTabBarBackground() {
        view.addSubview(customTabBarBackground)
        view.bringSubviewToFront(tabBar)
    }
    
    private func layoutCustomTabBarBackground() {
        let tabBarHeight = tabBar.frame.height
        let bottomInset = view.safeAreaInsets.bottom
        
        customTabBarBackground.frame = CGRect(
            x: 12,
            y: view.bounds.height - tabBarHeight - 16,
            width: view.bounds.width - 48,
            height: tabBarHeight-12
        )
        tabBar.frame = customTabBarBackground.frame
    }
    
    private func setupTabBarItems() {
        guard let items = tabBar.items else { return }
        for (index, tabBarItem) in items.enumerated() {
            guard let item = TabItem(rawValue: index) else { continue }
            tabBarItem.title = item.localizedTitle
            tabBarItem.image = item.icon.withRenderingMode(.alwaysTemplate)
            tabBarItem.selectedImage = item.selectedIcon.withRenderingMode(.alwaysOriginal)
            tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
            tabBarItem.imageInsets = UIEdgeInsets(top: -12, left: 0, bottom: 12, right: 0)
        }
    }
}
