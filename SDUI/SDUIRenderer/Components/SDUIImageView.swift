//
//  SDUIImageView.swift
//  SDUI
//
//  Created by AbdelNasser Ramzy on 07/12/2025.
//

import SwiftUI
import Combine

struct SDUIImageView: View {
    let component: SDUIComponent
    
    var body: some View {
        if let imageType = component.imageType, imageType.lowercased() == "local" {
            if let imageUrl = component.imageUrl {
                Image(systemName: imageUrl)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.blue)
            }
        } else {
           if let urlString = component.imageUrl {
                RemoteImage(url: urlString)
            } else {
                PlaceholderView()
            }
        }
    }
}

struct RemoteImage: View {
    let url: String
    @StateObject private var loader = ImageLoader()
    
    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if loader.isLoading {
                ProgressView()
                    .scaleEffect(1.2)
            } else {
                PlaceholderView()
            }
        }
        .onAppear {
            loader.load(from: url)
        }
    }
}

// MARK: - Helper View
struct PlaceholderView: View {
    var body: some View {
        VStack {
            Image(systemName: "photo.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
                .foregroundColor(.gray)
            Text("Failed to load")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(minHeight: 100)
    }
}

// MARK: - Image Loader Logic
class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    
    func load(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let data = data, let loadedImage = UIImage(data: data) {
                    self?.image = loadedImage
                }
            }
        }.resume()
    }
}
