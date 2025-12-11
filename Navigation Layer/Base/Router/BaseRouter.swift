//
//  BaseRouter.swift
//  iosApp
//
//  Created by Shrouk Yasser on 10/12/2025.
//

import SwiftUI
import UIKit.UIViewController

protocol BaseRouter {
    var screenVC: UIViewController? { get }
    
    // Configuration
    static func createVC<Content: View>(with rootView: Content) -> UIViewController
    
    // Navigation Title
    func setNavigationTitle(_ title: String)
    func setNavigationLocalizedTitle(_ title: String)
       
    // Navigation Logic
    func setRootVC(_ viewController: UIViewController)
    func selectTab(at index: Int)
    func pushVC(_ viewController: UIViewController)
}
