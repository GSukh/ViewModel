//
//  YogaPositioningBuilder.swift
//  YogaUI
//
//  Created by Grigoriy Sukhorukov on 19.08.2021.
//

import YogaKit

public protocol YogaPositioningBuilder: YGLayoutNode {}
public extension YogaPositioningBuilder {
    func positionLeft(_ inset: CGFloat) -> Self {
        yoga.position = .absolute
        yoga.left = YGValue(inset)
        return self
    }
    
    func positionRight(_ inset: CGFloat) -> Self {
        yoga.position = .absolute
        yoga.right = YGValue(inset)
        return self
    }
    
    func positionTop(_ inset: CGFloat) -> Self {
        yoga.position = .absolute
        yoga.top = YGValue(inset)
        return self
    }
    
    func positionBottom(_ inset: CGFloat) -> Self {
        yoga.position = .absolute
        yoga.bottom = YGValue(inset)
        return self
    }
}
