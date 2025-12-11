//
//  SDUINavigationDelegate.swift
//  SDUI
//
//  Created by Shrouk Yasser on 10/12/2025.
//


import Foundation

class SDUINavigationDelegate: ObservableObject {
   
    var onNavigate: ((String) -> Void)?
    var onBack: (() -> Void)?
    var onReset: (() -> Void)?
    var onAlert: ((String) -> Void)?
        
    
    func navigate(to id: String) { onNavigate?(id) }
    func goBack() { onBack?() }
    func reset() { onReset?() }
    func showAlert(_ message: String) {
            onAlert?(message)
    }
}
