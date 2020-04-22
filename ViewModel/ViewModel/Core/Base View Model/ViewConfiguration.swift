//
//  ViewConfiguration.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 22/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class ViewConfiguration<ViewType: UIView> {
    
    var cornerRadius: CGFloat = 0
    var backgroundColor: UIColor? = nil
    
    required init() {}
    
    func apply(toView view: ViewType) {
        if let backgroundColor = backgroundColor {
            view.backgroundColor = backgroundColor
        }
        view.layer.cornerRadius = cornerRadius
    }
    
    func prepareToReuse(view: ViewType) {
        if backgroundColor != nil {
            view.backgroundColor = nil
        }
        view.layer.cornerRadius = 0.0
    }
}
