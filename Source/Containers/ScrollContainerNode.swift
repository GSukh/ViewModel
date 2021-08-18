//
//  ScrollContainerNode.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 15.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import YogaKit

open class ScrollContainerNode: ViewNode<UIScrollView> {
    private var _subnodes: [LayoutNode]
    public override var subnodes: [YGLayoutNode] {
        return _subnodes
    }
    
    private var contentOffset: CGPoint = .zero

    public required init(subnodes: [LayoutNode]) {
        guard !subnodes.isEmpty else {
            fatalError()
        }
        _subnodes = subnodes
        super.init()
    }
    
    public convenience init(@LayoutBuilder _ constructor: () -> [LayoutNode]) {
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
    
    open override func configure(view: UIScrollView) {
        super.configure(view: view)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentSize = yoga.intrinsicSize
        view.contentOffset = contentOffset
        view.isScrollEnabled = true
        view.isUserInteractionEnabled = true
    }

    open override func prepareToReuse(view: UIScrollView) {
        super.prepareToReuse(view: view)
        contentOffset = view.contentOffset
    }
}

open class HScrollContainer: ScrollContainerNode, YogaHContainerBuilder {
    open override func prepareYoga(_ layout: YGLayout) {
        super.prepareYoga(layout)
        layout.flexDirection = .row
    }
}

open class VScrollContainer: ScrollContainerNode, YogaVContainerBuilder {
    open override func prepareYoga(_ layout: YGLayout) {
        super.prepareYoga(layout)
        layout.flexDirection = .column
    }
}
