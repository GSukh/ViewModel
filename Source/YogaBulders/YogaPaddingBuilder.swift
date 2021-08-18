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
    func padding(_ padding: YGValue) -> Self {
        yoga.padding = padding
        return self
    }
    
    func paddingHorizontal(_ padding: YGValue) -> Self {
        yoga.paddingHorizontal = padding
        return self
    }
    
    func paddingVertical(_ padding: YGValue) -> Self {
        yoga.paddingVertical = padding
        return self
    }
    
    func paddingLeft(_ padding: YGValue) -> Self {
        yoga.paddingLeft = padding
        return self
    }
    
    func paddingTop(_ padding: YGValue) -> Self {
        yoga.paddingTop = padding
        return self
    }
    
    func paddingRight(_ padding: YGValue) -> Self {
        yoga.paddingRight = padding
        return self
    }
    
    func paddingBottom(_ padding: YGValue) -> Self {
        yoga.paddingBottom = padding
        return self
    }
}
