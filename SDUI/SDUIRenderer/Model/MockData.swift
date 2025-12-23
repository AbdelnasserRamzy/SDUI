//
//  MockData.swift
//  SDUI
//
//  Created by Shrouk Yasser on 18/12/2025.
//

import Foundation

struct MockData {
    
    // MARK: - Bills Mock
    static var horizontalBills: SDUIComponent {
        SDUIComponent(
            type: .bill, key: "BILL_HORIZ_ROUND",
            children: [
                SDUIComponent(type: .button, text: "Electric", imageUrl: "bolt.fill"),
                SDUIComponent(type: .button, text: "Water", imageUrl: "drop.fill"),
                SDUIComponent(type: .button, text: "Internet", imageUrl: "wifi"),
                SDUIComponent(type: .button, text: "Phone", imageUrl: "iphone"),
                SDUIComponent(type: .button, text: "Gas", imageUrl: "flame.fill")
            ]
        )
    }
    
    static var verticalBills: SDUIComponent {
        SDUIComponent(
            type: .bill, key: "BILL_VERT_SQUARE",
            children: [
                SDUIComponent(type: .button, text: "Rent - January", imageUrl: "house.fill"),
                SDUIComponent(type: .button, text: "Gym Membership", imageUrl: "figure.walk"),
                SDUIComponent(type: .button, text: "Netflix Subscription", imageUrl: "tv.fill")
            ]
        )
    }
    
    // MARK: - Banners Mock
    static var sliderBanner: SDUIComponent {
        SDUIComponent(
            type: .banner, key: "SLIDER",
            children: [
                SDUIComponent(type: .image, text: "Summer Sale", imageUrl: "photo"),
                SDUIComponent(type: .image, text: "Winter Collection", imageUrl: "photo"),
                SDUIComponent(type: .image, text: "Flash Deals", imageUrl: "photo")
            ]
        )
    }
    
    static var promoBanner: SDUIComponent {
        SDUIComponent(
            type: .banner, text: "Get 50% Cashback Now!", key: "PROMO"
        )
    }
}
