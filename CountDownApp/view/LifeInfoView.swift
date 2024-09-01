//
//  LifeInfoView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/11.
//

import SwiftUI
import SwiftData

struct LifeInfoView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var lifeViewModel: LifeViewModel
    
    @State private var edit = false
    @State private var showDatePicker = false
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 20) {
                    HStack {
                        TextField("title", text: $lifeViewModel.life.title, prompt: Text("input title"))
                            .font(.system(.title, design: .rounded, weight: .bold))
                            .lineLimit(1)
                            .multilineTextAlignment(.center)
                            .truncationMode(.tail)
                            .padding()
                            .background(.gray.opacity(edit || lifeViewModel.openMode == .new ? 0.1 : 0), in: RoundedRectangle(cornerRadius: 12))
                            .disabled(lifeViewModel.openMode != .new)
                            .autocorrectionDisabled()
                    }
                    
                    
                    HStack(alignment: .lastTextBaseline) {
                        Text(lifeViewModel.life.remainingDays, format: .number.decimalSeparator(strategy: .automatic)).font(.system(size: 40, weight: .bold, design: .rounded))
                        Image(systemName: "questionmark.circle.fill").foregroundStyle(.gray)
                    }
                    
                    HStack {
                        if edit || lifeViewModel.openMode == .new {
                            DatePicker(selection: $lifeViewModel.life.birthday, displayedComponents: [.date], label: {}).fixedSize().autocorrectionDisabled()
                        } else {
                            Text("\(lifeViewModel.life.birthday.formatted(date: .numeric, time: .omitted))").font(.system(.title3, design: .rounded, weight: .bold))
                        }
                        
                        Spacer()
                        
                        HStack(alignment: .lastTextBaseline) {
                            Text("\(lifeViewModel.life.daysUntilNextBirthday)").font(.system(.title, design: .rounded, weight: .bold))
                            Text("days").foregroundStyle(.gray)
                        }
                    }
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.5), lineWidth: 2)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle(Text(lifeViewModel.openMode == .new ? "New Life" : ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if lifeViewModel.openMode == .new {
                        Button("Add", action: { 
                            lifeViewModel.saveModel()
                            dismiss()
                        }).disabled(lifeViewModel.life.title.isEmpty)
                    } else {
                        if edit {
                            Button("Done", action: {
                                withAnimation(.spring(duration: 0.2)) { edit.toggle() }
                                lifeViewModel.updateModel()
                                dismiss()
                            })
                        } else {
                            Button("Edit", action: {
                                withAnimation(.spring(duration: 0.2)) { edit.toggle() }
                            })
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    if lifeViewModel.openMode == .new {
                        Button("Cancel", action: { dismiss() })
                    }
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: LifeModel.self, configurations: config)
    let life = LifeModel(title: "", birthday: Date())
    return LifeInfoView(lifeViewModel: LifeViewModel(life: life, lifeList: [], modelContext: container.mainContext, openMode: .new))
}
