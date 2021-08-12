//
//  ViewModelBuilder.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 11.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import Foundation

@resultBuilder
struct ViewModelBuilder {
    static func buildBlock(_ settings: EmptyViewModel...) -> [EmptyViewModel] {
        settings
    }
    
    static func buildIf(_ value: EmptyViewModel?) -> [EmptyViewModel] {
        value != nil ? [value!] : []
    }
    
    static func buildEither(first: [EmptyViewModel]) -> [EmptyViewModel] {
        first
    }

    static func buildEither(second: [EmptyViewModel]) -> [EmptyViewModel] {
        second
    }
    
    static func buildBlock(_ components: [EmptyViewModel]...) -> [EmptyViewModel] {
        return components.flatMap({ $0 })
    }
    
    static func buildArray(_ components: [[EmptyViewModel]]) -> [EmptyViewModel] {
        return components.flatMap({ $0 })
    }
}
