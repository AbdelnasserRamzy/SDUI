//
//  SDUITextView.swift
//  SDUI
//
//  Created by AbdelNasser Ramzy on 07/12/2025.
//

import SwiftUI

struct SDUITextView: View {
    let component: SDUIComponent
    
    var body: some View {
        Text(component.text ?? "")
            .font(getFontStyle())
            .foregroundColor(getTextColor())
            .multilineTextAlignment(getTextAlignment())
    }
    
    // MARK: - Styling Helpers
    
    private func getFontStyle() -> Font {
        let size = component.fontSize ?? 16
        let weight = getFontWeight()
        return Font.system(size: size, weight: weight)
    }
    
    private func getFontWeight() -> Font.Weight {
        guard let weightString = component.fontWeight?.lowercased() else {
            return .regular
        }
        
        switch weightString {
        case "bold": return .bold
        case "semibold": return .semibold
        case "medium": return .medium
        case "light": return .light
        case "thin": return .thin
        case "black": return .black
        case "heavy": return .heavy
        default: return .regular
        }
    }
    
    private func getTextColor() -> Color {
        if let colorHex = component.textColor {
            return Color(hex: colorHex)
        }
        return .primary
    }
    
    private func getTextAlignment() -> TextAlignment {
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
