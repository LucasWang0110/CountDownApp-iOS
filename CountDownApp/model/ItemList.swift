//
//  ItemList.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/2.
//

import Foundation
import SwiftData

@Model
class ItemList: Identifiable, NSCopying, Equatable {
    var id: String
    
    var title: String
    var themeColor: String
    var icon: String
    var createTime: Date
    var updateTime: Date
    @Relationship(deleteRule: .cascade) var items: [Item] = []
    
    init(title: String, themeColor: String, icon: String) {
        self.id = UUID().uuidString
        self.title = title
        self.themeColor = themeColor
        self.icon = icon
        self.createTime = Date()
        self.updateTime = Date()
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        var copy = ItemList(title: self.title, themeColor: self.themeColor, icon: self.icon)
        return copy
    }
    
    static func == (lhs: ItemList, rhs: ItemList) -> Bool {
        return lhs.title == rhs.title && lhs.themeColor == rhs.themeColor && lhs.icon == rhs.title
    }
    
    func removeItem(item: Item) {
        for (index, it) in items.enumerated() {
            if it.id == item.id {
                items.remove(at: index)
                return
            }
        }
    }
    
    static var sampleData = ItemList(title: "Title", themeColor: "FF3B30", icon: "folder.fill")
    
    static var sampleList = [
        ItemList(title: "Title 1", themeColor: "264653", icon: "folder.fill"),
        ItemList(title: "Title 2", themeColor: "2A9D8F", icon: "doc.questionmark.fill"),
        ItemList(title: "Title 3", themeColor: "E9C46A", icon: "book.pages.fill")
    ]
}
