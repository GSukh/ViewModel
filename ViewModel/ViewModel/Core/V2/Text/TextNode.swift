//
//  TextNode.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 15.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import UIKit

class TextNode: ViewNode<TextView> {
    
    private let text: String
    private var textRenderer: TextNodeRenderer

    private var numberOfLines: Int = 0
    private var font: UIFont = UIFont.systemFont(ofSize: 15)
    private var lineHeight: CGFloat? = nil
    private var textColor: UIColor = .black
    
    init(_ text: String) {
        self.text = text
        self.textRenderer = TextNodeRenderer(NSAttributedString(string: text))
        super.init()
    }
    
    // MARK: - Setters
    func numberOfLines(_ numberOfLines: Int) -> Self {
        self.numberOfLines = numberOfLines
        return self
    }
    
    func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    func lineHeight(_ lineHeight: CGFloat) -> Self {
        self.lineHeight = lineHeight
        return self
    }
    
    func textColor(_ textColor: UIColor) -> Self {
        self.textColor = textColor
        return self
    }
    
    // MARK: - Private
    private func attributedText() -> NSAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [:]
        attributes[.font] = font
        attributes[.foregroundColor] = textColor
        
        if let lineHeight = lineHeight {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.maximumLineHeight = lineHeight
            paragraphStyle.minimumLineHeight = lineHeight
            attributes[.paragraphStyle] = paragraphStyle
        }
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    private func updateRenderer() {
        textRenderer.attributedText = attributedText()
        textRenderer.numberOfLines = numberOfLines
    }
    
    // MARK: - Overrides
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        updateRenderer()
        return textRenderer.sizeThatFits(size)
    }
    
    override func configure(view: TextView) {
        super.configure(view: view)
        updateRenderer()
        view.textRenderer = textRenderer
        view.backgroundColor = .clear
    }
    
    override func prepareToReuse(view: TextView) {
        super.prepareToReuse(view: view)
        view.textRenderer = nil
    }
}
