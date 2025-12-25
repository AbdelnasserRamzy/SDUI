//
//  SDUICacheManager.swift
//  SDUI
//
//  Created by Shrouk Yasser on 23/12/2025.
//

import Foundation

class SDUICacheManager {
    static let shared = SDUICacheManager()
    
    private let fileManager = FileManager.default
   private let ioQueue = DispatchQueue(label: "com.sdui.disk.io", qos: .background)
    
    private init() {}
    
    // MARK: - 1. Directory Logic
    private func getFolder(templateID: String) -> URL? {
        guard let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        let folderURL = cacheDir
            .appendingPathComponent("SDUI_Cache")
            .appendingPathComponent("Template_\(templateID)")
        
        if !fileManager.fileExists(atPath: folderURL.path) {
            try? fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
        }
        
        return folderURL
    }
    
    // MARK: - 2. The "Update" Logic
   func handleNewConfig(newTemplateID: String) {
        let currentIDKey = "SDUI_CURRENT_TEMPLATE_ID"
        let oldID = UserDefaults.standard.string(forKey: currentIDKey)
        
        if oldID != newTemplateID {
            print("♻️ Major Update: Template changed from \(oldID ?? "nil") to \(newTemplateID)")
            clearOldCache()
            UserDefaults.standard.set(newTemplateID, forKey: currentIDKey)
        }
    }
    
    // MARK: - 3. Save (Disk)
    func save(component: SDUIComponent, key: String, version: Int, templateID: String) {
        ioQueue.async { [weak self] in
            guard let self = self, let folder = self.getFolder(templateID: templateID) else { return }
            
            let fileURL = folder.appendingPathComponent("\(key)_v\(version).json")
            if self.fileManager.fileExists(atPath: fileURL.path) { return }
            
            self.removeOldVersions(of: key, in: folder)
            
            do {
                let data = try JSONEncoder().encode(component)
                try data.write(to: fileURL)
                print("💾 Saved to Disk: \(key) (v\(version))")
            } catch {
                print("❌ Cache Write Error: \(error)")
            }
        }
    }
    
    // MARK: - 4. Load (Disk)
    func load(key: String, version: Int, templateID: String) -> SDUIComponent? {
        guard let folder = getFolder(templateID: templateID) else { return nil }
        let fileURL = folder.appendingPathComponent("\(key)_v\(version).json")
        guard fileManager.fileExists(atPath: fileURL.path),
              let data = try? Data(contentsOf: fileURL),
              let component = try? JSONDecoder().decode(SDUIComponent.self, from: data) else {
            return nil
        }
        
        print("⚡️ Loaded from Disk: \(key) (v\(version))")
        return component
    }
    
    // MARK: - Helpers
    private func clearOldCache() {
        guard let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?
            .appendingPathComponent("SDUI_Cache") else { return }
        try? fileManager.removeItem(at: cacheDir)
    }
    
    private func removeOldVersions(of key: String, in folder: URL) {
       try? fileManager.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil)
            .filter { $0.lastPathComponent.starts(with: "\(key)_v") }
            .forEach { try? fileManager.removeItem(at: $0) }
    }
}
