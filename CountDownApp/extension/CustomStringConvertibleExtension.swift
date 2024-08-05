//
//  CustomStringConvertibleExtension.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/4.
//

import Foundation

extension CustomStringConvertible {
    var description: String {
        var description = description.description
        let selfMirror = Mirror(reflecting: self)
        for child in selfMirror.children {
            if let propertyNmae = child.label {
                description += "\(propertyNmae): \(child.value)\n"
            }
        }
        return description
    }
}
