//
//  V2.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 12.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import UIKit
import YogaKit

class LayoutNode: NSObject, YGLayoutNode {
    
    private(set) var yoga: YGLayout!
    
    override init() {
        super.init()
        yoga = YGLayout(layoutNode: self)
        prepareYoga(yoga)
    }
    
    func prepareYoga(_ layout: YGLayout) {
        layout.isEnabled = true
    }
    
    // MARK: - Layout
    private(set) var frame: CGRect = .zero
    private(set) var bounds: CGRect = .zero
    
    var subnodes: [YGLayoutNode] {
        return []
    }
    
    var isUIView: Bool {
        return false
    }
    
    func sizeThatFits(_ size: CGSize) -> CGSize {
        return .zero
    }
    
    func safeSetFrame(_ frame: CGRect) {
        self.frame = frame
    }
    
    @discardableResult func layout(in containerSize: CGSize) -> Self {
        self.bounds = CGRect(origin: .zero, size: containerSize)
        yoga.applyLayout(preservingOrigin: false)
        return self
    }
    
}
