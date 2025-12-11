//
//  UIApplication+Extensions.swift
//  iosApp
//
//  Created by Shrouk Yasser on 10/12/2025.


import UIKit.UIApplication

extension UIApplication {
    /// A Boolean value that indicates whether the current user interface layout direction is right-to-left.
    static var isRTL: Bool {
        shared.userInterfaceLayoutDirection == .rightToLeft
    }
}
