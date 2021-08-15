//
//  YogaMarginBuilder.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 15.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import YogaKit

protocol YogaMarginBuilder: YGLayoutNode {}
extension YogaMarginBuilder {
    func marginLeft(_ margin: YGValue) -> Self {
        yoga.marginLeft = margin
        return self
    }
    
    func marginTop(_ margin: YGValue) -> Self {
        yoga.marginTop = margin
        return self
    }
    
    func marginRight(_ margin: YGValue) -> Self {
        yoga.marginRight = margin
        return self
    }
    
    func marginBottom(_ margin: YGValue) -> Self {
        yoga.marginBottom = margin
        return self
    }
    
    func margin(_ margin: YGValue) -> Self {
        yoga.margin = margin
        return self
    }
    
    func marginHorizontal(_ margin: YGValue) -> Self {
        yoga.marginHorizontal = margin
        return self
    }
    
    func marginVertical(_ margin: YGValue) -> Self {
        yoga.marginVertical = margin
        return self
    }
}
