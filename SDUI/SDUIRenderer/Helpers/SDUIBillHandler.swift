//
//  SDUIBillHandler.swift
//  SDUI
//
//  Created by Shrouk Yasser on 18/12/2025.
//

import Foundation

struct SDUIBillHandler {
    
    enum Layout {
        case vertical
        case horizontal
    }
    
    enum Shape {
        case rounded
        case square
    }
    
    let layout: Layout
    let shape: Shape
    
    init(key: String?) {
        let k = key?.uppercased() ?? ""
        
        // 1. Layout Logic
        if k.contains("HORIZ") || k.contains("SLIDER") {
            self.layout = .horizontal
        } else {
            self.layout = .vertical
        }
        
        // 2. Shape Logic
        if k.contains("SQUARE") {
            self.shape = .square
        } else {
            self.shape = .rounded
        }
    }
}
