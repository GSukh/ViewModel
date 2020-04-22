//
//  ButtonView.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 22/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class HighlightableButton: UIButton {
    
    var zoomEnabled: Bool = false
    
    override var isHighlighted: Bool {
        didSet {
            let highlightChanged = isHighlighted != oldValue
            guard highlightChanged else { return }
            
            if zoomEnabled {
                let transform = isHighlighted ? CGAffineTransform(scaleX: 0.96, y: 0.96) : CGAffineTransform.identity
                guard transform != self.transform else { return }
                UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
                    self.transform = transform;
                }, completion: nil)
            }
        }
    }
    
}
