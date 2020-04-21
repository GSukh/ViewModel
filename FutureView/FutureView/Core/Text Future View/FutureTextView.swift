//
//  FutureTextView.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 24/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class FutureTextView: FutureView<TextView> {
    
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
    
    override func configureView() {
        super.configureView()
        view?.textRenderer = textRenderer
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        view?.textRenderer = nil
    }
    
//    override func safeSetFrame(_ frame: CGRect) {
//        super.safeSetFrame(frame)
//        print(frame)
//    }
}
