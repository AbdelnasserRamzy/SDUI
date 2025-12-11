//
//  SDUIColumnView.swift
//  SDUI
//
//  Created by AbdelNasser Ramzy on 07/12/2025.
//

import SwiftUI

struct SDUIColumnView: View {
    let component: SDUIComponent
    let handleAction: (SDUIAction?) -> Void
    
    var body: some View {
        let spacing = component.spacing ?? 10
        
        // Limit children if maxItemsToDisplay is set
        let limitedChildren: [SDUIComponent]? = {
            guard let children = component.children else { return nil }
            if let limit = component.maxItemsToDisplay, limit > 0 {
                return Array(children.prefix(min(limit, children.count)))
            }
            return children
        }()
        
        VStack(alignment: getVStackAlignment(), spacing: spacing) {
            if let children = limitedChildren {
                ForEach(children) { child in
                    SDUIRenderer(component: child)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: getFrameAlignment())
        .if(component.action != nil) { view in
            view.onTapGesture {
                handleAction(component.action)
            }
        }
    }
    
    // MARK: - Alignment Helpers
    
    private func getVStackAlignment() -> HorizontalAlignment {
        guard let alignment = component.alignment?.lowercased() else {
            return .leading
        }
        
        switch alignment {
        case "center": return .center
        case "trailing": return .trailing
        default: return .leading
        }
    }
    
    private func getFrameAlignment() -> Alignment {
        guard let alignment = component.alignment?.lowercased() else {
            return .leading
        }
        
        switch alignment {
        case "center": return .center
        case "trailing": return .trailing
        default: return .leading
        }
    }
}
