//
//  SDUIBannerView.swift
//  SDUI
//
//  Created by AbdelNasser Ramzy on 07/12/2025.
//

import SwiftUI

struct SDUIBannerView: View {
    let component: SDUIComponent
    let onAction: (SDUIAction?) -> Void
    
    private let handler: SDUIBannerHandler
    
    init(component: SDUIComponent, onAction: @escaping (SDUIAction?) -> Void) {
        self.component = component
        self.onAction = onAction
         self.handler = SDUIBannerHandler(key: component.templateId)
    }
    
    var body: some View {
        Group {
            switch handler.type {
            case .slider:
                HorizontalSlider(component: component, onAction: onAction)
            case .list:
                VerticalList(component: component, onAction: onAction)
            case .promo:
                PromoBanner(component: component, onAction: onAction)
            }
        }
    }
}

// MARK: - Sub-Views (Fixed Styles)

private struct HorizontalSlider: View {
    let component: SDUIComponent
    let onAction: (SDUIAction?) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(component.children ?? []) { item in
                    Button(action: { onAction(item.action) }) {
                        VStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(height: 100) // Fixed Height
                                .overlay(Image(systemName: "photo").foregroundColor(.gray))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.text ?? "")
                                    .font(.headline)
                                    .lineLimit(1)
                                    .foregroundColor(.primary)
                                
                                Text("Details")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(10)
                        }
                        .frame(width: 140) // Fixed Width
                        .background(Color.white) // Fixed Color
                        .cornerRadius(12)
                        .shadow(radius: 2)
                    }
                }
            }
            .padding()
        }
        .frame(height: 200) // Fixed Height
    }
}

private struct VerticalList: View {
    let component: SDUIComponent
    let onAction: (SDUIAction?) -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(component.children ?? []) { item in
                Button(action: { onAction(item.action) }) {
                    HStack(spacing: 12) {
                        Rectangle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 50, height: 50) // Fixed Size
                            .cornerRadius(8)
                            .overlay(Image(systemName: "star.fill").foregroundColor(.blue))
                        
                        Text(item.text ?? "")
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        Image(systemName: "chevron.right").foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white) // Fixed Color
                    .cornerRadius(10)
                    .shadow(radius: 1)
                }
            }
        }
        .padding()
    }
}

private struct PromoBanner: View {
    let component: SDUIComponent
    let onAction: (SDUIAction?) -> Void
    
    var body: some View {
        Button(action: { onAction(component.action) }) {
            ZStack {
                Color.blue // Fixed Color
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(component.text ?? "Banner")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("Tap to view")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    Spacer()
                    Image(systemName: "bell.fill")
                        .font(.largeTitle)
                        .foregroundColor(.yellow)
                }
                .padding(20)
            }
            .frame(height: 120) // Fixed Height
            .cornerRadius(16)
            .padding()
        }
    }
}
