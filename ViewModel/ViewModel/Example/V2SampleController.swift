//
//  V2SampleController.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 12.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import UIKit

class V2SampleController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        HContainer {
            for i in 0..<4 {
                ViewNode<UIView>()
                    .backgroundColor(.green)
                    .size(width: 100, height: 100)
                    .marginHorizontal(6)
                TextNode("\(i)")
                    .lineHeight(20)
                    .marginHorizontal(6)
            }
        }
        .marginTop(124)
        .layout(in: CGSize(width: view.bounds.width, height: .nan))
        .bind(to: view)
    }
}
