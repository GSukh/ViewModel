//
//  YogaSizeBuilder.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 15.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import YogaKit

protocol YogaSizeBuilder: YGLayoutNode {}
extension YogaSizeBuilder {
    func width(_ w: YGValue) -> Self {
        yoga.width = w
        return self
    }
    
    func height(_ h: YGValue) -> Self {
        yoga.height = h
        return self
    }
    
    func size(_ size: CGSize) -> Self {
        yoga.width = YGValue(size.width)
        yoga.height = YGValue(size.height)
        return self
    }

    func size(width: YGValue, height: YGValue) -> Self {
        yoga.width = width
        yoga.height = height
        return self
    }
}
