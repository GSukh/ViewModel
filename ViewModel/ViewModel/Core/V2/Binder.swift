//
//  Binder.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 12.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import UIKit

protocol BindableNode {
    func bind(to view: UIView, offset: CGPoint)
}

extension BindableNode {
    func bind(to view: UIView) {
        bind(to: view, offset: .zero)
    }
}

