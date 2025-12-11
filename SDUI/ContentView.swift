//
//  ContentView.swift
//  SDUI
//
//  Created by AbdelNasser Ramzy on 02/12/2025.
//

import SwiftUI
import UIKit

// MARK: - Main Content Switcher
struct ContentView: View {
    // 1. Observe the Shared Client
    @ObservedObject var client = UIClient.shared
    
    var body: some View {
        Group {
            // 2. Dynamic check: Do we have the start screen yet?
            if let initialId = client.initialScreenId {
                // ✅ Data Loaded: Launch the UIKit Navigation Stack
                UIKitNavigationStack(initialScreenId: initialId)
                    .ignoresSafeArea() // Let UIKit handle the safe areas
            } else {
                // ⏳ Loading State
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5) // Alternative to controlSize for iOS 14
                    Text("Fetching Configuration...")
                        .foregroundColor(.secondary)
                }
                .onAppear {
                    // Trigger fetch immediately (iOS 14 compatible)
                    client.fetchUI()
                }
            }
        }
    }
}

// MARK: - UIKit Navigation Wrapper
struct UIKitNavigationStack: UIViewControllerRepresentable {
    let initialScreenId: String
    
    func makeUIViewController(context: Context) -> UINavigationController {
        // 1. Create the Root Screen using your Router Factory
        let rootVC = SDUIRouterImp.create(screenId: initialScreenId)
        
        // 2. Create the Navigation Controller
        let navigationController = UINavigationController(rootViewController: rootVC)
        
        // 3. Style
        navigationController.navigationBar.prefersLargeTitles = true
        
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // No updates needed
    }
}

// MARK: - Screen View (Renderer)
struct ScreenView: View {
    let screenId: String
    @EnvironmentObject var client: UIClient
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let screen = client.getScreen(id: screenId) {
                    SDUIRenderer(component: screen)
                } else if client.screens.isEmpty {
                    ProgressView("Loading UI...")
                        .padding()
                } else {
                    // ❌ Fixed for iOS 14: Replaced ContentUnavailableView with standard VStack
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.red)
                        
                        Text("Screen Not Found")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("ID: \(screenId)")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 60)
                }
            }
            .padding()
        }
        // UIKit reads this for the navigation bar title
        .navigationTitle(screenId.capitalized)
    }
}

#Preview {
    ContentView()
}
