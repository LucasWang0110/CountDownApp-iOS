//
//  AddLifeExpView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/13.
//

import PhotosUI
import SwiftUI

struct AddLifeExpView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var date = Date()
    
    @State private var showingPicOption = false
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var showingPhotosPicker = false
    
    @State private var toggleRemindMe = true
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    
                    VStack(spacing: 20) {
                        Circle().fill(Color(uiColor: .secondarySystemBackground)).frame(width: 100)
                            .overlay {
                                if let img = avatarImage {
                                    img.resizable().scaledToFill().frame(width: 100).clipShape(Circle())
                                } else {
                                    Image(systemName: "photo.badge.plus.fill").font(.title).foregroundStyle(.gray)
                                }
                            }
                            .onTapGesture {
                                showingPicOption.toggle()
                            }
                        HStack {
                            TextField("", text: $title, prompt: Text("List name"))
                                .font(.title)
                                .bold()
                                .lineLimit(1)
                                .multilineTextAlignment(.center)
                                .truncationMode(.tail)
                            
                            if !title.isEmpty {
                                Button(action: { title = "" }, label: {
                                    Image(systemName: "x.circle.fill").foregroundStyle(.gray).font(.title3)
                                })
                            }
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding([.bottom])
                }
                
                Section {
                    DatePicker(selection: $date, displayedComponents: [.date], label: {
                        Label("Birthday", systemImage: "birthday.cake.fill")
                            .labelStyle(SettingIconStyle(bgColor: .green))
                    })
                    
                    Toggle(isOn: $toggleRemindMe, label: {
                        Label("Remind me", systemImage: "clock.fill")
                            .labelStyle(SettingIconStyle(bgColor: .red))
                    })
                }
            }
            .navigationTitle(Text("Life Expentancy"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading, content: {
                    Button("Cancel", action: { dismiss() })
                })
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button("Save", action: {})
                })
            }
            .confirmationDialog("Upload picture", isPresented: $showingPicOption, titleVisibility: .visible) {
                Button("take photo", systemImage: "camera", action: {})
                Button("open gallery", systemImage: "camera", action: { showingPhotosPicker.toggle() })
            }
            .photosPicker(isPresented: $showingPhotosPicker, selection: $avatarItem, matching: .images)
//            .onChange(of: avatarItem) {
//                Task {
//                    if let data = try? await avatarItem?.loadTransferable(type: Data.self),
//                       let uiImage = UIImage(data: data) {
//                       avatarImage = Image(uiImage: uiImage)
//                    } else {
//                        print("Failed to load image")
//                    }
//                }
//            }
        }
    }
}

#Preview {
    AddLifeExpView()
}
