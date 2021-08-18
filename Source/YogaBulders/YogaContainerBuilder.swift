//
//  YogaContainerBuilder.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 15.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import YogaKit

public enum ContainerHorizontalAlignment {
    case left
    case center
    case right
}

public enum ContainerVerticalAlignment {
    case top
    case center
    case bottom
}

public protocol YogaContainerBuilder: YGLayoutNode {
    func horizontalAlignment(_ alignment: ContainerHorizontalAlignment) -> Self
    func verticalAlignment(_ position: ContainerVerticalAlignment) -> Self
}


public protocol YogaHContainerBuilder: YogaContainerBuilder {}
public extension YogaHContainerBuilder {
    func horizontalAlignment(_ alignment: ContainerHorizontalAlignment) -> Self {
        yoga.justifyContent = justifyContent(alignment)
        return self
    }
    
    func verticalAlignment(_ alignment: ContainerVerticalAlignment) -> Self {
        yoga.alignItems = alignItems(alignment)
        return self
    }
    
    private func alignItems(_ vAlignment: ContainerVerticalAlignment) -> YGAlign {
        switch vAlignment {
        case .top: return .flexStart
        case .center: return .center
        case .bottom: return .flexEnd
        }
    }
    
    private func justifyContent(_ hAlignment: ContainerHorizontalAlignment) -> YGJustify {
        switch hAlignment {
        case .left: return .flexStart
        case .center: return .center
        case .right: return .flexEnd
        }
    }
}


public protocol YogaVContainerBuilder: YogaContainerBuilder {}
public extension YogaVContainerBuilder {
    func horizontalAlignment(_ alignment: ContainerHorizontalAlignment) -> Self {
        yoga.alignItems = alignItems(alignment)
        return self
    }
    
    func verticalAlignment(_ alignment: ContainerVerticalAlignment) -> Self {
        yoga.justifyContent = justifyContent(alignment)
        return self
    }
    
    private func alignItems(_ hAlignment: ContainerHorizontalAlignment) -> YGAlign {
        switch hAlignment {
        case .left: return .flexStart
        case .center: return .center
        case .right: return .flexEnd
        }
    }
    
    private func justifyContent(_ vAlignment: ContainerVerticalAlignment) -> YGJustify {
        switch vAlignment {
        case .top: return .flexStart
        case .center: return .center
        case .bottom: return .flexEnd
        }
    }
}
