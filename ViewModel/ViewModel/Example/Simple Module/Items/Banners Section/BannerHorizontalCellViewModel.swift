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
        
        layout {
            $0.width = YGValue(BannerHorizontalCellViewModel.size.width)
            $0.height = YGValue(BannerHorizontalCellViewModel.size.height)
        }
        
        childs {
            ButtonViewModel()
                .configure {
                    $0.cornerRadius = 8.0
                    $0.backgroundColor = .white
                }
                .childs {
                    SimpleViewModel {
                        $0.backgroundColor = color
                        $0.cornerRadius = 8.0
                    }
                }
                .width(100%)
                .height(100%)
        }
    }
    
}
