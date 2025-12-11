//
//  UIScreen+Sizes.swift
//  iosApp
//
//  Created by Shrouk Yasser on 10/12/2025.
//  Copyright © 2025 orgName. All rights reserved.
//


import UIKit.UIScreen

extension UIScreen {
    static private var current: UIScreen? { UIApplication.keyWindow?.screen }
    static var width: CGFloat { current?.bounds.width ?? 0 }
    static var height: CGFloat { current?.bounds.height ?? 0 }
}
