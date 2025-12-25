//
//  UIClient.swift
//  SDUI
//
//  Created by AbdelNasser Ramzy on 02/12/2025.
//

import Foundation
import Combine

class UIClient: ObservableObject {
    static let shared = UIClient()
    
    @Published var screens: [String: SDUIComponent] = [:]
    @Published var flowSequence: [String] = []
    @Published var initialScreenId: String? = nil
    
    private let baseURL = "https://grey.paysky.io:7009/MockupUI/mockAPI/module/bills"
    
    private init() {}
    
    // MARK: - Main Entry Point
    func fetchUI() {
        Task { @MainActor in
            await fetchFlowConfig()
            
            if let firstKey = flowSequence.first {
                await fetchScreenContent(key: firstKey)
                self.initialScreenId = firstKey
            }
        }
    }
    
    // MARK: - Step 1: Fetch Flow
    @MainActor
    private func fetchFlowConfig() async {
        print("\n🌐 --- STEP 1: FETCHING FLOW CONFIG ---")
        
        if let url = URL(string: "https://grey.paysky.io:5012/mockAPI/module/bills") {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                // 🔍 DEBUG: Print Raw JSON
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📄 API RAW JSON (Config): \(jsonString)")
                }
                
                let response = try JSONDecoder().decode(FlowConfigResponse.self, from: data)
                
                self.flowSequence = response.views.map { $0.key }
                print("✅ API Flow Sequence: \(self.flowSequence)")
                print("✅ USING REAL API DATA (Config)")
                return
            } catch {
                print("❌ API Config Failed: \(error)")
                print("➡️ Switching to Mock Config...")
            }
        }
        
        // Fallback
        print("⚠️ USING MOCK DATA (Config)")
        self.flowSequence = ["Home_KEY", "Details_KEY", "CHECKOUT_KEY"]
    }
    
    // MARK: - Step 2: Fetch Content
    @MainActor
    func fetchScreenContent(key: String) async {
        if screens[key] != nil { return }
        
        print("\n📥 --- STEP 2: FETCHING CONTENT FOR: \(key) ---")
        
        let urlString = "\(baseURL)/views/\(key)/components"
        
        if let url = URL(string: urlString) {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                // 🔍 DEBUG: Print Raw JSON
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📄 API RAW JSON (Content for \(key)):")
                    print(jsonString)
                }
                
                let response = try JSONDecoder().decode(ScreenContentResponse.self, from: data)
                
                let screenContainer = SDUIComponent(
                    id: key,
                    key: key, type: .column,
                    children: response.components
                )
                
                self.screens[key] = screenContainer
                print("✅ API Content for '\(key)' Loaded")
                print("✅ USING REAL API DATA (Content)")
                return
                
            } catch {
                print("❌ API Content Failed for \(key): \(error)")
                print("➡️ Switching to Mock Content...")
            }
        }
        
        // ---------------------------------------------------------
        // 2. MOCK DATA (Fallback)
        // ---------------------------------------------------------
        print("⚠️ USING MOCK DATA (Content for \(key))")
        
        var children: [SDUIComponent] = []
        
        if key == "Home_KEY" {
            children = [
                SDUIComponent(id: UUID().uuidString, key: nil, type: .text, text: "Dashboard (Mock)", fontSize: 28, fontWeight: "bold", padding: Padding(bottom: 10, leading: 16)),
                MockData.frequentlyBills,
                SDUIComponent(id: UUID().uuidString, key: nil, type: .text, text: "Offers", fontSize: 20, fontWeight: "semibold", padding: Padding(top: 20, leading: 16)),
                MockData.mainBanner,
                MockData.billView
            ]
        } else {
            children = [
                SDUIComponent(id: UUID().uuidString, key: nil, type: .text, text: "Screen: \(key)", fontSize: 24, alignment: "center"),
                SDUIComponent(id: UUID().uuidString, key: nil, type: .button, text: "Next Step", action: SDUIAction(type: .navigate, destination: nil))
            ]
        }
        
        let screenContainer = SDUIComponent(
            id: key,
            key: key, type: .column,
            children: children
        )
        self.screens[key] = screenContainer
    }
    
    func getScreen(id: String) -> SDUIComponent? {
        if screens[id] == nil {
            Task { await fetchScreenContent(key: id) }
        }
        return screens[id]
    }
}
