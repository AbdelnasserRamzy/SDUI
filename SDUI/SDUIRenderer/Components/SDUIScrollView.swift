//
//  SDUIScrollView.swift
//  SDUI
//
//  Created by AbdelNasser Ramzy on 07/12/2025.
//

import SwiftUI

struct SDUIScrollView: View {
    let component: SDUIComponent
    
    var body: some View {
        let direction = component.scrollDirection?.lowercased() ?? "vertical"
        let showIndicators = component.showsIndicators ?? true
        let spacing = component.spacing ?? 10
        
        // Limit children if maxItemsToDisplay is set
        let limitedChildren: [SDUIComponent]? = {
            guard let children = component.children else { return nil }
            if let limit = component.maxItemsToDisplay, limit > 0 {
                return Array(children.prefix(min(limit, children.count)))
            }
            return children
        }()
        
        if direction == "horizontal" {
            ScrollView(.horizontal, showsIndicators: showIndicators) {
                HStack(spacing: spacing) {
                    if let children = limitedChildren {
                        ForEach(children) { child in
                            SDUIRenderer(component: child)
                                .frame(maxHeight: .infinity)
                        }
                    }
                }
            }
        } else {
            ScrollView(.vertical, showsIndicators: showIndicators) {
                VStack(spacing: spacing) {
                    if let children = limitedChildren {
                        ForEach(children) { child in
                            SDUIRenderer(component: child)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }
    }
}
