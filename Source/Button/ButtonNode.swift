//
//  ButtonNode.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 15.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import YogaKit

open class ButtonNode: ViewNode<HighlightableButton>, YogaPaddingBuilder {
    private let targetActionStorage = TargetActionStorage()
    
    private let _subnodes: [LayoutNode]
    public override var subnodes: [YGLayoutNode] {
        return _subnodes
    }
    
    private var onPress: (() -> Void)?
    
    required public init(subnodes: [LayoutNode]) {
        guard !subnodes.isEmpty else {
            fatalError()
        }
        _subnodes = subnodes
        super.init()
        _ = userInteractionEnabled(true)
    }
    
    public convenience init(@LayoutBuilder _ constructor: () -> [LayoutNode]) {
        let subnodes = constructor()
        self.init(subnodes: subnodes)
    }
    
    // MARK: - Overrides
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

    open override func configure(view: HighlightableButton) {
        super.configure(view: view)
        targetActionStorage.apply(toControl: view)
        view.onPress = onPress
    }
    
    open override func prepareToReuse(view: HighlightableButton) {
        super.prepareToReuse(view: view)
        targetActionStorage.prepareToReuse(control: view)
    }
    
    // MARK: - Builders
    open func target(_ target: NSObject?, action: Selector, for controlEvents: UIControl.Event) -> Self {
        targetActionStorage.addTarget(target, action: action, for: controlEvents)
        return self
    }
    
    open func onPress(_ onPress: @escaping () -> Void) -> Self {
        self.onPress = onPress
        return self
    }
}

open class HButtonNode: ButtonNode, YogaHContainerBuilder {
    public override func prepareYoga(_ layout: YGLayout) {
        super.prepareYoga(layout)
        layout.flexDirection = .row
    }
}

open class VButtonNode: ButtonNode, YogaVContainerBuilder {
    public override func prepareYoga(_ layout: YGLayout) {
        super.prepareYoga(layout)
        layout.flexDirection = .column
    }
}
