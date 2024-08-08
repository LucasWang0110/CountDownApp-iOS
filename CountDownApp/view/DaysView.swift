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
                        VStack {
                            Text("My Life")
                        }
                        Spacer()
                        Text("100000 days")
                    }
                }
                
            }
        }
    }
}

#Preview {
    DaysView()
}
