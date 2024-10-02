//
//  NewItemView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/4.
//

import SwiftUI
import SwiftData

struct ItemView: View {
    @Environment(\.dismiss) var dismiss
    
    @Bindable var itemViewModel: ItemViewModel
    
    //start date time
    @State private var showStartDatePicker = false
    @State private var showStartTimePicker = false
    //end date time
    @State private var showEndDatePicker = false
    @State private var showEndTimePicker = false
    
    @State private var showCancelConfirm = false
    
    var body: some View {
        NavigationStack {
            
            Form {
                //title section
                Section {
                    TextField("title", text: $itemViewModel.item.title)
                    TextField("remark", text: $itemViewModel.item.remark, axis: .vertical)
                        .multilineTextAlignment(.leading)
                        .lineLimit(5...100)
                    
                }
                
                //date time section
                Section {
                    Toggle(isOn: $itemViewModel.item.allDay, label: {
                        Label("All day", systemImage: "clock.fill")
                            .labelStyle(SettingIconStyle(bgColor: .blue))
                    })
                    HStack {
                        Label("Start", systemImage: "calendar")
                            .labelStyle(SettingIconStyle(bgColor: .green))
                        
                        Group {
                            Button(action: {
                                showStartDatePicker.toggle()
                                toggleState(value: &showStartTimePicker)
                                toggleState(value: &showEndDatePicker)
                                toggleState(value: &showEndTimePicker)
                            }, label: {
                                Text(itemViewModel.item.startTime.formatted(date: .numeric, time: .omitted))
                            })
                            
                            if !itemViewModel.item.allDay {
                                Button(action: {
                                    showStartTimePicker.toggle()
                                    toggleState(value: &showStartDatePicker)
                                    toggleState(value: &showEndDatePicker)
                                    toggleState(value: &showEndTimePicker)
                                }, label: {
                                    Text(itemViewModel.item.startTime.formatted(date: .omitted, time: .shortened))
                                })
                            }
                        }
                        .buttonStyle(.bordered)
                        .foregroundStyle(.green)
                    }
                    
                    if showStartDatePicker {
                        DatePicker(
                            "Start Date",
                            selection: $itemViewModel.item.startTime,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.graphical)
                    }
                    
                    
                    if showStartTimePicker {
                        DatePicker("Start Time", selection: $itemViewModel.item.startTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                    }
                    
                    HStack {
                        Label("End", systemImage: "calendar.badge.checkmark")
                            .labelStyle(SettingIconStyle(bgColor: .red))
                        
                        Group {
                            Button(action: {
                                showEndDatePicker.toggle()
                                toggleState(value: &showEndTimePicker)
                                toggleState(value: &showStartDatePicker)
                                toggleState(value: &showStartTimePicker)
                            }, label: {
                                Text(itemViewModel.item.endTime.formatted(date: .numeric, time: .omitted))
                            })
                            
                            if !itemViewModel.item.allDay {
                                Button(action: {
                                    showEndTimePicker.toggle()
                                    toggleState(value: &showEndDatePicker)
                                    toggleState(value: &showStartDatePicker)
                                    toggleState(value: &showStartTimePicker)
                                }, label: {
                                    Text(itemViewModel.item.endTime.formatted(date: .omitted, time: .shortened))
                                })
                            }
                        }
                        .buttonStyle(.bordered)
                        .foregroundStyle(.red)
                    }
                    
                    if showEndDatePicker {
                        DatePicker(
                            "Start Date",
                            selection: $itemViewModel.item.endTime,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.graphical)
                    }
                    
                    
                    if showEndTimePicker {
                        DatePicker("Start Time", selection: $itemViewModel.item.endTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                    }
                }
                
                //remind section
                Section {
                    Picker(selection: $itemViewModel.item.remind, content: {
                        ForEach(Remind.allCases) { item in
                            Text(item.rawValue)
                            if item == .none || item == .sixMonth {
                                Divider()
                            }
                        }
                    }, label: {
                        Label("Remind", systemImage: "bell.fill")
                            .labelStyle(SettingIconStyle(bgColor: .purple))
                    })
                }
                
                //flag priority section
                Section {
                    Toggle(isOn: $itemViewModel.item.flag, label: {
                        Label("Flag", systemImage: "flag.fill")
                            .labelStyle(SettingIconStyle(bgColor: .yellow))
                    })
                    Picker(selection: $itemViewModel.item.priority, content: {
                        ForEach(Priority.allCases) { item in
                            Text(item.rawValue)
                            if item == .none {
                                Divider()
                            }
                        }
                    }, label: {
                        Label("Priority", systemImage: "arrow.up.to.line.compact")
                            .labelStyle(SettingIconStyle(bgColor: .red))
                    })
                }
            }
            .listSectionSpacing(20)
            .navigationTitle(Text(itemViewModel.openMode == .new ? "New Item" : "Information"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", action: { dismiss() })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done", action: {
                        itemViewModel.save()
                        dismiss()
                    })
                }
            }
            .confirmationDialog("", isPresented: $showCancelConfirm, actions: {
                Button("Drop change", role: .destructive, action: { dismiss() })
                Button("Cancel", role: .cancel, action: { showCancelConfirm.toggle() })
            })
            
        }
    }
    
    func toggleState(value: inout Bool) {
        if value {
            value.toggle()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Item.self, ItemList.self, configurations: config)
    let item = Item(title: "", remark: "")
    return ItemView(itemViewModel: ItemViewModel(item: item, itemList: ItemList.sampleData, modelContext: container.mainContext, openMode: .new))
}
