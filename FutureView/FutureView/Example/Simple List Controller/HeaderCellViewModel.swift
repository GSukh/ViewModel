//
//  HeaderCellViewModel.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 21/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class HeaderCellViewModel: CellFutureView {
    
    init(title: String, buttonText: String) {
        super.init()
        
        configureLayout { (layout) in
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.alignItems = .center
            layout.height = 44.0
            layout.paddingHorizontal = 12.0
        }
        
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)]
        let titleViewModel = FutureTextView(withConfiguration: {_,_ in})
        titleViewModel.attributedText = NSAttributedString(string: title, attributes: attributes)
        add(titleViewModel)
        
        
        let buttonViewModel = FutureButton { (button, initial) in
            button.setTitle(buttonText, for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.setTitleColor(.cyan, for: .highlighted)
        }
        buttonViewModel.configureLayout { (layout) in
            layout.height = 20.0
            layout.width = 150.0
        }
        add(buttonViewModel)

    }
    
}
