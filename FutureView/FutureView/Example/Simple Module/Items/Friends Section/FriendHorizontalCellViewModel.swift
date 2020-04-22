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
        
        configureLayout { (layout) in
            layout.width = YGValue(FriendHorizontalCellViewModel.size.width)
            layout.height = YGValue(FriendHorizontalCellViewModel.size.height)
        }
        
        let buttonViewModel = ButtonViewModel({ (configuration) in
            configuration.cornerRadius = 8.0
            configuration.backgroundColor = .white
            configuration.zoom = true
            configuration.addTarget(self, action: #selector(handlePressed), for: .touchUpInside)
        }) { (add) in
            let avatarContainer = EmptyViewModel()
            avatarContainer.add({
                let avatarSize = CGSize(width: 28, height: 28)
                let avatarViewModel = SimpleViewModel { (config) in
                    config.backgroundColor = color
                    config.cornerRadius = avatarSize.width / 2
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


            let textViewModel = TextViewModel()
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
    
    @objc func handlePressed() {
        print("pressed \(title)")
    }
    
}
