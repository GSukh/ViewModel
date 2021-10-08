//
//  TextView.swift
//  ViewModel
//
//  Created by Григорий Сухоруков on 24/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

open class TextView: UIView {
    
    open var textRenderer: Renderable? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        clipsToBounds = true
        layer.contentsGravity = .bottomLeft
        accessibilityTraits = .staticText
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let textRenderer = textRenderer else { return .zero }
        return textRenderer.sizeThatFits(size)
    }
    
    open override func draw(_ rect: CGRect) {
        guard let textRenderer = textRenderer else { return }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        textRenderer.draw(inContext: context, withRect: rect)
    }
    
}

