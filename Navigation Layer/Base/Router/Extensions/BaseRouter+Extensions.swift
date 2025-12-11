//
//  BaseRouter.swift
//  iosApp
//
//  Created by Shrouk Yasser on 10/12/2025.
//  Copyright © 2025 orgName. All rights reserved.
//

import SwiftUI
import UIKit.UIViewController

extension BaseRouter {
    static func createVC<Content: View>(with rootView: Content) -> UIViewController {
        let controller = UIViewController()
        controller.setupHosting(rootView: rootView)
        return controller
    }
}
