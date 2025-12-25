//
//  SDUITemplateLoader.swift
//  SDUI
//

import Foundation

struct SDUITemplateLoader {
    
    /// Load template data for a component based on its key
    static func loadTemplate(for key: String) -> SDUIComponent? {
        let templateName = matchKeyToTemplate(key)
        guard let templateName = templateName else {
            print("⚠️ No template match for key: \(key)")
            return nil
        }
        
        return loadTemplateFromFile(templateName)
    }
    
    // MARK: - Key Matching Logic
    
    /// Match component key to template file name
    private static func matchKeyToTemplate(_ key: String) -> String? {
        let k = key.uppercased()
        
        // Map keys to template files
        if k.contains("FREQUENTLY") || k.contains("BANNER") || k.contains("BILL_VIEW") {
            return "template1" // All three components are in template1.json
        }
        
        // Add more mappings as needed
        return nil
    }
    
    // MARK: - File Loading
    
    /// Load template JSON file from bundle
    private static func loadTemplateFromFile(_ templateName: String) -> SDUIComponent? {
        var url: URL?
        
        // Try multiple search strategies
        // 1. Try with Templates subdirectory
        url = Bundle.main.url(forResource: templateName, withExtension: "json", subdirectory: "Templates")
        
        // 2. Try without subdirectory
        if url == nil {
            url = Bundle.main.url(forResource: templateName, withExtension: "json")
        }
        
        // 3. Try with SDUI/Templates path
        if url == nil {
            url = Bundle.main.url(forResource: templateName, withExtension: "json", subdirectory: "SDUI/Templates")
        }
        
        // 4. Try searching all bundle resources
        if url == nil {
            if let allUrls = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: nil) {
                url = allUrls.first { $0.lastPathComponent == "\(templateName).json" }
            }
        }
        
        guard let fileUrl = url else {
            print("❌ Template file not found: \(templateName).json")
            print("   Searched in: Templates/, root, SDUI/Templates/, and all bundle resources")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileUrl)
            
            print("📄 Loaded Template: \(templateName).json from \(fileUrl.path)")
            
            let template = try JSONDecoder().decode(SDUITemplate.self, from: data)
            
            // template1.json has structure: { "components": [...] }
            // We'll need to handle this differently - return a container
            // Create a container with all template components
            let container = SDUIComponent(
                id: "template_\(templateName)",
                key: templateName,
                type: .column,
                children: template.components
            )
            
