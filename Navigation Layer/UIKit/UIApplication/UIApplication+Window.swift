//
//  UIApplication+Window.swift
//  iosApp
//
//  Created by Shrouk Yasser on 10/12/2025.
//  Copyright © 2025 orgName. All rights reserved.
//

import UIKit.UIApplication

extension UIApplication {
    static var keyWindow: UIWindow? {
        shared
            .connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter { $0.isKeyWindow }
            .first
    }
    
    static var keyWindowScene: UIWindowScene? {
        shared.connectedScenes.first as? UIWindowScene
    }
    
    static var rootVC: UIViewController? {
        keyWindowScene?
            .windows
            .first?
            .rootViewController
    }
}
