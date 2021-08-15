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

class LayoutContainerNode: LayoutNode, BindableNode, YogaPaddingBuilder, YogaMarginBuilder {
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
        for node in _subnodes {
            node.bind(to: view, offset: frame.origin)
        }
    }
}

class HLayoutContainer: LayoutContainerNode, YogaHContainerBuilder {
    override func prepareYoga(_ layout: YGLayout) {
        super.prepareYoga(layout)
        layout.flexDirection = .row
    }
}

class VLayoutContainer: LayoutContainerNode, YogaVContainerBuilder {
    override func prepareYoga(_ layout: YGLayout) {
        super.prepareYoga(layout)
        layout.flexDirection = .column
    }
}
