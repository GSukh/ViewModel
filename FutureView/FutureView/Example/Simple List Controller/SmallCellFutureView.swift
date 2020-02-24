//
//  SmallCellFutureView.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 15/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class SmallCellFutureView: CellFutureView {
    
    private var avatarFutureView: FutureView<UIView>!
    private var nameFutureView: FutureTextView!
    private var buttonFutureView: FutureView<UIButton>!
    private var buttonTitleFutureView: FutureTextView!

    private var compactMode = true

    override init () {
        super.init()
        
        avatarFutureView = FutureView<UIView> {
            $0.backgroundColor = $1 ? .green : nil
            $0.layer.cornerRadius = $1 ? 32 : 0
        }
        avatarFutureView.configureLayout {
            $0.width = 64
            $0.height = 64
        }
        add(avatarFutureView)

        let rightContainer = FutureView<UIView>(withConfiguration: {
            $0.backgroundColor = $1 ? .gray : nil
        }, constructor: { (add) in
            nameFutureView = FutureTextView(withConfiguration: {_,_ in })
            nameFutureView.attributedText = SmallCellFutureView.attributedTitle(compactMode)
            nameFutureView.configureLayout {
                $0.marginTop = 10
                $0.flexShrink = 1
            }
            add(nameFutureView)

            buttonFutureView = FutureButton(withConfiguration: {
                $0.backgroundColor = $1 ? .orange : nil
                 if $1 {
                     $0.addTarget(self, action: #selector(self.actionHandler), for: .touchUpInside)
                 } else {
                     $0.removeTarget(self, action: #selector(self.actionHandler), for: .touchUpInside)
                 }
            }) { (add) in
                buttonTitleFutureView = FutureTextView(withConfiguration: {_,_ in})
                buttonTitleFutureView.attributedText = SmallCellFutureView.attributedButtonTitle(compactMode)
                buttonTitleFutureView.configureLayout {
                    $0.margin = 16.0
                }
                add(buttonTitleFutureView)
            }
            buttonFutureView.configureLayout {
                $0.marginTop = 4
                $0.flexShrink = 1
            }
            add(buttonFutureView)
        })
        rightContainer.configureLayout {
            $0.flexDirection = .column
            $0.marginHorizontal = 10
            $0.marginVertical = 4
        }
        add(rightContainer)

        configureLayout(withBlock: {
            $0.flexDirection = .row
            $0.padding = 2
//            $0.flexGrow = 1
        })
    }
    
    private static func attributedTitle(_ compactMode: Bool) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 12),
                                                         .foregroundColor: UIColor.red,
                                                         .backgroundColor: UIColor.yellow,
                                                        ]
        if compactMode {
            return NSAttributedString(string: "Some name", attributes: attributes)
        } else {
            return NSAttributedString(string: "Some name Some name Some name Some name Some name Some name Some name Some name", attributes: attributes)
        }
    }
    
    private static func attributedButtonTitle(_ compactMode: Bool) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 15)]
        if compactMode {
            return NSAttributedString(string: "Reveal", attributes: attributes)
        } else {
            return NSAttributedString(string: "Hide", attributes: attributes)
        }
    }
    
    @objc
    func actionHandler() {
        compactMode = !compactMode
        nameFutureView.attributedText = SmallCellFutureView.attributedTitle(compactMode)
        nameFutureView.invalidateLayout()
        
        buttonTitleFutureView.attributedText = SmallCellFutureView.attributedButtonTitle(compactMode)
        buttonTitleFutureView.invalidateLayout()
        
        avatarFutureView.viewConfigurator.add {
            $0.backgroundColor = $1 ? .red : nil
        }
        avatarFutureView.configureView()
        
        if let reloadCellHandler = reloadCellHandler {
            reloadCellHandler(self)
        }
    }
    
    override func safeSetFrame(_ frame: CGRect) {
        super.safeSetFrame(frame)
        if frame.height.isNaN {
            print(frame)
        }
    }
}
