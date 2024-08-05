//
//  DoneItemView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/5.
//

import SwiftUI

struct DoneItemView: View {
    
    var item: Item
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.title2)
                Text(item.remark)
                    .font(.subheadline)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundStyle(.gray)
            }
            Spacer()
            Image(systemName: "checkmark.circle")
                .foregroundStyle(.green)
                .font(.title2)
        }
    }
}

#Preview {
    DoneItemView(item: Item.sampleDoneData)
}
