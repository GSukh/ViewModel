//
//  FutureTextView.swift
//  ViewModel
//
//  Created by Григорий Сухоруков on 24/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class TextViewModel: ViewModel<TextView, ViewConfiguration<TextView>> {
    
    var attributedText: NSAttributedString? {
        didSet {
            invalidateLayout()
            if let attributedText = attributedText {
                textRenderer = TextRenderer(attributedText)
                textRenderer?.numberOfLines = numberOfLines
            } else {
                textRenderer = nil
            }
        }
    }
    var numberOfLines: Int = 1 {
        didSet {
            invalidateLayout()
            textRenderer?.numberOfLines = numberOfLines
        }
    }

    private var textRenderer: TextRenderer?
    
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let textRenderer = textRenderer else {
            return super.sizeThatFits(size)
        }
        
        return textRenderer.sizeThatFits(size)
    }
    
    override func configure(view: TextView) {
        super.configure(view: view)
        view.textRenderer = textRenderer
    }
    
    override func prepareForReuse(view: TextView) {
        super.prepareForReuse(view: view)
        view.textRenderer = nil
    }
    
}
