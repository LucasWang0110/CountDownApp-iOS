//
//  LifeInfoView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/11.
//

import SwiftUI

struct LifeInfoView: View {
    var body: some View {
        
        ZStack {
            Color(uiColor: .secondarySystemBackground)
                .ignoresSafeArea()
            VStack {
                VStack(alignment: .center, spacing: 20) {
                    
                    HStack(alignment: .firstTextBaseline) {
                        Text(36500, format: .number.decimalSeparator(strategy: .automatic))
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                        Text("left")
                        Image(systemName: "questionmark.circle.fill").foregroundStyle(.gray)
                    }
                    
                    HStack {
                        Text("Birthday: \(Date().formatted(date: .numeric, time: .omitted))")
                        Spacer()
                        Text("Next: 100 days")
                    }
                }
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Your Life")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    LifeInfoView()
}
