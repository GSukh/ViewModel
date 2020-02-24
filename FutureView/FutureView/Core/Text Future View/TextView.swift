//
//  TextView.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 24/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class TextView: UIView {
    
    var textRenderer: TextRenderer? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        clipsToBounds = true
        layer.contentsGravity = .bottomLeft
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let textRenderer = textRenderer else { return .zero }
        return textRenderer.sizeThatFits(size)
    }
    
    override func draw(_ rect: CGRect) {
        guard let textRenderer = textRenderer else { return }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        textRenderer.draw(inContext: context, withRect: rect)
    }
    
}

