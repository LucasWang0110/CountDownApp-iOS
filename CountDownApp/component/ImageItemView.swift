//
//  ImageGrid.swift
//  CountDownApp
//
//  Created by lucas on 2024/9/1.
//

import SwiftUI

struct ImageItemView: View {
    let imageData: Data
    let onDelete: () -> Void
    
    @State private var showFullScreen = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .onTapGesture {
                        showFullScreen.toggle()
                    }
            }
            
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white)
                    .background(Color.black.opacity(0.6))
                    .clipShape(Circle())
            }
            .padding(5)
        }
        .fullScreenCover(isPresented: $showFullScreen) {
            FullScreenImageView(imageData: imageData, isPresented: $showFullScreen)
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
