//
//  FutureTextView.swift
//  ViewModel
//
//  Created by Григорий Сухоруков on 24/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class TextViewModel: ViewModel<TextView, ViewConfiguration<TextView>> {
    
    private let text: String
    init(_ text: String) {
        self.text = text
        self.attributedText = NSAttributedString(string: text, attributes: attributes)
        super.init()
        resetRenderer()
    }
    
    private var attributedText: NSAttributedString {
        didSet {
            invalidateLayout()
            resetRenderer()
        }
    }
    private var numberOfLines: Int = 1 {
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
    
    private func resetRenderer() {
        textRenderer = TextRenderer(attributedText)
        textRenderer?.numberOfLines = numberOfLines
    }
    
    private var attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 12)]
    func attributes(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        self.attributes = attributes
        attributedText = NSAttributedString(string: text, attributes: attributes)
        return self
    }
    
    func lines(_ lines: Int) -> Self {
        numberOfLines = lines
        return self
    }
    
}
