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
    
    fileprivate(set) var frame: CGRect = .zero
    fileprivate(set) var bounds: CGRect = .zero
    private var layoutIsValid = false
    
    private(set) var submodeles: [EmptyFutureView] = []
    
    
    override init() {
        super.init()
        yoga = YGLayout(layoutNode: self)
        yoga.isEnabled = true
    }
    
    func add(_ submodel: EmptyFutureView) {
        submodeles.append(submodel)
    }
    
    func configureLayout(withBlock block: (YGLayout) -> ()) {
        block(yoga)
    }
    
    
    func bind(toContainer container: UIView, withViewStorage viewStorage: ViewStorage?) {
        for submodel in submodeles {
            submodel.bind(toContainer: container, withViewStorage: viewStorage)
        }
    }
    
    func unbind(withViewStorage viewStorage: ViewStorage?) {
        for submodel in submodeles {
            submodel.unbind(withViewStorage: viewStorage)
        }
    }
    
    func sizeThatFits(_ size: CGSize) -> CGSize {
        return .zero
    }
    
    func layout(with containerSize: CGSize) {
        self.bounds = CGRect(origin: .zero, size: containerSize)
        yoga.applyLayout(preservingOrigin: false, dimensionFlexibility: .flexibleHeight)
        layoutIsValid = false
    }
    
    func layoutIfNeeded(with containerSize: CGSize) {
        if needsLayout() {
            layout(with: containerSize)
        }
    }
    
    func invalidateLayout() {
        layoutIsValid = false
    }
    
    func needsLayout() -> Bool {
        guard layoutIsValid else { return true }
        
        for submodel in submodeles {
            if !submodel.layoutIsValid {
                return true
            }
        }
        
        for submodel in submodeles {
            if submodel.needsLayout() {
                return true
            }
        }
        
        return false
    }
    
    func applyLayout() {
        for submodel in submodeles {
            submodel.applyLayout()
        }
    }
}


// YGLayoutNode:
extension EmptyFutureView: YGLayoutNode {
    
    var isUIView: Bool {
        return false
    }
    
    var subnodes: [YGLayoutNode] {
        return submodeles
    }
    
    func safeSetFrame(_ frame: CGRect) {
        self.frame = frame
    }
    
}
