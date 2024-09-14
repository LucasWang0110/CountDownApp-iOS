//
//  NewEventView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/18.
//

import PhotosUI
import SwiftUI
import SwiftData
import MapKit

struct EventInfoView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Bindable var eventViewModel: EventViewModel
    
    @State private var showLocationSearchSheet = false
    
    //start date time
    @State private var showStartDatePicker = false
    @State private var showStartTimePicker = false
    //end date time
    @State private var showEndDatePicker = false
    @State private var showEndTimePicker = false
    
    @State private var showGallery = false
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var images: [Data] = []
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Event title", text: $eventViewModel.event.title, prompt: Text("Title"))
                        .withClearButton(for: $eventViewModel.event.title)
                    
                    if let location = eventViewModel.eventLocation {
                        HStack {
                            HStack {
                                Text(location.title)
                                Spacer()
                            }
                            .contentShape(.rect)
                            .onTapGesture { showLocationSearchSheet = true }
                            
                            Button(action: {
                                eventViewModel.eventLocation = nil
                            }, label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .opacity(0.5)
                            })
                        }
                    } else {
                        HStack {
                            Text("Location").foregroundStyle(.gray).opacity(0.5)
                            Spacer()
                        }
                        .contentShape(.rect)
                        .onTapGesture { showLocationSearchSheet = true }
                    }
                    
                    TextField("Remark", text: $eventViewModel.event.remark, prompt: Text("Remark"), axis: .vertical)
                        .multilineTextAlignment(.leading)
                        .lineLimit(5...100)
                }
                
                //date time section
                Section {
                    Toggle(isOn: $eventViewModel.event.allDay, label: {
                        Label("All day", systemImage: "clock.fill")
                            .labelStyle(SettingIconStyle(bgColor: .blue))
                    })
                    HStack {
                        Label("Start", systemImage: "calendar")
                            .labelStyle(SettingIconStyle(bgColor: .green))
                        Spacer()
                        Group {
                            Button(action: {
                                showStartDatePicker.toggle()
                                toggleState(value: &showStartTimePicker)
                                toggleState(value: &showEndDatePicker)
                                toggleState(value: &showEndTimePicker)
                            }, label: {
                                Text(eventViewModel.event.startTime.formatted(date: .numeric, time: .omitted))
                            })
                            
                            if !eventViewModel.event.allDay {
                                Button(action: {
                                    showStartTimePicker.toggle()
                                    toggleState(value: &showStartDatePicker)
                                    toggleState(value: &showEndDatePicker)
                                    toggleState(value: &showEndTimePicker)
                                }, label: {
                                    Text(eventViewModel.event.startTime.formatted(date: .omitted, time: .shortened))
                                })
                            }
                        }
                        .buttonStyle(.bordered)
                        .foregroundStyle(.green)
                    }
                    
                    if showStartDatePicker {
                        DatePicker("Start Date", selection: $eventViewModel.event.startTime, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                    }
                    
                    if showStartTimePicker {
                        DatePicker("Start Time", selection: $eventViewModel.event.startTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                    }
                    
                    HStack {
                        Label("End", systemImage: "calendar.badge.checkmark").labelStyle(SettingIconStyle(bgColor: .red))
                        
                        Group {
                            Button(action: {
                                showEndDatePicker.toggle()
                                toggleState(value: &showEndTimePicker)
                                toggleState(value: &showStartDatePicker)
                                toggleState(value: &showStartTimePicker)
                            }, label: {
                                Text(eventViewModel.event.endTime.formatted(date: .numeric, time: .omitted))
                            })
                            
                            if !eventViewModel.event.allDay {
                                Button(action: {
                                    showEndTimePicker.toggle()
                                    toggleState(value: &showEndDatePicker)
                                    toggleState(value: &showStartDatePicker)
                                    toggleState(value: &showStartTimePicker)
                                }, label: {
                                    Text(eventViewModel.event.endTime.formatted(date: .omitted, time: .shortened))
                                })
                            }
                        }
                        .buttonStyle(.bordered)
                        .foregroundStyle(.red)
                    }
                    
                    if showEndDatePicker {
                        DatePicker("Start Date", selection: $eventViewModel.event.endTime, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                    }
                    
                    if showEndTimePicker {
                        DatePicker("Start Time", selection: $eventViewModel.event.endTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                    }
                }
                .onChange(of: eventViewModel.event.startTime) {
                    if eventViewModel.event.startTime.timeIntervalSince(eventViewModel.event.endTime) >= 0 {
                        //TODO: add 1 day to endDateTime
                    }
                }
                
                Section {
                    VStack(alignment: .leading) {
                        Menu("Add images", content: {
                            Button("Take photo", systemImage: "camera", action: {})
                            Button("Open gallery", systemImage: "photo.on.rectangle", action: { showGallery.toggle() })
                        })
                        if !images.isEmpty {
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(images.indices, id: \.self) { index in
                                        ImageItemView(imageData: images[index]) {
                                            images.remove(at: index)
                                            selectedItems.remove(at: index)
                                        }
                                    }
                                }
                            }
                            .scrollIndicators(.hidden)
                        }
                    }
                }
                
                Section {
                    Button("Load from Event Center", systemImage: "square.and.arrow.down", action: {})
                }
            }
            .navigationTitle(Text("New Event"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction, content: {
                    Button(eventViewModel.openMode == .edit ? "Save" : "Add", action: {
                        eventViewModel.save()
                        dismiss()
                    })
                })
            }
            .photosPicker(isPresented: $showGallery, selection: $selectedItems, maxSelectionCount: 20, matching: .images)
            .onChange(of: selectedItems) { oldItems, newItems in
                for item in newItems where !oldItems.contains(item) {
                    Task {
                        if let data = try? await item.loadTransferable(type: Data.self), !images.contains(data) {
                            images.append(data)
                        }
                    }
                }
            }
            .sheet(isPresented: $showLocationSearchSheet, content: {
                LocationSearchView(eventLocation: $eventViewModel.eventLocation)
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
    let container = try! ModelContainer(for: MyEvent.self, EventLocation.self, configurations: config)
    let event = MyEvent(title: "event", remark: "", allDay: false)
    return EventInfoView(eventViewModel: EventViewModel(event: event, modelContext: container.mainContext, openMode: .new))
}