            return container
            
        } catch {
            print("❌ Failed to load template \(templateName): \(error)")
            return nil
        }
    }
    
    // MARK: - Component Enrichment
    
    /// Enrich a component with template data based on its key
    static func enrichComponent(_ component: SDUIComponent) -> SDUIComponent {
        // If component already has children, no need to enrich
        if let children = component.children, !children.isEmpty {
            return component
        }
        
        // Try to load template based on key
        guard let key = component.key else {
            print("⚠️ Component has no key, cannot enrich")
            return useMockDataFallback(for: component)
        }
        
        // Try template loading first
        if let templateContainer = loadTemplate(for: key),
           let templateComponents = templateContainer.children {
            let matchedComponent = findMatchingComponent(in: templateComponents, for: component)
            
            if let matched = matchedComponent {
                print("✅ Enriched component '\(key)' with template data")
                return matched
            }
        }
        
        // Fallback to MockData if template not found
        print("⚠️ Template not found for '\(key)', using MockData fallback")
        return useMockDataFallback(for: component)
    }
    
    // MARK: - MockData Fallback
    
    /// Use MockData as fallback when templates aren't available
    private static func useMockDataFallback(for component: SDUIComponent) -> SDUIComponent {
        guard let key = component.key else { return component }
        let k = key.uppercased()
        
        if k.contains("FREQUENTLY") {
            print("✅ Using MockData for Frequently Bills")
            return MockData.frequentlyBills
        }
        
        if k.contains("BANNER") {
            print("✅ Using MockData for Banner")
            return MockData.mainBanner
        }
        
        if k.contains("BILL_VIEW") {
            print("✅ Using MockData for Bill View")
            return MockData.billView
        }
        
        print("⚠️ No MockData available for key: \(key)")
        return component
    }
    
    /// Find a component in template that matches the API component's type/key
    private static func findMatchingComponent(in templateComponents: [SDUIComponent], for apiComponent: SDUIComponent) -> SDUIComponent? {
        let apiKey = apiComponent.key?.uppercased() ?? ""
        
        // For Banner - return first banner component from template
        if apiComponent.type == .banner {
            if let bannerComp = templateComponents.first(where: { $0.type == .banner }) {
                // Merge API metadata with template data
                return mergeBannerComponent(api: apiComponent, template: bannerComp)
            }
        }
        
        // For Bill components - match based on key patterns
        if apiComponent.type == .bill {
            // "Frequently" should map to horizontal scrollView
            if apiKey.contains("FREQUENTLY") {
                // Find horizontal scrollView in template (frequently bills)
                if let scrollComp = templateComponents.first(where: { 
                    $0.type == .scrollView && $0.scrollDirection == "horizontal"
                }) {
                    // Convert to bill component with scroll children
                    return convertScrollToBill(api: apiComponent, scrollTemplate: scrollComp, isHorizontal: true)
                }
            }
            
            // "BILL_VIEW" should be vertical list - for now use mock data
            if apiKey.contains("BILL_VIEW") {
                return createBillViewComponent(from: apiComponent)
            }
        }
        
        return nil
    }
    
    // MARK: - Component Merging
    
    /// Merge API banner metadata with template banner data
    private static func mergeBannerComponent(api: SDUIComponent, template: SDUIComponent) -> SDUIComponent {
        // Keep API metadata (id, key, order) but use template children and styling
        return SDUIComponent(
            id: api.id,
            key: api.key,
            order: api.order,
            type: .banner,
            children: template.children,
            height: template.height,
            spacing: template.spacing
        )
    }
    
    /// Convert scrollView template to bill component
    private static func convertScrollToBill(api: SDUIComponent, scrollTemplate: SDUIComponent, isHorizontal: Bool) -> SDUIComponent {
        // Extract items from scrollView children and convert to bill-friendly format
        let billChildren = scrollTemplate.children?.map { child -> SDUIComponent in
            // Extract text and image from nested children
            var text = "Bill Item"
            var imageUrl: String? = "doc.text.fill"
            
            if let childChildren = child.children {
                // Find text component
                if let textComp = childChildren.first(where: { $0.type == .text }) {
                    text = textComp.text ?? text
                }
                // Find image component
                if let imageComp = childChildren.first(where: { $0.type == .image }) {
                    imageUrl = imageComp.imageUrl
                }
            }
            
            return SDUIComponent(
                id: child.id,
                type: .text,
                text: text,
                imageUrl: imageUrl,
                action: child.action
            )
        }
        
        return SDUIComponent(
            id: api.id,
            key: api.key,
            order: api.order,
            type: .bill,
            children: billChildren
        )
    }
    
    /// Create a default BILL_VIEW component with sample data
    private static func createBillViewComponent(from api: SDUIComponent) -> SDUIComponent {
        let sampleBills = [
            SDUIComponent(id: UUID().uuidString, type: .text, text: "Electricity", imageUrl: "bolt.fill", action: SDUIAction(type: .alert, destination: "Electricity Bill")),
            SDUIComponent(id: UUID().uuidString, type: .text, text: "Water", imageUrl: "drop.fill", action: SDUIAction(type: .alert, destination: "Water Bill")),
            SDUIComponent(id: UUID().uuidString, type: .text, text: "Internet", imageUrl: "wifi", action: SDUIAction(type: .alert, destination: "Internet Bill")),
            SDUIComponent(id: UUID().uuidString, type: .text, text: "Phone", imageUrl: "phone.fill", action: SDUIAction(type: .alert, destination: "Phone Bill"))
        ]
        
        return SDUIComponent(
            id: api.id,
            key: api.key,
            order: api.order,
            type: .bill,
            children: sampleBills
        )
    }
}
