//
//  EmptyFutureView.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 15/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit
import YogaKit


class EmptyFutureView: NSObject {

    private(set) var yoga: YGLayout!
    
    var frame: CGRect = .zero
    fileprivate(set) var bounds: CGRect = .zero
    private var layoutIsValid = false
    
    private(set) var subviews: [EmptyFutureView] = []
    
    
    override init() {
        super.init()
        yoga = YGLayout(layoutNode: self)
        yoga.isEnabled = true
    }
    
    func add(_ subview: EmptyFutureView) {
        subviews.append(subview)
    }
    
    func configureLayout(withBlock block: (YGLayout) -> ()) {
        block(yoga)
        invalidateLayout()
    }
    
    
    func bind(toContainer container: UIView, withViewStorage viewStorage: ViewStorage?) {
        for subview in subviews {
            subview.bind(toContainer: container, withViewStorage: viewStorage)
        }
    }
    
    func unbind(withViewStorage viewStorage: ViewStorage?) {
        for subview in subviews {
            subview.unbind(withViewStorage: viewStorage)
        }
    }
    
    func sizeThatFits(_ size: CGSize) -> CGSize {
        return .zero
    }
    
    func layout(with containerSize: CGSize) {
        self.bounds = CGRect(origin: .zero, size: containerSize)
        yoga.applyLayout(preservingOrigin: false)
        layoutIsValid = false
    }
    
    func layoutIfNeeded(with containerSize: CGSize) {
        if needsLayout() {
            layout(with: containerSize)
        }
    }
    
    func invalidateLayout() {
        layoutIsValid = false
        yoga.markDirty()
    }
    
    func needsLayout() -> Bool {
        guard layoutIsValid else { return true }
        
        for subview in subviews {
            if !subview.layoutIsValid {
                return true
            }
        }
        
        for subview in subviews {
            if subview.needsLayout() {
                return true
            }
        }
        
        return false
    }
    
    func applyLayout() {
        for subview in subviews {
            subview.applyLayout()
        }
    }
    
    func configureViewsTree() {
        for subview in subviews {
            subview.configureViewsTree()
        }
    }
}


// YGLayoutNode:
extension EmptyFutureView: YGLayoutNode {
    
    var isUIView: Bool {
        return false
    }
    
    var subnodes: [YGLayoutNode] {
        return subviews
    }
    
    func safeSetFrame(_ frame: CGRect) {
        self.frame = frame
    }
    
}
