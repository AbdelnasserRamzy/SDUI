//
//   SDUIComponent.swift
//  SDUI
//
//  Created by AbdelNasser Ramzy on 02/12/2025.
//

import Foundation

// MARK: - SDUI Action
struct SDUIAction: Codable, Hashable {
    let type: ActionType
    let destination: String?
    
    enum ActionType: String, Codable {
        case openURL
        case navigate
        case goBack
        case reset
        case alert
    }
}

// MARK: - SDUI Component Type
enum SDUIComponentType: String, Codable {
    case text
    case image
    case button
    case row
    case column
    case scrollView
    case banner
}

// MARK: - Padding
struct Padding: Codable, Hashable {
    let top: Double?
    let bottom: Double?
    let leading: Double?
    let trailing: Double?
    
    init(top: Double? = nil, bottom: Double? = nil, leading: Double? = nil, trailing: Double? = nil) {
        self.top = top
        self.bottom = bottom
        self.leading = leading
        self.trailing = trailing
    }
}

struct SDUIResponse: Codable {
    let screens: [SDUIComponent]
}

// MARK: - SDUI Component
struct SDUIComponent: Codable, Identifiable {
    let id: String
    let key: String?
    let type: SDUIComponentType
    let text: String?
    let imageUrl: String?
    let imageType: String?
    let action: SDUIAction?
    let children: [SDUIComponent]?
    
    // Styling properties
    let fontSize: Double?
    let fontWeight: String?
    let textColor: String?
    let backgroundColor: String?
    let alignment: String?
    let height: CGFloat?
    let padding: Padding?
    
    // Frame and corner properties
    let cornerRadius: Double?
    let width: CGFloat?
    let minWidth: CGFloat?
    let maxWidth: CGFloat?
    let minHeight: CGFloat?
    let maxHeight: CGFloat?
    
    // ScrollView properties
    let scrollDirection: String?
    let showsIndicators: Bool?
    let spacing: CGFloat?
    let maxItemsToDisplay: Int?
    
    // Banner Properties
    let autoScrollInterval: Double?
    let isWrap: Bool?
    let sidesScaling: CGFloat?
    let headspace: CGFloat?
    
    // Template support
    let templateId: String?
    
    // Custom decoding to handle missing ID if needed, or generate one
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(SDUIComponentType.self, forKey: .type)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        self.imageType = try container.decodeIfPresent(String.self, forKey: .imageType)
        self.action = try container.decodeIfPresent(SDUIAction.self, forKey: .action)
        self.children = try container.decodeIfPresent([SDUIComponent].self, forKey: .children)
        
        // Styling properties
        self.fontSize = try container.decodeIfPresent(Double.self, forKey: .fontSize)
        self.fontWeight = try container.decodeIfPresent(String.self, forKey: .fontWeight)
        self.textColor = try container.decodeIfPresent(String.self, forKey: .textColor)
        self.backgroundColor = try container.decodeIfPresent(String.self, forKey: .backgroundColor)
        self.alignment = try container.decodeIfPresent(String.self, forKey: .alignment)
        self.height = try container.decodeIfPresent(CGFloat.self, forKey: .height)
        self.padding = try container.decodeIfPresent(Padding.self, forKey: .padding)
        
        // Frame and corner properties
        self.cornerRadius = try container.decodeIfPresent(Double.self, forKey: .cornerRadius)
        self.width = try container.decodeIfPresent(CGFloat.self, forKey: .width)
        self.minWidth = try container.decodeIfPresent(CGFloat.self, forKey: .minWidth)
        self.maxWidth = try container.decodeIfPresent(CGFloat.self, forKey: .maxWidth)
        self.minHeight = try container.decodeIfPresent(CGFloat.self, forKey: .minHeight)
        self.maxHeight = try container.decodeIfPresent(CGFloat.self, forKey: .maxHeight)
        
        // ScrollView properties
        self.scrollDirection = try container.decodeIfPresent(String.self, forKey: .scrollDirection)
        self.showsIndicators = try container.decodeIfPresent(Bool.self, forKey: .showsIndicators)
        self.spacing = try container.decodeIfPresent(CGFloat.self, forKey: .spacing)
        self.maxItemsToDisplay = try container.decodeIfPresent(Int.self, forKey: .maxItemsToDisplay)
        
        self.autoScrollInterval = try container.decodeIfPresent(Double.self, forKey: .autoScrollInterval)
        self.isWrap = try container.decodeIfPresent(Bool.self, forKey: .isWrap)
        self.sidesScaling = try container.decodeIfPresent(CGFloat.self, forKey: .sidesScaling)
        self.headspace = try container.decodeIfPresent(CGFloat.self, forKey: .headspace)
        
        // Template support
        self.templateId = try container.decodeIfPresent(String.self, forKey: .templateId)
        
        // If ID is present use it, otherwise generate unique string
        if let idString = try container.decodeIfPresent(String.self, forKey: .id) {
            self.id = idString
        } else {
            self.id = UUID().uuidString
        }
    }
    
    // Default init for manual creation
    init(id: String = UUID().uuidString, type: SDUIComponentType, text: String? = nil, imageUrl: String? = nil, imageType: String? = nil, action: SDUIAction? = nil, children: [SDUIComponent]? = nil, fontSize: Double? = nil, fontWeight: String? = nil, textColor: String? = nil, backgroundColor: String? = nil, alignment: String? = nil, height: CGFloat? = nil, padding: Padding? = nil, cornerRadius: Double? = nil, width: CGFloat? = nil, minWidth: CGFloat? = nil, maxWidth: CGFloat? = nil, minHeight: CGFloat? = nil, maxHeight: CGFloat? = nil, scrollDirection: String? = nil, showsIndicators: Bool? = nil, spacing: CGFloat? = nil, maxItemsToDisplay: Int? = nil) {
        self.id = id
        self.type = type
        self.text = text
        self.imageUrl = imageUrl
        self.imageType = imageType
        self.action = action
        self.children = children
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.alignment = alignment
        self.height = height
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.width = width
        self.minWidth = minWidth
        self.maxWidth = maxWidth
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.scrollDirection = scrollDirection
        self.showsIndicators = showsIndicators
        self.spacing = spacing
        self.maxItemsToDisplay = maxItemsToDisplay
        self.autoScrollInterval = nil
        self.isWrap = nil
        self.sidesScaling = nil
        self.headspace = nil
        self.templateId = nil
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, type, text, imageUrl, imageType, action, children
        case fontSize, fontWeight, textColor, backgroundColor, alignment, height, padding
        case cornerRadius, width, minWidth, maxWidth, minHeight, maxHeight
        case scrollDirection, showsIndicators, spacing
        case maxItemsToDisplay
        case autoScrollInterval, isWrap, sidesScaling, headspace
        case templateId
    }
}
