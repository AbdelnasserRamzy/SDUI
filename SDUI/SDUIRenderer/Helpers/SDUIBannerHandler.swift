//
//  SDUIBannerHandler.swift
//  SDUI
//
//  Created by Shrouk Yasser on 18/12/2025.
//

import Foundation

// MARK: - Banner Type Logic
struct SDUIBannerHandler {
    let type: BannerType
    
    init(key: String?) {
        self.type = BannerType(key: key)
    }
}

// MARK: - Banner Types
enum BannerType {
    case slider  // Horizontal
    case list    // Vertical
    case promo   // Static
    
    init(key: String?) {
        switch key?.uppercased() {
        case "HORIZONTAL", "SLIDER": self = .slider
        case "VERTICAL", "LIST":     self = .list
        default:                     self = .promo
        }
    }
}
