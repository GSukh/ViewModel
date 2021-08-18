//
//  TextNodeView.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 15.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import Foundation
import CoreText

public protocol Renderable {
    func sizeThatFits(_ size: CGSize) -> CGSize
    func draw(inContext context: CGContext, withRect rect: CGRect)
}

open class TextNodeRenderer: Renderable {
    
    var attributedText: NSAttributedString {
        didSet {
            framesetter = CTFramesetterCreateWithAttributedString(attributedText)
        }
    }
    var numberOfLines: Int = 0
    private var framesetter: CTFramesetter!

    init(_ attributedText: NSAttributedString) {
        self.attributedText = attributedText
        self.numberOfLines = 0
        self.framesetter = CTFramesetterCreateWithAttributedString(attributedText)
    }
    
    public func sizeThatFits(_ size: CGSize) -> CGSize {
        var totalSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, size, nil)
        if numberOfLines == 0 {
            return totalSize
        }
        
        let path = CGPath(rect: CGRect(origin: .zero, size: totalSize), transform: nil)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)

        let lines = CTFrameGetLines(frame)
        let totalCount = CFArrayGetCount(lines)
        if totalCount <= numberOfLines {
            return totalSize
        }

        let lastLineIndex = numberOfLines - 1

        var lineOrigin = CGPoint.zero
        CTFrameGetLineOrigins(frame, CFRangeMake(lastLineIndex,1), &lineOrigin)
        totalSize.height -= lineOrigin.y
        
        let lastLine = unsafeBitCast(CFArrayGetValueAtIndex(lines, lastLineIndex), to: CTLine.self)
        let lineBounds = CTLineGetBoundsWithOptions(lastLine, [])
        totalSize.height -= lineBounds.minY

        return totalSize
    }
    
    public func draw(inContext context: CGContext, withRect rect: CGRect) {
        let size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, rect.size, nil)
        let path = CGPath(rect: CGRect(origin: .zero, size: size), transform: nil)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)

        context.clear(rect)
        context.textMatrix = CGAffineTransform.identity
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -size.height)
        
        let lines = CTFrameGetLines(frame)
        let totalCount = CFArrayGetCount(lines)
        let countToDrow = numberOfLines == 0 ? totalCount : min(totalCount, numberOfLines)
        
        for i in 0..<countToDrow {
            let line = unsafeBitCast(CFArrayGetValueAtIndex(lines, i), to: CTLine.self)
            var lineOrigin = CGPoint.zero
            CTFrameGetLineOrigins(frame, CFRangeMake(i,1), &lineOrigin)
            context.textPosition = CGPoint(x: lineOrigin.x, y: lineOrigin.y)
            CTLineDraw(line, context)
        }
    }
}
