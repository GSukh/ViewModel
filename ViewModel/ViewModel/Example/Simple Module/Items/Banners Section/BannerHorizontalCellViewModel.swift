//
//  BannerHorizontalCellViewModel.swift
//  ViewModel
//
//  Created by Григорий Сухоруков on 21/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit
import YogaKit

class BannerHorizontalCellViewModel: CellViewModel {
    
    static let size = CGSize(width: 224, height: 96)
    
    init(color: UIColor) {
        super.init()
        
        configureLayout { (layout) in
            layout.width = YGValue(BannerHorizontalCellViewModel.size.width)
            layout.height = YGValue(BannerHorizontalCellViewModel.size.height)
        }
        
        let buttonViewModel = ButtonViewModel({ (config) in
            config.cornerRadius = 8.0
            config.backgroundColor = .white
        }) { (add) in
            let colorViewModel = SimpleViewModel { (config) in
                config.backgroundColor = color
                config.cornerRadius = 8.0
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
