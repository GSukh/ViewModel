//
//  SmallCellFutureView.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 15/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class SmallCellFutureView: CellFutureView {
    
    private var avatarViewModel: FutureView<UIView>!
    
    override init () {
        super.init()
        
        avatarViewModel = FutureView<UIView> {
            $0.backgroundColor = $1 ? .green : nil
            $0.layer.cornerRadius = $1 ? 32 : 0
        }
        avatarViewModel.configureLayout {
            $0.width = 64
            $0.height = 64
        }
        add(avatarViewModel)

        let rightContainer = FutureView<UIView>(withConfiguration: {
            $0.backgroundColor = $1 ? .gray : nil
        }, constructor: { (add) in
            let nameViewModel = TextViewModel {
                $0.backgroundColor = $1 ? .yellow : nil
                $0.text = $1 ? "Some name" : nil
            }
            nameViewModel.configureLayout {
                $0.height = 30
                $0.marginTop = 10
                $0.flexShrink = 1
            }
            add(nameViewModel)

            let buttonViewModel = FutureView<UIButton> {
                $0.backgroundColor = $1 ? .orange : nil
                if $1 {
                    $0.addTarget(self, action: #selector(self.actionHandler), for: .touchUpInside)
                } else {
                    $0.removeTarget(self, action: #selector(self.actionHandler), for: .touchUpInside)
                }
            }
            buttonViewModel.configureLayout {
                $0.height = 60
                $0.width = 150
                $0.marginTop = 4
                $0.flexShrink = 1
            }
            add(buttonViewModel)
        })
        rightContainer.configureLayout {
            $0.flexDirection = .column
            $0.marginHorizontal = 10
            $0.marginVertical = 4
            $0.flexGrow = 1
        }
        add(rightContainer)

        configureLayout(withBlock: {
            $0.flexDirection = .row
            $0.padding = 2
            $0.flexGrow = 1
        })
    }
    
    @objc
    func actionHandler() {
        avatarViewModel.viewConfigurator.add {
            $0.backgroundColor = $1 ? .red : nil
        }
        avatarViewModel.configureView()
        
        configureLayout {
            $0.padding = 12
        }
        invalidateLayout()
        if let reloadCellHandler = reloadCellHandler {
            reloadCellHandler(self)
        }
    }
}
