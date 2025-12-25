//
//  ContentView.swift
//  SDUI
//
//  Created by AbdelNasser Ramzy on 02/12/2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var client = UIClient.shared
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView().scaleEffect(1.5)
            Text("Loading ...").foregroundColor(.gray)
        }
        .onAppear { client.fetchUI() }
        .onChange(of: client.initialScreenId) { newId in
            if let id = newId {
               SDUIRouterImp.startApp(initialId: id)
            }
        }
    }
}

struct ScreenView: View {
    let screenId: String
    @EnvironmentObject var client: UIClient
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if let screen = client.getScreen(id: screenId) {
                    SDUIRenderer(component: screen)
                } else if client.screens.isEmpty {
                    ProgressView("Loading UI...")
                        .padding(.top, 50)
                } else {
                    Text("Screen '\(screenId)' not found")
                        .foregroundColor(.red)
                        .padding(.top, 50)
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(screenId.capitalized)
    }
}
