//
//  NewItemListView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/3.
//

import SwiftUI

struct NewItemListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) var dismiss
    
    @State private var listName: String = ""
    @State private var selectedColor: String = sampleColors[0].toHex()!
    @State private var selectedSymbol: String = sampleSymbols[0]

    
    let gridItemLayout = [GridItem(.adaptive(minimum: 44))]
    
    var body: some View {
        
        NavigationStack {
            Form {
                Section {
                    VStack {
                        ZStack {
                            Circle()
                                .foregroundStyle(Color(hex: selectedColor)!)
                            Image(systemName: selectedSymbol)
                                .foregroundStyle(.white)
                                .font(.system(size: 40))
                                .bold()
                        }
                        .frame(width: 96, height: 96)
                        
                        HStack {
                            TextField("", text: $listName, prompt: Text("List name"))
                                .font(.title)
                                .bold()
                                .lineLimit(1)
                                .multilineTextAlignment(.center)
                                .truncationMode(.tail)
                        }
                        .padding()
                        .background(Color(uiColor: colorScheme == .light ? .secondarySystemBackground : .darkGray))
                        .clipShape(.buttonBorder)
                    }
                }
                
                Section {
                    LazyVGrid(columns: gridItemLayout, spacing: 10) {
                        ForEach(sampleColors, id: \.self) { color in
                            ZStack {
                                Circle()
                                    .stroke(
                                        .gray.opacity(selectedColor == color.toHex()! ? 0.3 : 0),
                                        lineWidth: 4)
                                Circle()
                                    .fill(color)
                                    .frame(width: 38)
                            }
                            .onTapGesture {
                                selectedColor = color.toHex()!
                            }
                        }
                    }
                }
                
                Section {
                    LazyVGrid(columns: gridItemLayout, spacing: 10) {
                        ForEach(sampleSymbols, id: \.self) { symbol in
                            ZStack {
                                Circle()
                                    .stroke(
                                        .gray.opacity(selectedSymbol == symbol ? 0.3 : 0),
                                        lineWidth: 4)
                                Button(action: {
                                    selectedSymbol = symbol
                                }, label: {
                                    Image(systemName: symbol)
                                        .foregroundStyle( colorScheme == .light ? .gray : .white)
                                })
                                .buttonStyle(.bordered)
                                .clipShape(Circle())
                            }
                        }
                    }
                }
            }
            .listSectionSpacing(20)
            .navigationTitle(Text("New list"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", action: {
                        dismiss()
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done", action: {
                        let list = ItemList(title: listName, themeColor: selectedColor, icon: selectedSymbol)
                        modelContext.insert(list)
                        dismiss()
                    })
                }
            }
        }
    }
}

#Preview {
    NewItemListView()
}
