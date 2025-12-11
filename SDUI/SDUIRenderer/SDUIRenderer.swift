//
//  SDUIRenderer.swift
//  SDUI
//
//  Created by AbdelNasser Ramzy on 02/12/2025.
//

import SwiftUI

struct SDUIRenderer: View {
    let component: SDUIComponent
    @EnvironmentObject var navDelegate: SDUINavigationDelegate
    
    var body: some View {
        renderComponent()
            .applyCommonStyling(component: component)

    }
    
    @ViewBuilder
    private func renderComponent() -> some View {
        switch component.type {
        case .text:
            SDUITextView(component: component)
        case .image:
            SDUIImageView(component: component)
        case .button:
            SDUIButtonView(component: component, handleAction: handleAction)
        case .row:
            SDUIRowView(component: component)
        case .column:
            SDUIColumnView(component: component, handleAction: handleAction)
        case .scrollView:
            SDUIScrollView(component: component)
        case .banner:
            SDUIBannerView(component: component, handleAction: handleAction)
        }
    }
    
    // MARK: - Actions
    func handleAction(_ action: SDUIAction?) {
        guard let action = action else { return }
        print("⚡️ Action: \(action.type)")
        
        switch action.type {
        case .openURL:
            if let urlString = action.destination, let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        case .navigate:
            if let destination = action.destination {
                navDelegate.navigate(to: destination)
            }
        case .goBack:
            navDelegate.goBack()
        case .reset:
            navDelegate.reset()
        case .alert:
            if let message = action.destination {
                // MARK: - FIX: Call Delegate
                print("⚠️ Requesting Alert: \(message)")
                navDelegate.showAlert(message)
            }
        }
    }
}
