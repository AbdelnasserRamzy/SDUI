//
//  SDUIRouter.swift
//  iosApp
//
//  Created by Shrouk Yasser on 10/12/2025.
//

import UIKit
import SwiftUI

class SDUIHostingController<Content: View>: UIHostingController<Content> {
    var router: AnyObject?
    var delegate: AnyObject?
}

protocol SDUIRouter: BaseRouter {
    @MainActor func navigateToScreen(id: String)
}

final class SDUIRouterImp: SDUIRouter {
    weak var screenVC: UIViewController?
    
    @MainActor
    static func create(screenId: String) -> UIViewController {
        let router = SDUIRouterImp()
        let delegate = SDUINavigationDelegate()
        
        let screenView = ScreenView(screenId: screenId)
            .environmentObject(UIClient.shared)
            .environmentObject(delegate)
        
        let controller = SDUIHostingController(rootView: screenView)
        controller.router = router
        controller.delegate = delegate
        router.screenVC = controller
        
        controller.title = screenId.capitalized
        controller.navigationItem.largeTitleDisplayMode = .automatic
        
        // Navigation Actions
        delegate.onNavigate = { [weak router] nextId in
            router?.navigateToScreen(id: nextId)
        }
        delegate.onBack = { [weak router] in
            router?.screenVC?.navigationController?.popViewController(animated: true)
        }
        delegate.onReset = { [weak router] in
            router?.screenVC?.navigationController?.popToRootViewController(animated: true)
        }
        
        // MARK: - FIX: Handle Alert via UIKit
        delegate.onAlert = { [weak router] message in
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            // Present on the current View Controller
            router?.screenVC?.present(alert, animated: true)
        }
        
        return controller
    }
    
    @MainActor
    func navigateToScreen(id: String) {
        let nextVC = SDUIRouterImp.create(screenId: id)
        screenVC?.navigationController?.pushViewController(nextVC, animated: true)
    }
}
