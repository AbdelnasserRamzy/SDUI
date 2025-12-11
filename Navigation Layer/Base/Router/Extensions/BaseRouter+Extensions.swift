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
    static func createVC<Content: View, T: UIViewController>(
        with rootView: Content,
        controllerType: T.Type = T.self
      ) -> T {
        let controller = T()
        controller.setupHosting(rootView: rootView)
        return controller
    }
}
