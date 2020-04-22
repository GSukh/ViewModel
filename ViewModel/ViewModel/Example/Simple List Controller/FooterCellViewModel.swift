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
        
        configureLayout { (layout) in
            layout.height = 20.0
        }
        
        let separatorViewModel = SimpleViewModel()
        separatorViewModel.configuration.backgroundColor = .gray
        separatorViewModel.configureLayout { (layout) in
            layout.position = .absolute
            layout.bottom = 0.0
            layout.left = 16.0
            layout.right = 16.0
            layout.height = 0.5
        }
        add(separatorViewModel)
    }
    
}
