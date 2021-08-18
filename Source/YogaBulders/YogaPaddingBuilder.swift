//
//  YogaPaddingBuilder.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 15.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import YogaKit

public protocol YogaPaddingBuilder: YGLayoutNode {}
public extension YogaPaddingBuilder {
    func padding(_ value: CGFloat) -> Self {
        yoga.padding = YGValue(value)
        return self
    }
}
