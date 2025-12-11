//
//  SDUIRouter.swift
//  iosApp
//
//  Created by Shrouk Yasser on 10/12/2025.
//

import UIKit
import SwiftUI

final class SDUIRouterImp: @preconcurrency BaseRouter, ObservableObject {
    weak var screenVC: UIViewController?
    
    @MainActor
    static func create(screenId: String) -> UIViewController {
        let router = SDUIRouterImp()
        let view = ScreenView(screenId: screenId)
            .environmentObject(UIClient.shared)
            .environmentObject(router)
        let controller = createVC(with: view, controllerType: SDUIViewController.self)
        controller.router = router
        router.screenVC = controller
        router.setNavigationTitle(screenId.capitalized)
        
        return controller
    }
    
    @MainActor
    static func startApp(initialId: String) {
        let rootVC = SDUIRouterImp.create(screenId: initialId)
        let nav = UINavigationController(rootViewController: rootVC)
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationBar.tintColor = .label
        
        let router = SDUIRouterImp()
        router.setRootVC(nav)
    }
    
    @MainActor
    func handle(_ action: SDUIAction?) {
        guard let action = action else { return }
        
        switch action.type {
        case .navigate:
            if let dest = action.destination {
                pushVC(SDUIRouterImp.create(screenId: dest))
            }
        case .goBack:
            popVC()
        case .reset:
            resetToRoot()
        case .alert:
            if let msg = action.destination {
                presentAlert(message: msg)
            }
        case .openURL:
            if let str = action.destination, let url = URL(string: str) {
                UIApplication.shared.open(url)
            }
        }
    }
}
