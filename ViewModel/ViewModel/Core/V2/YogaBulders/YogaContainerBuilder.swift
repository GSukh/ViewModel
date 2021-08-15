//
//  YogaContainerBuilder.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 15.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import YogaKit

enum ContainerItemsHorizontalPosition {
    case left
    case center
    case right
}

enum ContainerItemsVerticalPosition {
    case top
    case center
    case bottom
}

protocol YogaContainerBuilder: YGLayoutNode {
    func itemsHorizontalPosition(_ position: ContainerItemsHorizontalPosition) -> Self
    func itemsVerticalPosition(_ position: ContainerItemsVerticalPosition) -> Self
}


protocol YogaHContainerBuilder: YogaContainerBuilder {}
extension YogaHContainerBuilder {
    func itemsHorizontalPosition(_ position: ContainerItemsHorizontalPosition) -> Self {
        yoga.justifyContent = justifyContent(position)
        return self
    }
    
    func itemsVerticalPosition(_ position: ContainerItemsVerticalPosition) -> Self {
        yoga.alignItems = alignItems(position)
        return self
    }
    
    private func alignItems(_ vPosition: ContainerItemsVerticalPosition) -> YGAlign {
        switch vPosition {
        case .top: return .flexStart
        case .center: return .center
        case .bottom: return .flexEnd
        }
    }
    
    private func justifyContent(_ hPosition: ContainerItemsHorizontalPosition) -> YGJustify {
        switch hPosition {
        case .left: return .flexStart
        case .center: return .center
        case .right: return .flexEnd
        }
    }
}


protocol YogaVContainerBuilder: YogaContainerBuilder {}
extension YogaVContainerBuilder {
    func itemsHorizontalPosition(_ position: ContainerItemsHorizontalPosition) -> Self {
        yoga.alignItems = alignItems(position)
        return self
    }
    
    func itemsVerticalPosition(_ position: ContainerItemsVerticalPosition) -> Self {
        yoga.justifyContent = justifyContent(position)
        return self
    }
    
    private func alignItems(_ hPosition: ContainerItemsHorizontalPosition) -> YGAlign {
        switch hPosition {
        case .left: return .flexStart
        case .center: return .center
        case .right: return .flexEnd
        }
    }
    
    private func justifyContent(_ vPosition: ContainerItemsVerticalPosition) -> YGJustify {
        switch vPosition {
        case .top: return .flexStart
        case .center: return .center
        case .bottom: return .flexEnd
        }
    }
}
