//
//  TextRenderer.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 24/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import Foundation
import CoreText

class TextRenderer {
    
    let attributedText: NSAttributedString
    private var framesetter: CTFramesetter!

    init(_ attributedText: NSAttributedString) {
        self.attributedText = attributedText
        self.framesetter = CTFramesetterCreateWithAttributedString(attributedText)
    }
    
    func sizeThatFits(_ size: CGSize) -> CGSize {
        return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, size, nil)
    }
    
    func draw(inContext context: CGContext, withRect rect: CGRect) {
        let size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, rect.size, nil)
        let path = CGPath(rect: CGRect(origin: .zero, size: size), transform: nil)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)

        context.clear(rect)
        context.textMatrix = CGAffineTransform.identity
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -size.height)
                
        CTFrameDraw(frame, context)
    }
}
