//
//  MenuItemCellViewModel.swift
//  ViewModel
//
//  Created by Григорий Сухоруков on 21/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class MenuItemCellViewModel: CellViewModel {
    
//    static let height .0= 66
    
    init(title: String, color: UIColor) {
        super.init()
        
        layout { (layout) in
            layout.height = 66.0
            layout.flexDirection = .column
            layout.alignItems = .center
            layout.justifyContent = .flexStart
        }
        
        let avatarViewModel = SimpleViewModel()
        avatarViewModel.configuration.backgroundColor = color
        avatarViewModel.layout { (layout) in
            layout.width = 28.0
            layout.height = 28.0
        }
        add(avatarViewModel)
        
        
        let textViewModel = TextViewModel(title)
            .attributes([.font: UIFont.systemFont(ofSize: 13)])
            .lines(2)
            .layout {
                $0.marginTop = 6.0
            }
        add(textViewModel)
    }
    
}
