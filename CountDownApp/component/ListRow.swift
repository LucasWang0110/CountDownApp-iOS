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
                Text("3 progressing")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    ListRow(itemList: ItemList.sampleData)
}
