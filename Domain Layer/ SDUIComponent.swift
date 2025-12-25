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
        case openURL, navigate, goBack, reset, alert
    }
}

// MARK: - SDUI Component Type
enum SDUIComponentType: String, Codable {
    case text, image, button, row, column, scrollView, banner, bill
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawString = try container.decode(String.self)
        
        switch rawString.lowercased() {
        case "text": self = .text
        case "image": self = .image
        case "button": self = .button
        case "row": self = .row
        case "column": self = .column
        case "scrollview": self = .scrollView
        case "banner": self = .banner
        case "frequently", "bill", "bill_view": self = .bill
        default: self = .column
        }
    }
}

// MARK: - Padding
struct Padding: Codable, Hashable {
    let top, bottom, leading, trailing: Double?
    init(top: Double? = nil, bottom: Double? = nil, leading: Double? = nil, trailing: Double? = nil) {
        self.top = top; self.bottom = bottom; self.leading = leading; self.trailing = trailing
    }
}

struct SDUIResponse: Codable {
    let screens: [SDUIComponent]
}

// MARK: - SDUI Component
struct SDUIComponent: Codable, Identifiable {
    let id: String
    let key: String?
    let order: Int?
    let type: SDUIComponentType
    let text: String?
    let imageUrl: String?
    let imageType: String?
    let action: SDUIAction?
    let children: [SDUIComponent]?
    
    // Styling
    let fontSize: Double?
    let fontWeight: String?
    let textColor: String?
    let backgroundColor: String?
    let alignment: String?
    let height: CGFloat?
    let padding: Padding?
    
    // Frame
    let cornerRadius: Double?
    let width: CGFloat?
    let minWidth: CGFloat?
    let maxWidth: CGFloat?
    let minHeight: CGFloat?
    let maxHeight: CGFloat?
    
    // ScrollView
    let scrollDirection: String?
    let showsIndicators: Bool?
    let spacing: CGFloat?
    let maxItemsToDisplay: Int?
    
    // Banner
    let autoScrollInterval: Double?
    let isWrap: Bool?
    let sidesScaling: CGFloat?
    let headspace: CGFloat?
    
    // Template
    let templateId: String?
    
    // MARK: - Decoding Init
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = try container.decode(SDUIComponentType.self, forKey: .type)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        self.key = try container.decodeIfPresent(String.self, forKey: .key)
        self.order = try container.decodeIfPresent(Int.self, forKey: .order) // ✅ Fixed: Initialized
        
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        self.imageType = try container.decodeIfPresent(String.self, forKey: .imageType)
        self.action = try container.decodeIfPresent(SDUIAction.self, forKey: .action)
        self.children = try container.decodeIfPresent([SDUIComponent].self, forKey: .children)
        
        // Styles
        self.fontSize = try container.decodeIfPresent(Double.self, forKey: .fontSize)
        self.fontWeight = try container.decodeIfPresent(String.self, forKey: .fontWeight)
        self.textColor = try container.decodeIfPresent(String.self, forKey: .textColor)
        self.backgroundColor = try container.decodeIfPresent(String.self, forKey: .backgroundColor)
        self.alignment = try container.decodeIfPresent(String.self, forKey: .alignment)
        self.height = try container.decodeIfPresent(CGFloat.self, forKey: .height)
        self.padding = try container.decodeIfPresent(Padding.self, forKey: .padding)
        
        // Dimensions
        self.cornerRadius = try container.decodeIfPresent(Double.self, forKey: .cornerRadius)
        self.width = try container.decodeIfPresent(CGFloat.self, forKey: .width)
        self.minWidth = try container.decodeIfPresent(CGFloat.self, forKey: .minWidth)
        self.maxWidth = try container.decodeIfPresent(CGFloat.self, forKey: .maxWidth)
        self.minHeight = try container.decodeIfPresent(CGFloat.self, forKey: .minHeight)
        self.maxHeight = try container.decodeIfPresent(CGFloat.self, forKey: .maxHeight)
        
        // Props
        self.scrollDirection = try container.decodeIfPresent(String.self, forKey: .scrollDirection)
        self.showsIndicators = try container.decodeIfPresent(Bool.self, forKey: .showsIndicators)
        self.spacing = try container.decodeIfPresent(CGFloat.self, forKey: .spacing)
        self.maxItemsToDisplay = try container.decodeIfPresent(Int.self, forKey: .maxItemsToDisplay)
        
        self.autoScrollInterval = try container.decodeIfPresent(Double.self, forKey: .autoScrollInterval)
        self.isWrap = try container.decodeIfPresent(Bool.self, forKey: .isWrap)
        self.sidesScaling = try container.decodeIfPresent(CGFloat.self, forKey: .sidesScaling)
        self.headspace = try container.decodeIfPresent(CGFloat.self, forKey: .headspace)
        self.templateId = try container.decodeIfPresent(String.self, forKey: .templateId)
    }
    
    // MARK: - Manual Init
    init(id: String = UUID().uuidString,
         key: String? = nil,
         order: Int? = nil,
         type: SDUIComponentType,
         text: String? = nil,
         imageUrl: String? = nil,
         imageType: String? = nil,
         action: SDUIAction? = nil,
         children: [SDUIComponent]? = nil,
         fontSize: Double? = nil,
         fontWeight: String? = nil,
         textColor: String? = nil,
         backgroundColor: String? = nil,
         alignment: String? = nil,
         height: CGFloat? = nil,
         padding: Padding? = nil,
         cornerRadius: Double? = nil,
         width: CGFloat? = nil,
         minWidth: CGFloat? = nil,
         maxWidth: CGFloat? = nil,
         minHeight: CGFloat? = nil,
         maxHeight: CGFloat? = nil,
         scrollDirection: String? = nil,
         showsIndicators: Bool? = nil,
         spacing: CGFloat? = nil,
         maxItemsToDisplay: Int? = nil) {
        
        self.id = id
        self.key = key
        self.order = order
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
        case id, key, order, type, text, imageUrl, imageType, action, children
        case fontSize, fontWeight, textColor, backgroundColor, alignment, height, padding
        case cornerRadius, width, minWidth, maxWidth, minHeight, maxHeight
        case scrollDirection, showsIndicators, spacing
        case maxItemsToDisplay
        case autoScrollInterval, isWrap, sidesScaling, headspace
        case templateId
    }
}
