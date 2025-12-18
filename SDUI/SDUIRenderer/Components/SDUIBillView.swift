//
//  SDUIBillView.swift
//  SDUI
//
//  Created by Shrouk Yasser on 18/12/2025.
//

import SwiftUI

struct SDUIBillView: View {
    private let items: [BillItem]
    private let onAction: (SDUIAction?) -> Void
    private let handler: SDUIBillHandler
    
    init(component: SDUIComponent, onAction: @escaping (SDUIAction?) -> Void) {
        self.items = (component.children ?? []).map {
            BillItem(
                id: $0.id,
                title: $0.text ?? "",
                imageUrl: $0.imageUrl,
                action: $0.action
            )
        }
        self.onAction = onAction
        self.handler = SDUIBillHandler(key: component.key ?? component.templateId)
    }
    
    var body: some View {
        switch handler.layout {
        case .horizontal:
            HorizontalLayout(items: items, shape: handler.shape, onAction: onAction)
        case .vertical:
            VerticalLayout(items: items, shape: handler.shape, onAction: onAction)
        }
    }
}

// MARK: - 1. Horizontal Layout (Cards)
private struct HorizontalLayout: View {
    let items: [BillItem]
    let shape: SDUIBillHandler.Shape
    let onAction: (SDUIAction?) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(items) { item in
                    Button(action: { onAction(item.action) }) {
                       BillCard(item: item, shape: shape)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}

// MARK: Vertical Layout
private struct VerticalLayout: View {
    let items: [BillItem]
    let shape: SDUIBillHandler.Shape
    let onAction: (SDUIAction?) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(items) { item in
                Button(action: { onAction(item.action) }) {
                    BillRow(item: item, shape: shape)
                }
                if item.id != items.last?.id {
                    Divider().padding(.leading, 82)
                }
            }
        }
    }
}

// MARK: - 3. Item Designs (Fixed Content: Image + Title)

//  vertical item
private struct BillCard: View {
    let item: BillItem
    let shape: SDUIBillHandler.Shape
    
    var body: some View {
        VStack(spacing: 8) {
            BillIcon(url: item.imageUrl, shape: shape, size: 60)
            
            Text(item.title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .lineLimit(1)
                .frame(width: 70)
        }
    }
}

// A horizontal item
private struct BillRow: View {
    let item: BillItem
    let shape: SDUIBillHandler.Shape
    
    var body: some View {
        HStack(spacing: 16) {
            BillIcon(url: item.imageUrl, shape: shape, size: 50)
            
            Text(item.title)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(16)
        .background(Color(.systemBackground))
    }
}

// MARK: Core Icon Component
private struct BillIcon: View {
    let url: String?
    let shape: SDUIBillHandler.Shape
    let size: CGFloat
    
    var body: some View {
       imageView
            .frame(width: size, height: size)
            .padding(12)
            .background(Color.blue.opacity(0.1))
            .applyShape(shape)
    }
    
    @ViewBuilder
    private var imageView: some View {
        if let str = url {
            if let _ = URL(string: str), str.contains("http") {
                RemoteImage(url: str)
            } else {
                Image(systemName: str)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.blue)
            }
        } else {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .foregroundColor(.gray)
        }
    }
}

// MARK: Extensions
private extension View {
    @ViewBuilder
    func applyShape(_ shape: SDUIBillHandler.Shape) -> some View {
        if shape == .rounded {
            self.clipShape(Circle())
        } else {
            self.clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
