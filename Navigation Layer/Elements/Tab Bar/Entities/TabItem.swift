//

//  SplashRouter.swift
//  iosApp
//
//  Created by Shrouk Yasser on 10/12/2025.
//  Copyright © 2025 orgName. All rights reserved.
//



import UIKit

enum TabItem: Int {
    case home
    case more
}

// MARK: - Extensions
extension TabItem: CaseIterable {}

// MARK: - View Controllers
extension TabItem {
    @MainActor var view: UIViewController {
        switch self {
        case .home:
            HomeRouterImp.create()
        case .more:
            MoreRouterImp.create()
        }
    }
}

// MARK: - UI Helpers
extension TabItem {
    var localizedTitle: String {
        switch self {
        case .home:
            return "Home"
        case .more:
            return "More"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .home:
            return UIImage(systemName: "house")!
        case .more:
            return UIImage(systemName: "ellipsis")!
        }
    }
    
    var selectedIcon: UIImage {
        switch self {
        case .home:
            return UIImage(systemName: "house.fill")!
        case .more:
            return UIImage(systemName: "ellipsis.circle.fill")!
        }
    }
    
    static var color: UIColor {
        return UIColor.darkGray
    }
    
    static var selectedColor: UIColor {
        return UIColor.systemYellow
    }
}

//
//  HomeRouterImp.swift
//  iosApp
//
//  Created by Shrouk Yasser on 10/12/2025.
//

import UIKit

final class HomeRouterImp {
    @MainActor
    static func create() -> UIViewController {
        // Start Home Tab with the "home" screen ID
        return SDUIRouterImp.create(screenId: "home")
    }
}

final class MoreRouterImp {
    @MainActor
    static func create() -> UIViewController {
        // Start More Tab with a "more" or "profile" screen ID
        return SDUIRouterImp.create(screenId: "profile")
    }
}
