//
//  SDUIConfiguration.swift
//  SDUI
//
//  Created by Antigravity on 25/12/2025.
//

import Foundation

struct SDUIConfiguration {
    let flowConfigURL: String
    let contentBaseURL: String
    let templateDirectory: String
    
    static let production = SDUIConfiguration(
        flowConfigURL: "https://grey.paysky.io:5012/mockAPI/module/bills",
        contentBaseURL: "https://grey.paysky.io:7009/MockupUI/mockAPI/module/bills",
        templateDirectory: "Templates"
    )
    
    static let mock = SDUIConfiguration(
        flowConfigURL: "",
        contentBaseURL: "",
        templateDirectory: "Templates"
    )
}
