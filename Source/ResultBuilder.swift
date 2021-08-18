//
//  ViewModelBuilder.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 11.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import Foundation

@resultBuilder
public struct ResultBuilder<Value> {
    public static func buildBlock(_ settings: Value...) -> [Value] {
        settings
    }
    
    public static func buildIf(_ value: Value?) -> [Value] {
        value != nil ? [value!] : []
    }
    
    public static func buildEither(first: [Value]) -> [Value] {
        first
    }

    public static func buildEither(second: [Value]) -> [Value] {
        second
    }
    
    public static func buildBlock(_ components: [Value]...) -> [Value] {
        return components.flatMap({ $0 })
    }
    
    public static func buildArray(_ components: [[Value]]) -> [Value] {
        return components.flatMap({ $0 })
    }
}
