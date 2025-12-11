//
//  BaseRouter+NavTitle.swift
//  iosApp
//
//  Created by Shrouk Yasser on 10/12/2025.
//  Copyright © 2025 orgName. All rights reserved.
//

import UIKit

extension BaseRouter {
    @MainActor func setNavigationTitle(_ title: String) {
        screenVC?.navigationItem.title = title
    }
    
    // MARK: - iOS 14 Compatible Localization
    @MainActor func setNavigationLocalizedTitle(_ key: String) {
        // 'NSLocalizedString' works on all iOS versions
        screenVC?.navigationItem.title = NSLocalizedString(key, comment: "")
    }
}
