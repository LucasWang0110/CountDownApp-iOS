//
//  ImageGrid.swift
//  CountDownApp
//
//  Created by lucas on 2024/9/1.
//

import SwiftUI
import QuickLookThumbnailing

struct ImageItemView: View {
    let imageData: Data
    let onDelete: () -> Void
    
    @State private var uiImage: UIImage? = nil
    @State private var isLoading = true
    @State private var showFullScreen = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if isLoading {
                ProgressView()
                    .frame(width: 100, height: 100)
            } else if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
            }
            
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white)
                    .background(Color.black.opacity(0.6))
                    .clipShape(Circle())
            }
            .padding(5)
        }
        .onAppear {
            Task {
                await loadThumbnailAsync()
            }
        }
        .fullScreenCover(isPresented: $showFullScreen) {
            FullScreenImageView(imageData: imageData, isPresented: $showFullScreen)
        }
    }
    
    private func loadThumbnailAsync() async {
        let fileURL = saveImageToTempDirectory()
        let size = CGSize(width: 100, height: 100)
        
        let request = await QLThumbnailGenerator.Request(fileAt: fileURL,
                                                   size: size,
                                                   scale: UIScreen.main.scale,
                                                   representationTypes: .thumbnail)
        
        let generator = QLThumbnailGenerator.shared
        do {
            let thumbnail = try await generator.generateBestRepresentation(for: request)
            await MainActor.run {
                self.uiImage = thumbnail.uiImage
                self.isLoading = false
            }
        } catch {
            print("Failed to generate thumbnail: \(error)")
        }
    }
    
    private func saveImageToTempDirectory() -> URL {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(UUID().uuidString + ".jpg")
        
        do {
            try imageData.write(to: fileURL)
        } catch {
            print("Error saving image to temp directory: \(error)")
        }
        
        return fileURL
    }
    
    private func loadImageAsync() async {
        if let loadedImage = UIImage(data: imageData) {
            await MainActor.run {
                self.uiImage = loadedImage
                self.isLoading = false
            }
        }
    }
}

struct FullScreenImageView: View {
    let imageData: Data
    @Binding var isPresented: Bool
    
    var body: some View {
        if let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
                .background(Color.black)
                .onTapGesture {
                    isPresented = false
                }
                .gesture(DragGesture(minimumDistance: 50).onEnded { _ in
                    isPresented = false
                })
        }
    }
}
