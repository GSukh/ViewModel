//
//  ContainerNode.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 15.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import UIKit
import YogaKit

class ContainerNode: ViewNode<UIView> {
    private var _subnodes: [BindableLayoutNode]
    
    override var subnodes: [YGLayoutNode] {
        return _subnodes
    }
    
    required init(subnodes: [BindableLayoutNode]) {
        guard !subnodes.isEmpty else {
            fatalError()
        }
        _subnodes = subnodes
        super.init()
    }
    
    convenience init(@LayoutBuilder _ constructor: () -> [BindableLayoutNode]) {
        let subnodes = constructor()
        self.init(subnodes: subnodes)
    }
    
    override func bind(to view: UIView, offset: CGPoint) {
        super.bind(to: view, offset: offset)
        
        guard let selfView = self.view else {
            fatalError()
        }
        
        for node in _subnodes {
            node.bind(to: selfView, offset: .zero)
        }
    }
}

class HContainer: ContainerNode, YogaHContainerBuilder {
    override func prepareYoga(_ layout: YGLayout) {
        super.prepareYoga(layout)
        layout.flexDirection = .row
    }
}

class VContainer: ContainerNode, YogaVContainerBuilder {
    override func prepareYoga(_ layout: YGLayout) {
        super.prepareYoga(layout)
        layout.flexDirection = .column
    }
}
