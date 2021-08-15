//
//  ScrollContainerNode.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 15.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import YogaKit

class ScrollContainerNode: ViewNode<UIScrollView> {
    private var _subnodes: [BindableLayoutNode]
    override var subnodes: [YGLayoutNode] {
        return _subnodes
    }
    
    private var contentOffset: CGPoint = .zero

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
    
    override func configure(view: UIScrollView) {
        super.configure(view: view)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentSize = yoga.intrinsicSize
        view.contentOffset = contentOffset
        view.isScrollEnabled = true
    }

    override func prepareToReuse(view: UIScrollView) {
        super.prepareToReuse(view: view)
        contentOffset = view.contentOffset
    }
}

class HScrollContainer: ScrollContainerNode, YogaHContainerBuilder {
    override func prepareYoga(_ layout: YGLayout) {
        super.prepareYoga(layout)
        layout.flexDirection = .row
    }
}

class VScrollContainer: ScrollContainerNode, YogaVContainerBuilder {
    override func prepareYoga(_ layout: YGLayout) {
        super.prepareYoga(layout)
        layout.flexDirection = .column
    }
}
