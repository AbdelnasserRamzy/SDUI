//
//  SDUIStyleModifiers.swift
//  SDUI
//
//  Created by AbdelNasser Ramzy on 07/12/2025.
//

import SwiftUI

// MARK: - View Extension for Common Styling
extension View {
    /// Applies all common styling to a view based on component properties
    @ViewBuilder
    func applyCommonStyling(component: SDUIComponent) -> some View {
        self
            .applyFrame(component: component)
            .applyPadding(component.padding)
            .applyBackground(component.backgroundColor)
            .applyCornerRadius(component.cornerRadius)
    }
    
    /// Applies padding based on Padding struct
    @ViewBuilder
    func applyPadding(_ padding: Padding?) -> some View {
        if let padding = padding {
            self.padding(EdgeInsets(
                top: padding.top ?? 0,
                leading: padding.leading ?? 0,
                bottom: padding.bottom ?? 0,
                trailing: padding.trailing ?? 0
            ))
        } else {
            self
        }
    }
    
    /// Applies frame constraints based on component properties
    @ViewBuilder
    func applyFrame(component: SDUIComponent) -> some View {
        let alignment = getFrameAlignment(from: component.alignment)
        
        if component.width != nil || component.height != nil {
            self.frame(
                width: component.width,
                height: component.height,
                alignment: alignment
            )
        } else {
            self.frame(
                minWidth: component.minWidth,
                maxWidth: component.maxWidth,
                minHeight: component.minHeight,
                maxHeight: component.maxHeight,
                alignment: alignment
            )
        }
    }
    
    /// Applies corner radius if specified
    @ViewBuilder
    func applyCornerRadius(_ radius: Double?) -> some View {
        if let radius = radius {
            self.cornerRadius(radius)
        } else {
            self
        }
    }
    
    /// Applies background color from hex string
    @ViewBuilder
    func applyBackground(_ backgroundColor: String?) -> some View {
        if let bgColor = backgroundColor {
            self.background(Color(hex: bgColor))
        } else {
            self
        }
    }
    
    /// Conditional view modifier
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    // MARK: - Helper Functions
    
    /// Converts alignment string to SwiftUI Alignment
    private func getFrameAlignment(from alignmentString: String?) -> Alignment {
        guard let alignment = alignmentString?.lowercased() else { return .center }
        
        switch alignment {
        case "leading": return .leading
        case "trailing": return .trailing
        case "top": return .top
        case "bottom": return .bottom
        case "topleading": return .topLeading
        case "toptrailing": return .topTrailing
        case "bottomleading": return .bottomLeading
        case "bottomtrailing": return .bottomTrailing
        case "center": return .center
        default: return .center
        }
    }
}
