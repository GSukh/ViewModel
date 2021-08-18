//
//  EmptyViewModel.swift
//  ViewModel
//
//  Created by Григорий Сухоруков on 15/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import YogaKit
import YogaUI

typealias ViewModelBuilder = ResultBuilder<EmptyViewModel>

class EmptyViewModel: NSObject {

    private(set) var yoga: YGLayout!
    
    var frame: CGRect = .zero
    fileprivate(set) var bounds: CGRect = .zero
    private var layoutIsValid = false
    
    private(set) var subviews: [EmptyViewModel] = []
    
    override init() {
        super.init()
        yoga = YGLayout(layoutNode: self)
        yoga.isEnabled = true
    }
    
    func add(_ subview: EmptyViewModel) {
        subviews.append(subview)
    }
    
    func add(_ generator: () -> EmptyViewModel) {
        let subview = generator()
        add(subview)
    }
    
    @discardableResult func childs(@ViewModelBuilder _ constructor: () -> [EmptyViewModel]) -> Self {
        let submodels = constructor()
        for submodel in submodels {
            if submodel === self {
                fatalError("Trying to add view as it's subview")
            }
            add(submodel)
        }
        return self
    }
    
     @discardableResult func layout(_ configurator: (YGLayout) -> ()) -> Self {
        configurator(yoga)
        invalidateLayout()
        return self
    }
    
    
    func bind(toContainer container: UIView, origin: CGPoint, viewStorage: ViewStorage?) {
        for subview in subviews {
            subview.bind(toContainer: container, origin: origin, viewStorage: viewStorage)
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
extension EmptyViewModel: YGLayoutNode {
    
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


extension EmptyViewModel {
    func width(_ w: YGValue) -> Self {
        yoga.width = w
        return self
    }
    
    func height(_ h: YGValue) -> Self {
        yoga.height = h
        return self
    }
    
    func size(_ size: CGSize) -> Self {
        yoga.width = YGValue(size.width)
        yoga.height = YGValue(size.height)
        return self
    }
}
