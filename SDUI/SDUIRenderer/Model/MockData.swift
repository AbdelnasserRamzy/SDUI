//
//  MockData.swift
//  SDUI
//
//  Created by Shrouk Yasser on 18/12/2025.
//


import Foundation

struct MockData {
    
    // 1. Frequently Bills
    // Handler looks for "FREQUENTLY" -> Layout: Horizontal, Shape: Round
    static var frequentlyBills: SDUIComponent {
        SDUIComponent(
            id: "1",
            key: "Frequently_1", type: .bill,         
            children: [
                SDUIComponent(type: .button, text: "Electric", imageUrl: "bolt.fill"),
                SDUIComponent(type: .button, text: "Water", imageUrl: "drop.fill"),
                SDUIComponent(type: .button, text: "Internet", imageUrl: "wifi"),
                SDUIComponent(type: .button, text: "Phone", imageUrl: "iphone"),
                SDUIComponent(type: .button, text: "Gas", imageUrl: "flame.fill")
            ]
        )
    }
    
    // 2. Banner
    // Handler looks for "BANNER" -> Type: Slider
    static var mainBanner: SDUIComponent {
        SDUIComponent(
            id: "2",
            key: "Banner_1", type: .banner,
            children: [
                SDUIComponent(type: .image, text: "Summer Sale", imageUrl: "photo"),
                SDUIComponent(type: .image, text: "Winter Collection", imageUrl: "photo"),
                SDUIComponent(type: .image, text: "Flash Deals", imageUrl: "photo")
            ]
        )
    }
    
    // 3. Bill View
    static var billView: SDUIComponent {
        SDUIComponent(
            id: "3",
            key: "BILL_VIEW_1", type: .bill,
            children: [
                SDUIComponent(type: .button, text: "Rent - January", imageUrl: "house.fill"),
                SDUIComponent(type: .button, text: "Gym Membership", imageUrl: "figure.walk"),
                SDUIComponent(type: .button, text: "Netflix Subscription", imageUrl: "tv.fill")
            ]
        )
    }
}
