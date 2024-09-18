//
//  NewItemView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/4.
//

import SwiftUI

struct NewItemView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    var itemList: ItemList
    
    @State private var title = ""
    @State private var remark = ""
    @State private var toggleAllDay = false
    //start date time
    @State private var startDateTime = Date.now
    @State private var showStartDatePicker = false
    @State private var showStartTimePicker = false
    //end date time
    @State private var endDateTime = Date.now
    @State private var showEndDatePicker = false
    @State private var showEndTimePicker = false
    //remind
    @State private var selectedRemind: Remind = .none
    //priority
    @State private var selectedPriority: Priority = .none
    //flag
    @State private var toggleFlag = false
    
    var body: some View {
        NavigationStack {
            
            Form {
                //title section
                Section {
                    TextField("title", text: $title)
                    TextField("remark", text: $remark, axis: .vertical)
                        .multilineTextAlignment(.leading)
                        .lineLimit(5...100)
                    
                }
                
                //date time section
                Section {
                    Toggle(isOn: $toggleAllDay, label: {
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
                                Text(startDateTime.formatted(date: .numeric, time: .omitted))
                            })
                            
                            if !toggleAllDay {
                                Button(action: {
                                    showStartTimePicker.toggle()
                                    toggleState(value: &showStartDatePicker)
                                    toggleState(value: &showEndDatePicker)
                                    toggleState(value: &showEndTimePicker)
                                }, label: {
                                    Text(startDateTime.formatted(date: .omitted, time: .shortened))
                                })
                            }
                        }
                        .buttonStyle(.bordered)
                        .foregroundStyle(.green)
                    }
                    
                    if showStartDatePicker {
                        DatePicker(
                            "Start Date",
                            selection: $startDateTime,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.graphical)
                    }
                    
                    
                    if showStartTimePicker {
                        DatePicker("Start Time", selection: $startDateTime, displayedComponents: .hourAndMinute)
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
                                Text(endDateTime.formatted(date: .numeric, time: .omitted))
                            })
                            
                            if !toggleAllDay {
                                Button(action: {
                                    showEndTimePicker.toggle()
                                    toggleState(value: &showEndDatePicker)
                                    toggleState(value: &showStartDatePicker)
                                    toggleState(value: &showStartTimePicker)
                                }, label: {
                                    Text(endDateTime.formatted(date: .omitted, time: .shortened))
                                })
                            }
                        }
                        .buttonStyle(.bordered)
                        .foregroundStyle(.red)
                    }
                    
                    if showEndDatePicker {
                        DatePicker(
                            "Start Date",
                            selection: $endDateTime,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.graphical)
                    }
                    
                    
                    if showEndTimePicker {
                        DatePicker("Start Time", selection: $endDateTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                    }
                }
                
                //remind section
                Section {
                    Picker(selection: $selectedRemind, content: {
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
                    
//                    Picker(selection: $selectedRemind, content: {
//                        ForEach(Remind.allCases) { item in
//                            Text(item.rawValue)
//                            if item == .none || item == .sixMonth {
//                                Divider()
//                            }
//                        }
//                    }, label: {
//                        Label("Repeat", systemImage: "repeat")
//                            .labelStyle(ColorfulIconLabelStyle(bgColor: .gray))
//                    })
                }
                
                //flag priority section
                Section {
                    Toggle(isOn: $toggleFlag, label: {
                        Label("Flag", systemImage: "flag.fill")
                            .labelStyle(SettingIconStyle(bgColor: .yellow))
                    })
                    Picker(selection: $selectedPriority, content: {
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
            .navigationTitle(Text("New Item"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", action: { dismiss() })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done", action: {
                        saveListItem()
                        dismiss()
                    })
                }
            }
            
        }
    }
    
    func toggleState(value: inout Bool) {
        if value {
            value.toggle()
        }
    }
    
    func saveListItem() {
        if toggleAllDay {
            startDateTime = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: startDateTime)!
            endDateTime = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: endDateTime)!
        }
        let createTime = Date()
        let item = Item(title: title, remark: remark, allDay: toggleAllDay, startTime: startDateTime, endTime: endDateTime, remind: selectedRemind, repeatInfo: RepeatEnum.none, flag: toggleFlag, priority: selectedPriority, parentListId: itemList.id, isDone: false, createTime: createTime, updateTime: createTime)
        modelContext.insert(item)
        itemList.items.append(item)
        do {
            try modelContext.save()
            print("Item saved successfully.")
        } catch {
            print("Failed to save item: \(error)")
        }
    }
}

#Preview {
    NewItemView(itemList: ItemList.sampleData)
}
