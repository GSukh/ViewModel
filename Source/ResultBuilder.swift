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
    public static func buildBlock(_ components: [Value]...) -> [Value] {
        components.flatMap({ $0 })
    }
    
    public static func buildOptional(_ component: [Value]?) -> [Value] {
        component ?? []
    }
    
    public static func buildExpression(_ component: Value) -> [Value] {
      return [component]
    }
    
    public static func buildEither(first: [Value]) -> [Value] {
        first
    }

    public static func buildEither(second: [Value]) -> [Value] {
        second
    }
    
    public static func buildArray(_ components: [[Value]]) -> [Value] {
        return components.flatMap({ $0 })
    }
}
