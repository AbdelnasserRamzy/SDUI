//
//  UIClient.swift
//  SDUI
//
//  Created by AbdelNasser Ramzy on 02/12/2025.
//

import Foundation
import Combine

class UIClient: ObservableObject {
    // 1. Shared Instance for Router access
    static let shared = UIClient()
    
    @Published var screens: [String: SDUIComponent] = [:]
    @Published var initialScreenId: String? = nil
    
    // API endpoint URL
    private let apiEndpoint = "https://mock.apidog.com/m1/1108865-1099361-default/screen?name=ramzy123123"
    
    // MARK: - Initialization
    private init() {} // Private init to enforce singleton usage if desired
    
    // MARK: - Fetch Logic
    func fetchUI() {
        Task { @MainActor in
            await loadFromAPI()
            
            // Fallback logic: If API failed (screens is empty), try local mock
            if screens.isEmpty {
                print("⚠️ API failed or returned empty. Attempting local mock...")
                loadMockData()
            }
        }
    }
    
    // MARK: - Load from API
    @MainActor
    private func loadFromAPI() async {
        guard let url = URL(string: apiEndpoint) else {
            print("Error: Invalid API URL")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error: Invalid HTTP response")
                return
            }
            
            let sduiResponse = try JSONDecoder().decode(SDUIResponse.self, from: data)
            
            // Update state
            self.screens = Dictionary(uniqueKeysWithValues: sduiResponse.screens.map { ($0.id, $0) })
            self.initialScreenId = sduiResponse.screens.first?.id
            
            // Apply templates
            applyTemplates()
            
            print("✅ Successfully loaded \(self.screens.count) screens from API")
        } catch {
            print("❌ Error loading from API: \(error.localizedDescription)")
            // We do not call loadMockData here anymore to keep logic clean.
            // The fetchUI() Task handles the fallback check.
        }
    }
    
    // MARK: - Load from Local Mock
    @MainActor
    func loadMockData() {
        guard let url = Bundle.main.url(forResource: "mock", withExtension: "json") else {
            print("Error: mock.json not found in bundle")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let response = try JSONDecoder().decode(SDUIResponse.self, from: data)
            
            // Update state
            self.screens = Dictionary(uniqueKeysWithValues: response.screens.map { ($0.id, $0) })
            self.initialScreenId = response.screens.first?.id
            
            // Apply templates
            applyTemplates()
            
            print("✅ Successfully loaded \(self.screens.count) screens from mock.json")
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    // MARK: - Template Loading
    // This doesn't need @MainActor as it returns data and doesn't modify state directly
    private func loadTemplate(templateId: String) -> [SDUIComponent]? {
        guard let url = Bundle.main.url(forResource: templateId, withExtension: "json") else {
            print("⚠️ Template file '\(templateId).json' not found in bundle")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let template = try JSONDecoder().decode(SDUITemplate.self, from: data)
            return template.components
        } catch {
            print("❌ Error decoding template '\(templateId)': \(error)")
            return nil
        }
    }
    
    // MARK: - Apply Templates
    @MainActor
    private func applyTemplates() {
        var updatedScreens: [String: SDUIComponent] = [:]
        
        for (screenId, screen) in screens {
            if let templateId = screen.templateId {
                if let templateComponents = loadTemplate(templateId: templateId) {
                    
                    // Create new component with template children
                    let updatedScreen = SDUIComponent(
                        id: screen.id,
                        type: screen.type,
                        text: screen.text,
                        imageUrl: screen.imageUrl,
                        imageType: screen.imageType,
                        action: screen.action,
                        children: templateComponents, // <--- Template injected here
                        fontSize: screen.fontSize,
                        fontWeight: screen.fontWeight,
                        textColor: screen.textColor,
                        backgroundColor: screen.backgroundColor,
                        alignment: screen.alignment,
                        height: screen.height,
                        padding: screen.padding,
                        cornerRadius: screen.cornerRadius,
                        width: screen.width,
                        minWidth: screen.minWidth,
                        maxWidth: screen.maxWidth,
                        minHeight: screen.minHeight,
                        maxHeight: screen.maxHeight,
                        scrollDirection: screen.scrollDirection,
                        showsIndicators: screen.showsIndicators,
                        spacing: screen.spacing,
                        maxItemsToDisplay: screen.maxItemsToDisplay
                    )
                    
                    updatedScreens[screenId] = updatedScreen
                } else {
                    updatedScreens[screenId] = screen
                }
            } else {
                updatedScreens[screenId] = screen
            }
        }
        
        // Final State Update on Main Thread
        self.screens = updatedScreens
        print("✅ Templates applied. Final screen count: \(self.screens.count)")
    }
    
    // MARK: - Helper
    func getScreen(id: String) -> SDUIComponent? {
        return screens[id]
    }
}
