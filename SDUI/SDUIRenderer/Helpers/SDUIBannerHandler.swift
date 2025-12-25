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
    
    // ✅ THIS IS THE MAPPING LOGIC
    init(key: String?) {
        let k = key?.uppercased() ?? ""
        
        // Map "Banner_1" -> Slider
        if k.contains("BANNER") || k.contains("SLIDER") {
            self = .slider
        }
        else if k.contains("LIST") {
            self = .list
        }
        else {
            self = .promo
        }
    }
}
