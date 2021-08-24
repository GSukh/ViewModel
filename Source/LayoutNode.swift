//
//  V2.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 12.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import YogaKit

open class LayoutNode: NSObject, YGLayoutNode, YogaPositioningBuilder {
    private var _yoga: YGLayout!
    public var yoga: YGLayout! {
        return _yoga
    }
    
    private weak var _superview: UIView?
    public var superView: UIView? {
        return _superview
    }
    
    public override init() {
        super.init()
        _yoga = YGLayout(layoutNode: self)
        prepareYoga(yoga)
    }
    
    public func prepareYoga(_ layout: YGLayout) {
        layout.isEnabled = true
    }
    
    // MARK: - Layout
    private var _frame: CGRect = .zero
    public var frame: CGRect {
        return _frame
    }
    
    private var _bounds: CGRect = .zero
    public var bounds: CGRect {
        return _bounds
    }
    
    public var subnodes: [YGLayoutNode] {
        return []
    }
    
    public var isUIView: Bool {
        return false
    }
    
    public func sizeThatFits(_ size: CGSize) -> CGSize {
        return .zero
    }
    
    public func safeSetFrame(_ frame: CGRect) {
        _frame = frame
    }
    
    @discardableResult public func layout(in containerSize: CGSize) -> Self {
        _bounds = CGRect(origin: .zero, size: containerSize)
        yoga.applyLayout(preservingOrigin: false)
        return self
    }
    
    // MARK: - BindableNode
    open func bind(from viewStorage: ViewStorage, to view: UIView, offset: CGPoint) {
        _superview = view
    }

    open func unbind(to viewStorage: ViewStorage) {
        _superview = nil
    }
}

public extension LayoutNode {
    func bind(from viewStorage: ViewStorage, to view: UIView) {
        bind(from: viewStorage, to: view, offset: .zero)
    }
}

public extension LayoutNode {
    func shrink() -> Self {
        yoga.flexShrink = 1.0
        return self
    }
    
    func grow() -> Self {
        yoga.flexGrow = 1.0
        return self
    }
}
