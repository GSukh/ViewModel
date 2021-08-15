//
//  ButtonNode.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 15.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import YogaKit

class ButtonNode: ViewNode<HighlightableButton> {
    private let targetActionStorage = TargetActionStorage()
    
    private let _subnodes: [BindableLayoutNode]
    override var subnodes: [YGLayoutNode] {
        return _subnodes
    }
    
    typealias OnPressHandler = () -> Void
    private var onPress: OnPressHandler?
    
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
    
    // MARK: - Overrides
    override func bind(to view: UIView, offset: CGPoint) {
        super.bind(to: view, offset: offset)
        
        guard let selfView = self.view else {
            fatalError()
        }
        
        for node in _subnodes {
            node.bind(to: selfView, offset: .zero)
        }
    }

    override func configure(view: HighlightableButton) {
        super.configure(view: view)
        targetActionStorage.apply(toControl: view)
        view.isUserInteractionEnabled = true
        view.onPress = onPress
    }
    
    override func prepareToReuse(view: HighlightableButton) {
        super.prepareToReuse(view: view)
        targetActionStorage.prepareToReuse(control: view)
    }
    
    // MARK: - Builders
    func target(_ target: NSObject?, action: Selector, for controlEvents: UIControl.Event) -> Self {
        targetActionStorage.addTarget(target, action: action, for: controlEvents)
        return self
    }
    
    func onPress(_ onPress: @escaping OnPressHandler) -> Self {
        self.onPress = onPress
        return self
    }
}

class HButtonNode: ButtonNode, YogaHContainerBuilder {
    override func prepareYoga(_ layout: YGLayout) {
        super.prepareYoga(layout)
        layout.flexDirection = .row
    }
}

class VButtonNode: ButtonNode, YogaVContainerBuilder {
    override func prepareYoga(_ layout: YGLayout) {
        super.prepareYoga(layout)
        layout.flexDirection = .column
    }
}
