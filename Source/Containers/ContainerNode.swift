//
//  ContainerNode.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 15.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import YogaKit

open class ContainerNode: ViewNode<UIView>, YogaPaddingBuilder {
    
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
    
    convenience public init(@LayoutBuilder _ constructor: () -> [LayoutNode]) {
        let subnodes = constructor()
        self.init(subnodes: subnodes)
    }
    
    open override func bind(from viewStorage: ViewStorage, to view: UIView, offset: CGPoint) {
        super.bind(from: viewStorage, to: view, offset: offset)
        
        guard let selfView = self.view else {
            fatalError()
        }
        
        for node in _subnodes {
            node.bind(from: viewStorage, to: selfView, offset: .zero)
        }
    }
    
    open override func unbind(to viewStorage: ViewStorage) {
        super.unbind(to: viewStorage)
        
        for node in _subnodes {
            node.unbind(to: viewStorage)
        }
    }
}

open class HContainer: ContainerNode, YogaHContainerBuilder {
    public override func prepareYoga(_ layout: YGLayout) {
        super.prepareYoga(layout)
        layout.flexDirection = .row
    }
}

open class VContainer: ContainerNode, YogaVContainerBuilder {
    public override func prepareYoga(_ layout: YGLayout) {
        super.prepareYoga(layout)
        layout.flexDirection = .column
    }
}
