//
//  TextNode.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 15.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import UIKit

open class TextNode: ViewNode<TextView> {
    
    private let text: String
    private var textRenderer: TextNodeRenderer

    private var numberOfLines: Int = 0
    private var font: UIFont = UIFont.systemFont(ofSize: 15)
    private var lineHeight: CGFloat? = nil
    private var textColor: UIColor = .black
    private var isHTML: Bool = false
    
    public init(_ text: String) {
        self.text = text
        self.textRenderer = TextNodeRenderer(NSAttributedString(string: text))
        super.init()
    }
    
    // MARK: - Setters
    open func numberOfLines(_ numberOfLines: Int) -> Self {
        self.numberOfLines = numberOfLines
        return self
    }
    
    open func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    open func systemFont(ofSize size: CGFloat, weight: UIFont.Weight) -> Self {
        self.font = UIFont.systemFont(ofSize: size, weight: weight)
        return self
    }
    
    open func lineHeight(_ lineHeight: CGFloat) -> Self {
        self.lineHeight = lineHeight
        return self
    }
    
    open func textColor(_ textColor: UIColor) -> Self {
        self.textColor = textColor
        return self
    }
    
    open func markHTML() -> Self {
        self.isHTML = true
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
    
    private func attributedHTMLText() -> NSAttributedString {
        let height = lineHeight ?? font.lineHeight
        let attributedHTMLString = text.htmlAttributedString(size: font.pointSize, color: textColor, lineHeight: height)
        return attributedHTMLString ?? attributedText()
    }
    
    private func updateRenderer() {
        if isHTML {
            textRenderer.attributedText = attributedHTMLText()
        } else {
            textRenderer.attributedText = attributedText()
        }
        textRenderer.numberOfLines = numberOfLines
    }
    
    // MARK: - Overrides
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        updateRenderer()
        let size = textRenderer.sizeThatFits(size)
        return size
    }
    
    open override func configure(view: TextView) {
        super.configure(view: view)
        updateRenderer()
        view.textRenderer = textRenderer
        view.backgroundColor = .clear
        view.accessibilityLabel = text
        view.isAccessibilityElement = true
    }
    
    open override func prepareToReuse(view: TextView) {
        super.prepareToReuse(view: view)
        view.textRenderer = nil
        view.accessibilityLabel = nil
    }
}
