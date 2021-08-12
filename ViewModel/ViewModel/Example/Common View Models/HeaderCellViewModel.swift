//
//  HeaderCellViewModel.swift
//  ViewModel
//
//  Created by Григорий Сухоруков on 21/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class HeaderCellViewModel: CellViewModel {
    
    init(title: String, buttonText: String) {
        super.init()
        
        layout {
            $0.flexDirection = .row
            $0.justifyContent = .spaceBetween
            $0.alignItems = .center
            $0.height = 44.0
            $0.paddingHorizontal = 12.0
        }
        
        childs {
            TextViewModel(title)
                .attributes([.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)])
            
            ButtonViewModel()
                .configure {
                    $0.title = "Показать все"
                }
                .width(150.0)
                .height(20.0)
        }
    }
    
}
