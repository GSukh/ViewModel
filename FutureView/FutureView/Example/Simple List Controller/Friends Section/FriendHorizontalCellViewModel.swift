//
//  HorizontalCellExampleView.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 21/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit
import YogaKit

class FriendHorizontalCellViewModel: CellFutureView {
    
    static let size = CGSize(width: 144, height: 96)
    
    init(title: String, color: UIColor) {
        super.init()
        
        configureLayout { (layout) in
            layout.width = YGValue(FriendHorizontalCellViewModel.size.width)
            layout.height = YGValue(FriendHorizontalCellViewModel.size.height)
        }
        
        let buttonViewModel = FutureView<UIButton>(withConfiguration: { (button, initial) in
            button.layer.cornerRadius = initial ? 8.0 : 0.0
            button.backgroundColor = .white
        }) { (add) in
            let avatarContainer = EmptyFutureView()
            avatarContainer.add({
                let avatarSize = CGSize(width: 28, height: 28)
                let avatarViewModel = FutureView<UIView> { (view, initial) in
                    view.backgroundColor = initial ? color : nil
                    view.layer.cornerRadius = initial ? avatarSize.width / 2 : 0
                }
                avatarViewModel.configureLayout { (layout) in
                    layout.marginRight = 8.0
                    layout.marginTop = 8.0
                    layout.width = YGValue(avatarSize.width)
                    layout.height = YGValue(avatarSize.height)
                }
                return avatarViewModel
            }())
            avatarContainer.configureLayout { (layout) in
                layout.flexDirection = .row
                layout.justifyContent = .flexEnd
            }
            add(avatarContainer)
            
            
            let textViewModel = FutureTextView(withConfiguration: {_,_ in})
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 13)]
            textViewModel.attributedText = NSAttributedString(string: title, attributes: attributes)
            textViewModel.numberOfLines = 2
            textViewModel.configureLayout { (layout) in
                layout.marginHorizontal = 8.0
                layout.marginBottom = 8.0
            }
            add(textViewModel)
        }
        buttonViewModel.configureLayout { (layout) in
            layout.height = 100%
            layout.width = 100%
            layout.flexDirection = .column
            layout.justifyContent = .spaceBetween
        }
        add(buttonViewModel)
    }
    
}
