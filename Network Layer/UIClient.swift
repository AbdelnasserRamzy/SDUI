//
//  UIClient.swift
//  SDUI
//

import Foundation
import Combine

class UIClient: ObservableObject {
    static let shared = UIClient()
    
    @Published var screens: [String: SDUIComponent] = [:]
    @Published var flowSequence: [String] = []
    @Published var initialScreenId: String? = nil
    @Published var viewMetadata: [String: FlowViewMeta] = [:]
    
    private let config: SDUIConfiguration
    private let registry: SDUIComponentRegistry
    
    init(configuration: SDUIConfiguration = .production, 
         registry: SDUIComponentRegistry = .shared) {
        self.config = configuration
        self.registry = registry
    }
    
    func fetchUI() {
        Task { @MainActor in
            await fetchFlowConfig()
            
            if let firstKey = flowSequence.first {
                await fetchScreenContent(key: firstKey)
                self.initialScreenId = firstKey
            }
        }
    }
    
    @MainActor
    private func fetchFlowConfig() async {
        print("\n🌐 --- FETCHING FLOW CONFIG ---")
        
        guard let url = URL(string: config.flowConfigURL) else {
            useMockFlowConfig()
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 API Response: \(jsonString)")
            }
            
            let response = try JSONDecoder().decode(FlowConfigResponse.self, from: data)
            
            self.flowSequence = response.views.map { $0.key }
            for view in response.views {
                self.viewMetadata[view.key] = view
            }
            
            print("✅ Flow Sequence: \(self.flowSequence)")
            print("✅ View Metadata: \(response.views.map { "\($0.name) (\($0.key))" })")
            
        } catch {
            print("❌ API Failed: \(error)")
            useMockFlowConfig()
        }
    }
    
    @MainActor
    func fetchScreenContent(key: String) async {
        if screens[key] != nil { return }
        
        print("\n📥 --- FETCHING CONTENT FOR: \(key) ---")
        
        let urlString = "\(config.contentBaseURL)/views/\(key)/components"
        
        guard let url = URL(string: urlString) else {
            useMockScreenContent(key: key)
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 API Response: \(jsonString)")
            }
            
            let response = try JSONDecoder().decode(ScreenContentResponse.self, from: data)
            
            let enrichedComponents = response.components.map { component in
                registry.handle(component)
            }
            
            let screenContainer = SDUIComponent(
                id: key,
                key: key,
                type: .column,
                children: enrichedComponents
            )
            
            self.screens[key] = screenContainer
            print("✅ Content Loaded: \(enrichedComponents.count) components")
            
        } catch {
            print("❌ API Failed: \(error)")
            useMockScreenContent(key: key)
        }
    }
    
    @MainActor
    private func useMockFlowConfig() {
        print("⚠️ Using Mock Flow Config")
        self.flowSequence = ["Home_KEY", "Details_KEY", "CHECKOUT_KEY"]
    }
    
    @MainActor
    private func useMockScreenContent(key: String) {
        print("⚠️ Using Mock Screen Content")
        
        let children: [SDUIComponent] = if key == "Home_KEY" {
            [
                SDUIComponent(id: UUID().uuidString, type: .text, text: "Dashboard", fontSize: 28, fontWeight: "bold"),
                MockData.frequentlyBills,
                MockData.mainBanner,
                MockData.billView
            ]
        } else {
            [
                SDUIComponent(id: UUID().uuidString, type: .text, text: "Screen: \(key)", fontSize: 24)
            ]
        }
        
        let screenContainer = SDUIComponent(
            id: key,
            key: key,
            type: .column,
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
    
    func getViewName(forKey key: String) -> String {
        return viewMetadata[key]?.name ?? key.capitalized
    }
}
