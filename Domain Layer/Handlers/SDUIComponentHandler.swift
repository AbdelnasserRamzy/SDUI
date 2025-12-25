//
//  SDUIComponentHandler.swift
//  SDUI
//
//  Created by Antigravity on 25/12/2025.
//

import Foundation

protocol SDUIComponentHandler {
    var supportedKey: String { get }
    func enrich(_ component: SDUIComponent) -> SDUIComponent
}

class SDUIComponentRegistry {
    static let shared = SDUIComponentRegistry()
    private var handlers: [SDUIComponentHandler] = []
    
    private init() {
        registerDefaultHandlers()
    }
    
    func register(_ handler: SDUIComponentHandler) {
        handlers.append(handler)
    }
    
    func handle(_ component: SDUIComponent) -> SDUIComponent {
        guard let key = component.key else { return component }
        
        let handler = handlers.first { key.uppercased().contains($0.supportedKey) }
        return handler?.enrich(component) ?? component
    }
    
    private func registerDefaultHandlers() {
        register(FrequentlyBillsHandler())
        register(BannerHandler())
        register(BillViewHandler())
    }
}

class FrequentlyBillsHandler: SDUIComponentHandler {
    let supportedKey = "FREQUENTLY"
    
    func enrich(_ component: SDUIComponent) -> SDUIComponent {
        print("✅ Using handler for Frequently Bills")
        return MockData.frequentlyBills
    }
}

class BannerHandler: SDUIComponentHandler {
    let supportedKey = "BANNER"
    
    func enrich(_ component: SDUIComponent) -> SDUIComponent {
        print("✅ Using handler for Banner")
        return MockData.mainBanner
    }
}

class BillViewHandler: SDUIComponentHandler {
    let supportedKey = "BILL_VIEW"
    
    func enrich(_ component: SDUIComponent) -> SDUIComponent {
        print("✅ Using handler for Bill View")
        return MockData.billView
    }
}
