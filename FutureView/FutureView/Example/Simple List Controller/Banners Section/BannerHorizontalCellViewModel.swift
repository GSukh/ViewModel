//
//  BannerHorizontalCellViewModel.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 21/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit
import YogaKit

class BannerHorizontalCellViewModel: CellFutureView {
    
    static let size = CGSize(width: 224, height: 96)
    
    init(color: UIColor) {
        super.init()
        
        configureLayout { (layout) in
            layout.width = YGValue(BannerHorizontalCellViewModel.size.width)
            layout.height = YGValue(BannerHorizontalCellViewModel.size.height)
        }
        
        let buttonViewModel = FutureView<UIButton>(withConfiguration: { (button, initial) in
            button.layer.cornerRadius = initial ? 8.0 : 0.0
            button.backgroundColor = .white
        }) { (add) in
            let colorViewModel = FutureView<UIView> { (view, initial) in
                view.backgroundColor = initial ? color : nil
                view.layer.cornerRadius = initial ? 8.0 : 0
            }
            colorViewModel.configureLayout { (layout) in
                layout.width = 100%
                layout.height = 100%
            }
            add(colorViewModel)
        }
        buttonViewModel.configureLayout { (layout) in
            layout.height = 100%
            layout.width = 100%
        }
        add(buttonViewModel)
    }
    
}
