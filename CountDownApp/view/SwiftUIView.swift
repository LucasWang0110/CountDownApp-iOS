//
//  SwiftUIView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/15.
//

import MapKit
import SwiftUI
import SwiftData

struct SwiftUIView: View {
    @State private var p = [Parent]()
    var body: some View {
        ForEach(p) { item in
            SubView(item: item)
        }
        Button("Add", action: {
            let parent = Parent(name: "parent", child: Child(name: "child"))
            p.append(parent)
        })
    }
}

struct SubView: View {
    var item: Parent
    var body: some View {
        HStack {
            Text(item.name)
            Text(item.child.name)
        }
    }
}

class Parent: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var child: Child
    init(name: String, child: Child) {
        self.name = name
        self.child = child
    }
}

class Child: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    init(name: String) {
        self.name = name
    }
}

struct TextFieldGrayBackgroundColor: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.primary)
    }
}

#Preview {
    SwiftUIView()
}
