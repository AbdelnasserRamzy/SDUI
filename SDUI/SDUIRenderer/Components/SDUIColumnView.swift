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
        
        let limitedChildren: [SDUIComponent]? = {
            guard let children = component.children else { return nil }
            
           
            let sortedChildren = children.sorted {
                ($0.order ?? 999) < ($1.order ?? 999)
            }
            
            if let limit = component.maxItemsToDisplay, limit > 0 {
                return Array(sortedChildren.prefix(min(limit, sortedChildren.count)))
            }
            return sortedChildren
        }()
        
        VStack(alignment: getVStackAlignment(), spacing: spacing) {
            if let children = limitedChildren {
                ForEach(children) { child in
                    SDUIRenderer(component: child)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: getFrameAlignment())
        .onTapGesture {
            if let action = component.action {
                handleAction(action)
            }
        }
    }
    
    private func getVStackAlignment() -> HorizontalAlignment {
        let align = component.alignment?.lowercased()
        if align == "center" { return .center }
        if align == "trailing" { return .trailing }
        return .leading
    }
    
    private func getFrameAlignment() -> Alignment {
        let align = component.alignment?.lowercased()
        if align == "center" { return .center }
        if align == "trailing" { return .trailing }
        return .leading
    }
}
