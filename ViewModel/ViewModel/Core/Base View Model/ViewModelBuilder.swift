//
//  ViewModelBuilder.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 11.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import Foundation

@resultBuilder
struct ResultBuilder<Value> {
    static func buildBlock(_ settings: Value...) -> [Value] {
        settings
    }
    
    static func buildIf(_ value: Value?) -> [Value] {
        value != nil ? [value!] : []
    }
    
    static func buildEither(first: [Value]) -> [Value] {
        first
    }

    static func buildEither(second: [Value]) -> [Value] {
        second
    }
    
    static func buildBlock(_ components: [Value]...) -> [Value] {
        return components.flatMap({ $0 })
    }
    
    static func buildArray(_ components: [[Value]]) -> [Value] {
        return components.flatMap({ $0 })
    }
}
