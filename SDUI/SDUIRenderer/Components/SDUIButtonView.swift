//
//  SDUIButtonView.swift
//  SDUI
//
//  Created by AbdelNasser Ramzy on 07/12/2025.
//

import SwiftUI

struct SDUIButtonView: View {
    let component: SDUIComponent
    let handleAction: (SDUIAction?) -> Void
    
    var body: some View {
        Button(action: {
            handleAction(component.action)
        }) {
            Text(component.text ?? "Button")
                .font(getFontStyle())
                .foregroundColor(getTextColor())
                .frame(maxWidth: .infinity)
                .padding()
                .background(component.backgroundColor != nil ? Color(hex: component.backgroundColor!) : Color.blue)
                .cornerRadius(10)
        }
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
        return .white
    }
}
