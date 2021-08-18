//
//  V2SampleController.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 12.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import UIKit
import YogaUI

class V2SampleController: UIViewController {
    
    private let viewStorage = ViewStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        HScrollContainer {
            for i in 0..<4 {
                VButtonNode {
                    ViewNode<UIView>()
                        .backgroundColor(.green)
                        .size(width: 100, height: 100)
                    TextNode("\(i)")
                        .lineHeight(20)
                        .marginTop(12)
                }
                .onPress {
                    print("\(i)")
                }
                .marginHorizontal(6)
                .horizontalAlignment(.center)
            }
        }
        .backgroundColor(.yellow)
        .marginTop(124)
        .layout(in: CGSize(width: view.bounds.width, height: .nan))
        .bind(from: viewStorage, to: view)
    }
    
    @objc func didPressButton() {
        print("didPressButton")
    }
}
