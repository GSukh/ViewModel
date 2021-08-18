//
//  ContainerNode.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 12.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import YogaKit

// Container without view
// You can use it only to layout subviews

typealias LayoutBuilder = ResultBuilder<LayoutNode>

open class LayoutContainerNode: LayoutNode, YogaPaddingBuilder, YogaMarginBuilder {
    
    private var _subnodes: [LayoutNode]
    public override var subnodes: [YGLayoutNode] {
        return _subnodes
    }
    
    required public init(subnodes: [LayoutNode]) {
        guard !subnodes.isEmpty else {
            fatalError()
        }
        
        _subnodes = subnodes
        super.init()
    }
    
    convenience init(@LayoutBuilder _ constructor: () -> [LayoutNode]) {
        let subnodes = constructor()
        self.init(subnodes: subnodes)
    }
    
    open override func bind(from viewStorage: ViewStorage, to view: UIView, offset: CGPoint) {
        super.bind(from: viewStorage, to: view, offset: offset)
        
        for node in _subnodes {
            node.bind(from: viewStorage, to: view, offset: frame.origin)
        }
    }
    
    open override func unbind(to viewStorage: ViewStorage) {
        super.unbind(to: viewStorage)
        
        for node in _subnodes {
            node.unbind(to: viewStorage)
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