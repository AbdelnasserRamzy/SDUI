//
//  SDUIBannerView.swift
//  SDUI
//
//  Created by AbdelNasser Ramzy on 07/12/2025.
//

import SwiftUI

struct SDUIBannerView: View {
    let component: SDUIComponent
    let handleAction: (SDUIAction?) -> Void
    
    @State private var currentIndex: Int = 0
    
    var body: some View {
        VStack(spacing: 8) {
            // Slideshow
            if let children = component.children, !children.isEmpty {
                let autoScroll: SlideshowAutoScroll = {
                    if let interval = component.autoScrollInterval, interval > 0 {
                        return .active(TimeInterval(interval))
                    }
                    return .inactive
                }()
                
                Slideshow(
                    children,
                    index: $currentIndex,
                    spacing: component.spacing ?? 10,
                    headspace: component.headspace ?? 10,
                    isWrap: component.isWrap ?? true,
                    sidesScaling: component.sidesScaling ?? 0.8,
                    autoScroll: autoScroll
                ) { child in
                    SDUIRenderer(component: child)
                        .onTapGesture {
                            handleAction(child.action)
                        }
                }
                
                // Pagination Dots
                HStack(spacing: 6) {
                    ForEach(0..<children.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex ? Color.blue : Color.gray.opacity(0.4))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 4)
            }
        }
    }
}
