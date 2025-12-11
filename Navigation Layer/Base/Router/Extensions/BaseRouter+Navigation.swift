//
//  BaseRouter.swift
//  iosApp
//
//  Created by Shrouk Yasser on 10/12/2025.
//  Copyright © 2025 orgName. All rights reserved.
//


import UIKit.UIViewController

extension BaseRouter {
    @MainActor func setRootVC(_ viewController: UIViewController) {
        if let window =  UIApplication.keyWindow {
            window.rootViewController = viewController
            UIView.transition(
                with: window,
                duration: 0.55,
                options: .transitionCrossDissolve,
                animations: nil,
                completion: nil
            )
        }
    }
    
    @MainActor func selectTab(at index: Int) {
        screenVC?.tabBarController?.selectedIndex = 0
    }
    
    @MainActor func pushVC(_ viewController: UIViewController) {
        screenVC?.navigationController?.pushViewController(
            viewController,
            animated: true
        )
    }
}
