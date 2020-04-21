//
//  MenuItemCellFutureView.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 21/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class MenuItemCellFutureView: CellFutureView {
    
//    static let height .0= 66
    
    init(title: String, color: UIColor) {
        super.init()
        
        configureLayout { (layout) in
            layout.height = 66.0
            layout.flexDirection = .column
            layout.alignItems = .center
            layout.justifyContent = .flexStart
        }
        
        let avatarViewModel = FutureView<UIView> { (view, initial) in
            view.backgroundColor = initial ? color : nil
        }
        avatarViewModel.configureLayout { (layout) in
            layout.width = 28.0
            layout.height = 28.0
        }
        add(avatarViewModel)
        
        
        let textViewModel = FutureTextView(withConfiguration: {_,_ in})
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 13)]
        textViewModel.attributedText = NSAttributedString(string: title, attributes: attributes)
        textViewModel.numberOfLines = 2
        textViewModel.configureLayout { (layout) in
            layout.marginTop = 6.0
        }
        add(textViewModel)
    }
    
}
