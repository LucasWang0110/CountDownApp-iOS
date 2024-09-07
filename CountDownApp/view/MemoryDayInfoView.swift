//
//  MemoryDayView.swift
//  CountDownApp
//
//  Created by lucas on 2024/9/1.
//

import SwiftUI
import SwiftData

struct MemoryDayInfoView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var memoryDayViewModel: MemoryDayViewModel

    @State private var title = ""
    @State private var date = Date()
    @State private var toggleTime = false
    @State private var showTimePicker = true
    @State private var remind: Remind = .none
    @State private var repeatInfo: RepeatEnum = .none
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $memoryDayViewModel.memoryDay.title, prompt: Text("Input Title"))
                    
                    DatePicker(selection: $memoryDayViewModel.memoryDay.date, displayedComponents: [.date], label: {
                        Label("Date", systemImage: "calendar").labelStyle(SettingIconStyle(bgColor: .red))
                    })
                    
                    Toggle(isOn: $memoryDayViewModel.memoryDay.displayTime, label: {
                        Label("Time", systemImage: "clock.fill").labelStyle(SettingIconStyle(bgColor: .blue))
                            .contentShape(.rect)
                            .onTapGesture {
                                showTimePicker.toggle()
                            }
                    })
                    .onChange(of: memoryDayViewModel.memoryDay.displayTime, {
                        showTimePicker = memoryDayViewModel.memoryDay.displayTime
                    })
                    if memoryDayViewModel.memoryDay.displayTime {
                        HStack {
                            Spacer()
                            Text("\(date.formatted(date: .omitted, time: .shortened))")
                        }
                    }
                    
                    if memoryDayViewModel.memoryDay.displayTime && showTimePicker {
                        DatePicker("", selection: $date, displayedComponents: [.hourAndMinute]).datePickerStyle(.wheel)
                    }
                    
                    Picker(selection: $memoryDayViewModel.memoryDay.remind, content: {
                        ForEach(Remind.allCases) { item in
                            Text(item.rawValue)
                            if item == .none || item == .sixMonth {
                                Divider()
                            }
                        }
                    }, label: {
                        Label("Remind", systemImage: "bell.fill").labelStyle(SettingIconStyle(bgColor: .purple))
                    })
                    
                    Picker(selection: $memoryDayViewModel.memoryDay.repeatInfo, content: {
                        ForEach(RepeatEnum.allCases) { item in
                            Text(item.rawValue)
                            if item == .none || item == .everyYear {
                                Divider()
                            }
                        }
                    }, label: {
                        Label("Repeat", systemImage: "repeat").labelStyle(SettingIconStyle(bgColor: .secondary))
                    })
                }
                //TODO: change font style and color of displayed text
            }
            .navigationTitle(Text("Memory day"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button("Save", action: { 
                        memoryDayViewModel.save()
                        dismiss()
                    })
                })
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: MemoryDayModel.self, configurations: config)
    let model = MemoryDayModel(title: "Get to work", date: .now)
    return MemoryDayInfoView(memoryDayViewModel: MemoryDayViewModel(memoryDay: model, modelContext: container.mainContext, openMode: .edit))
}
