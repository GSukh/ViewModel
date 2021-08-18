//
//  ButtonView.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 22/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

open class HighlightableButton: UIControl {
    
    open var zoomEnabled: Bool = false
    open var onPress: (() -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(didPressOnButton), for: .touchUpInside)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        addTarget(self, action: #selector(didPressOnButton), for: .touchUpInside)
    }
    
    deinit {
        removeTarget(self, action: #selector(didPressOnButton), for: .touchUpInside)
    }
    
    open override var isHighlighted: Bool {
        didSet {
            let highlightChanged = isHighlighted != oldValue
            guard highlightChanged else { return }
            
            if zoomEnabled {
                let transform = isHighlighted ? CGAffineTransform(scaleX: 0.96, y: 0.96) : CGAffineTransform.identity
                guard transform != self.transform else { return }
                UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
                    self.transform = transform
                }, completion: nil)
            } else {
                let alpha: CGFloat = (isHighlighted ? 0.6 : 1.0) * (isEnabled ? 1.0 : 0.5)
                guard alpha != self.alpha else { return }
                UIView.animate(withDuration: 0.2) {
                    self.alpha = alpha
                }
            }
        }
    }
    
    @objc private func didPressOnButton() {
        onPress?()
    }
}
