//
//  TempleteModel.swift
//  SDUI
//
//  Created by Shrouk Yasser on 23/12/2025.
//

import Foundation

struct FlowConfigResponse: Codable {
    let templateType: String
    let views: [FlowViewMeta]
}

struct FlowViewMeta: Codable {
    let name: String
    let key: String 
    let version: Int
}


struct ScreenContentResponse: Codable {
    let components: [SDUIComponent]
}
