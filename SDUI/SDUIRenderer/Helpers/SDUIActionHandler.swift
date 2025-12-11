//
//  SDUIActionHandler.swift
//  SDUI
//
//  Created by AbdelNasser Ramzy on 07/12/2025.
//

import SwiftUI

// MARK: - Action Handler
class SDUIActionHandler: ObservableObject {
    @Published var showAlert = false
    @Published var alertMessage = ""
    
   private weak var delegate: SDUINavigationDelegate?
   
    init(delegate: SDUINavigationDelegate?) {
        self.delegate = delegate
    }
    
    /// Handle SDUI actions
    func handleAction(_ action: SDUIAction?) {
        guard let action = action else { return }
        print("Action triggered: \(action.type.rawValue) -> \(action.destination ?? "nil")")
        
        switch action.type {
        case .openURL:
            if let urlString = action.destination, let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        case .navigate:
            if let destination = action.destination {
                // FIX 3: Use delegate method
                delegate?.navigate(to: destination)
            }
        case .goBack:
            // FIX 4: Use delegate method
            delegate?.goBack()
        case .reset:
            // FIX 5: Use delegate method
            delegate?.reset()
        case .alert:
            if let message = action.destination {
                alertMessage = message
                showAlert = true
            }
        }
    }
}
