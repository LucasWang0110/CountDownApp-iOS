//
//  ListRow.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/2.
//

import SwiftUI

struct ListRow: View {
    
    var itemList: ItemList
    
    var body: some View {
        HStack(alignment: .center) {
            CircleSymbol(bgColor: Color(hex: itemList.themeColor)!, symbolNmae: itemList.icon)
            VStack(alignment: .leading) {
                Text(itemList.title)
                    .font(.title3)
                if !itemList.items.isEmpty {
                    HStack(spacing: 10) {
                        Text("\(itemList.items.filter({ $0.isInprogress() }).count) Ongoing")
                        Text("\(itemList.items.filter({ $0.isOverTime() }).count) Overtime")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                }
            }
            Spacer()
            if itemList.items.count != 0 {
                Text("\(itemList.items.count)").foregroundStyle(.gray).font(.subheadline)
            }
            Image(systemName: "chevron.right").foregroundStyle(.gray)
        }
    }
}

#Preview {
    ListRow(itemList: ItemList.sampleData)
}
