//
//  DaysView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/6.
//

import SwiftUI

struct DaysView: View {
    var body: some View {
        NavigationStack {
            List {
                
                Section {
                    HStack {
                        RoundedRectangle(cornerRadius: 10).fill(.red).frame(width: 80, height: 80)
                        VStack(spacing: 20) {
                            Text("My Life")
                            Text(Date().formatted(date: .numeric, time: .omitted))
                        }
                        Spacer()
                        VStack {
                            Text("100000")
                            Text("days")
                        }
                    }
                }
                
            }
        }
    }
}

#Preview {
    DaysView()
}
