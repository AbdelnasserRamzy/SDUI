//
//  SDUIBillHandler.swift
//  SDUI
//
//  Created by Shrouk Yasser on 18/12/2025.
//

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
        
        // 1. Check for "Frequently" -> Horizontal Scroll
        if k.contains("FREQUENTLY") {
            self.layout = .horizontal
            self.shape = .rounded
        }
        // 2. Check for "BILL_VIEW" -> Vertical List
        else if k.contains("BILL_VIEW") {
            self.layout = .vertical
            self.shape = .square
        }
        // 3. Defaults / Fallbacks
        else {
            self.layout = .vertical
            self.shape = .rounded
        }
    }
}
