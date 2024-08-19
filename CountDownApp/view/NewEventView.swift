//
//  NewEventView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/18.
//

import PhotosUI
import SwiftUI
import MapKit

struct NewEventView: View {
    
    let editEvent: Bool
    
    @State private var title = ""
    @State private var remark = ""
    @State private var location = ""
    @State private var showLocationSearchSheet = false
    
    @State private var toggleAllDay = false
    //start date time
    @State private var startDateTime = Date.now
    @State private var showStartDatePicker = false
    @State private var showStartTimePicker = false
    //end date time
    @State private var endDateTime = Date.now
    @State private var showEndDatePicker = false
    @State private var showEndTimePicker = false
    
    @State private var showGallery = false
    @State private var imageItem: PhotosPickerItem?
    @State private var images: [Data] = []
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Event title", text: $title, prompt: Text("Title"))
                        .withClearButton(for: $title)
                    
                    TextField("Location", text: $location, prompt: Text("Location"))
                        .disabled(true)
                        .withClearButton(for: $location)
                        .contentShape(.rect)
                        .onTapGesture {
                            showLocationSearchSheet.toggle()
                        }
                    
                    TextField("Remark", text: $remark, prompt: Text("Remark"), axis: .vertical)
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
                        DatePicker("Start Date", selection: $startDateTime, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                    }
                    
                    if showStartTimePicker {
                        DatePicker("Start Time", selection: $startDateTime, displayedComponents: .hourAndMinute)
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
                        DatePicker("Start Date", selection: $endDateTime, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                    }
                    
                    if showEndTimePicker {
                        DatePicker("Start Time", selection: $endDateTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                    }
                }
                .onChange(of: startDateTime) {
                    if startDateTime.timeIntervalSince(endDateTime) >= 0 {
                        //TODO: add 1 day to endDateTime
                    }
                }
                
                Section {
                    Button(action: { print("add attachement") }, label: {
                        Text("Add attachment...")
                    })
                    VStack(alignment: .leading) {
                        Menu("Add images", content: {
                            Button("Take photo", systemImage: "camera", action: {})
                            Button("Open gallery", systemImage: "photo.on.rectangle", action: { showGallery.toggle() })
                        })
                        List(images, id: \.self) { imageData in
                            if let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
            }
            .navigationTitle(Text("New Event"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction, content: {
                    if editEvent {
                        Button("Save", action: {})
                    } else {
                        Button("Add", action: {})
                    }
                })
                
                ToolbarItem(placement: .cancellationAction, content: {
                    Button("Cancel", action: {})
                })
            }
            .sheet(isPresented: $showLocationSearchSheet, content: {
                LocationSearchView()
            })
            .photosPicker(isPresented: $showGallery, selection: $imageItem, matching: .images)
            .onChange(of: imageItem) {
                Task {
                    if let data = try? await imageItem?.loadTransferable(type: Data.self) {
                        images.append(data)
                    } else {
                        print("Failed to load image")
                    }
                }
            }
        }
    }
    
    func toggleState(value: inout Bool) {
        if value {
            value.toggle()
        }
    }
}

#Preview {
    NewEventView(editEvent: true)
}
