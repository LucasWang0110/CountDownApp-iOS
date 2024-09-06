//
//  MemoryDayView.swift
//  CountDownApp
//
//  Created by lucas on 2024/9/1.
//

import SwiftUI

struct MemoryDayInfoView: View {

    @State private var title = ""
    @State private var date = Date()
    @State private var toggleTime = false
    @State private var showTimePicker = true
    @State private var remind: Remind = .none
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title, prompt: Text("Input Title"))
                    
                    DatePicker(selection: $date, displayedComponents: [.date], label: {
                        Label("Date", systemImage: "calendar").labelStyle(SettingIconStyle(bgColor: .red))
                    })
                    
                    Toggle(isOn: $toggleTime, label: {
                        Label("Time", systemImage: "clock.fill").labelStyle(SettingIconStyle(bgColor: .blue))
                            .contentShape(.rect)
                            .onTapGesture {
                                showTimePicker.toggle()
                            }
                    })
                    .onChange(of: toggleTime, {
                        showTimePicker = toggleTime
                    })
                    if toggleTime {
                        HStack {
                            Spacer()
                            Text("\(date.formatted(date: .omitted, time: .shortened))")
                        }
                    }
                    
                    if toggleTime && showTimePicker {
                        DatePicker("", selection: $date, displayedComponents: [.hourAndMinute]).datePickerStyle(.wheel)
                    }
                    
                    Picker(selection: $remind, content: {
                        ForEach(Remind.allCases) { item in
                            Text(item.rawValue)
                            if item == .none || item == .sixMonth {
                                Divider()
                            }
                        }
                    }, label: {
                        Label("Remind", systemImage: "bell.fill").labelStyle(SettingIconStyle(bgColor: .purple))
                    })
                    
                    Picker(selection: $remind, content: {
                        ForEach(Remind.allCases) { item in
                            Text(item.rawValue)
                            if item == .none || item == .sixMonth {
                                Divider()
                            }
                        }
                    }, label: {
                        Label("Repeat", systemImage: "repeat").labelStyle(SettingIconStyle(bgColor: .secondary))
                    })
                }
                Section {
                    Text("font style & color")
                }
            }
            .navigationTitle(Text("Memory day"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button("Save", action: {})
                })
            }
        }
    }
}

#Preview {
    MemoryDayInfoView()
}
