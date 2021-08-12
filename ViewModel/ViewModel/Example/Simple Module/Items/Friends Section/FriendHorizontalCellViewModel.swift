//
//  HorizontalCellExampleView.swift
//  ViewModel
//
//  Created by Григорий Сухоруков on 21/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit
import YogaKit

class FriendHorizontalCellViewModel: CellViewModel {
    
    static let size = CGSize(width: 144, height: 96)
    let title: String
    
    init(title: String, color: UIColor) {
        self.title = title
        super.init()
        
        layout { (layout) in
            layout.width = YGValue(FriendHorizontalCellViewModel.size.width)
            layout.height = YGValue(FriendHorizontalCellViewModel.size.height)
        }
        
        let buttonViewModel = ButtonViewModel({ (configuration) in
            configuration.cornerRadius = 8.0
            configuration.backgroundColor = .white
            configuration.zoom = true
            configuration.addTarget(self, action: #selector(handlePressed), for: .touchUpInside)
        }) {
            EmptyViewModel()
                .childs {
                    SimpleViewModel { (config) in
                        config.backgroundColor = color
                        config.cornerRadius = 14.0
                    }
                    .layout { (layout) in
                        layout.marginRight = 8.0
                        layout.marginTop = 8.0
                        layout.width = 28.0
                        layout.height = 28.0
                    }
                }
                .layout { (layout) in
                    layout.flexDirection = .row
                    layout.justifyContent = .flexEnd
                }

            TextViewModel(title)
                .attributes([.font: UIFont.systemFont(ofSize: 13)])
                .lines(2)
                .layout { layout in
                    layout.marginHorizontal = 8.0
                    layout.marginBottom = 8.0
                }
        }
        buttonViewModel.layout { (layout) in
            layout.height = 100%
            layout.width = 100%
            layout.flexDirection = .column
            layout.justifyContent = .spaceBetween
        }
        
        add(buttonViewModel)
    }
    
    @objc func handlePressed() {
        router?.route(SimpleScreens.friend(title))
    }
    
}
