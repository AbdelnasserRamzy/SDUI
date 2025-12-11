//
//  SDUIRowView.swift
//  SDUI
//
//  Created by AbdelNasser Ramzy on 07/12/2025.
//

import SwiftUI

struct SDUIRowView: View {
    let component: SDUIComponent
    
    var body: some View {
        HStack(spacing: component.spacing ?? 10) {
            if let children = component.children {
                ForEach(children) { child in
                    SDUIRenderer(component: child)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: getHStackAlignment())
    }
    
    // MARK: - Alignment Helper
    
    private func getHStackAlignment() -> Alignment {
        guard let alignment = component.alignment?.lowercased() else {
            return .center
        }
        
        switch alignment {
        case "leading": return .leading
        case "trailing": return .trailing
        default: return .center
        }
    }
}
