//
//  ContainerNode.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 12.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import Foundation
import YogaKit

typealias BindableLayoutNode = LayoutNode & BindableNode
typealias LayoutBuilder = ResultBuilder<BindableLayoutNode>

class ContainerNode: LayoutNode, BindableNode, LayoutPaddings, LayoutMargin {
    private var _subnodes: [BindableLayoutNode]
    
    override var subnodes: [YGLayoutNode] {
        return _subnodes
    }
    
    required init(subnodes: [BindableLayoutNode]) {
        _subnodes = subnodes
        super.init()
    }
    
    convenience init(@LayoutBuilder _ constructor: () -> [BindableLayoutNode]) {
        let subnodes = constructor()
        self.init(subnodes: subnodes)
    }
    
    func bind(to view: UIView, offset: CGPoint) {
        print(frame)
        for node in _subnodes {
            node.bind(to: view, offset: frame.origin)
        }
    }
}

class HContainer: ContainerNode {
    override func prepareYoga(_ layout: YGLayout) {
        super.prepareYoga(layout)
        layout.flexDirection = .row
    }
}

class VContainer: ContainerNode {
    override func prepareYoga(_ layout: YGLayout) {
        super.prepareYoga(layout)
        layout.flexDirection = .column
    }
}


// paddings
protocol LayoutPaddings: YGLayoutNode {}
extension LayoutPaddings {
    func padding(_ value: CGFloat) -> Self {
        yoga.padding = YGValue(value)
        return self
    }
}


protocol LayoutSize: YGLayoutNode {}
extension LayoutSize {
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


protocol LayoutMargin: YGLayoutNode {}
extension LayoutMargin {
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
