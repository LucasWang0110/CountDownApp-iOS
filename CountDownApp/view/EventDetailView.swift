//
//  EventDetailView.swift
//  CountDownApp
//
//  Created by lucas on 2024/9/17.
//

import SwiftUI

struct EventDetailView: View {
    
    let event: MyEvent
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text(event.title).font(.system(.title2, design: .rounded, weight: .bold))
                
                Label(
                    title: { Text("USA Denver").font(.subheadline) },
                    icon: { Image(systemName: "location.fill") }
                )
                
                HStack {
                    Text(Date().formatted(date: .numeric, time: .shortened)).bold()
                    VStack{ Divider().frame(width: 20) }
                    Text(Date().formatted(date: .numeric, time: .shortened)).bold()
                }
                .font(.subheadline)
                
                ScrollView(.horizontal, content: {
                    HStack {
                        ForEach(1..<10) { item in
                            Image("Branding")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100)
                        }
                    }
                })
                .scrollIndicators(.hidden)
            
                Text(event.remark)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        
        
    }
}

#Preview {
    EventDetailView(event: MyEvent(title: "event example", remark: "Cloud Firestore stores data "))
}
