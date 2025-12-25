//
//  SDUIRenderer.swift
//  SDUI
//
//  Created by AbdelNasser Ramzy on 02/12/2025.
//

import SwiftUI

struct SDUIRenderer: View {
    let component: SDUIComponent
    @EnvironmentObject var router: SDUIRouterImp
    
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
        case .row:
            SDUIRowView(component: component)
        case .scrollView:
            SDUIScrollView(component: component)
        case .button:
            SDUIButtonView(component: component) { action in
                router.handle(action)
            }
        case .column:
            SDUIColumnView(component: component) { action in
                router.handle(action)
            }
        case .banner:
             SDUIBannerView(component: component) { action in
                router.handle(action)
            }
        case .bill:
            SDUIBillView(component: component) { action in
               router.handle(action)
           }
        }
    }
}
