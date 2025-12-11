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

    @MainActor
    func popVC() {
        screenVC?.navigationController?.popViewController(animated: true)
    }
    
    @MainActor
    func resetToRoot() {
        screenVC?.navigationController?.popToRootViewController(animated: true)
    }
    
    @MainActor
    func presentAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        screenVC?.present(alert, animated: true)
    }
}
