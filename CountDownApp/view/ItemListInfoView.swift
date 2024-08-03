//
//  ItemListInfoView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/3.
//

import SwiftUI

struct ItemListInfoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) var dismiss
    
    @Binding var itemList: ItemList
    @State private var listName: String = "11"
    
    let gridItemLayout = [GridItem(.adaptive(minimum: 44))]
    
    var body: some View {
        
        NavigationStack {
            Form {
                Section {
                    VStack {
                        ZStack {
                            Circle()
                                .foregroundStyle(Color(hex: itemList.themeColor)!)
                            Image(systemName: itemList.icon)
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
                                        .gray.opacity(itemList.themeColor == color.toHex()! ? 0.3 : 0),
                                        lineWidth: 4)
                                Circle()
                                    .fill(color)
                                    .frame(width: 38)
                            }
                            .onTapGesture {
                                itemList.themeColor = color.toHex()!
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
                                        .gray.opacity(itemList.icon == symbol ? 0.3 : 0),
                                        lineWidth: 4)
                                Button(action: {
                                    itemList.icon = symbol
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
                        dismiss()
                    })
                }
            }
            .onAppear {
                listName = itemList.title
            }
        }
    }
}

#Preview {
    ItemListInfoView(itemList: .constant(ItemList.sampleData))
}
