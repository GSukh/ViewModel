//
//  FooterCellViewModel.swift
//  ViewModel
//
//  Created by Григорий Сухоруков on 21/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class FooterCellViewModel: CellViewModel {
    
    override init() {
        super.init()
        
        layout { (layout) in
            layout.height = 20.0
        }
        
        childs {
            SimpleViewModel()
            .configure {
                $0.backgroundColor = .gray
            }
            .layout {
                $0.position = .absolute
                $0.bottom = 0.0
                $0.left = 16.0
                $0.right = 16.0
                $0.height = 0.5
            }
        }
    }
    
}
