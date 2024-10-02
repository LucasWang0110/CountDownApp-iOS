//
//  ItemListInfoView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/3.
//

import SwiftUI
import SwiftData

struct ItemListInfoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) var dismiss
    
    @Bindable var itemListViewModel: ItemListViewModel
    @State private var showCancelConfirm = false
    @State private var showValidationAlert = false
    
    let gridItemLayout = [GridItem(.adaptive(minimum: 44))]
    
    var body: some View {
        
        NavigationStack {
            Form {
                Section {
                    VStack {
                        ZStack {
                            Circle()
                                .foregroundStyle(Color(hex: itemListViewModel.itemList.themeColor)!)
                            Image(systemName: itemListViewModel.itemList.icon)
                                .foregroundStyle(.white)
                                .font(.system(size: 40))
                                .bold()
                        }
                        .frame(width: 96, height: 96)
                        
                        HStack {
                            TextField("", text: $itemListViewModel.itemList.title, prompt: Text("List name"))
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
                                        .gray.opacity(itemListViewModel.itemList.themeColor == color.toHex()! ? 0.3 : 0),
                                        lineWidth: 4)
                                Circle()
                                    .fill(color)
                                    .frame(width: 38)
                            }
                            .onTapGesture {
                                itemListViewModel.itemList.themeColor = color.toHex()!
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
                                        .gray.opacity(itemListViewModel.itemList.icon == symbol ? 0.3 : 0),
                                        lineWidth: 4)
                                Button(action: {
                                    itemListViewModel.itemList.icon = symbol
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
                        if itemListViewModel.somethingChanged() {
                            showCancelConfirm.toggle()
                        } else {
                            dismiss()
                        }
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", action: {
                        itemListViewModel.save()
                        dismiss()
                    })
                    .disabled(itemListViewModel.itemList.title.isEmpty)
                }
            }
            .confirmationDialog("", isPresented: $showCancelConfirm, actions: {
                Button("Drop change", role: .destructive, action: { dismiss() })
                Button("Cancel", role: .cancel, action: { showCancelConfirm.toggle() })
            })
            .alert("Please input list name", isPresented: $showValidationAlert, actions: {
                Button("OK", action: { showValidationAlert.toggle() })
            })
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ItemList.self, configurations: config)
    let model = ItemList(title: "", themeColor: sampleColors[0].toHex()!, icon: sampleSymbols[0])
    return ItemListInfoView(itemListViewModel: ItemListViewModel(itemList: model, modelContext: container.mainContext, openMode: .new))
}
