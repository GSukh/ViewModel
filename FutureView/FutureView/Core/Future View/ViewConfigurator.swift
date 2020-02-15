//
//  ViewConfigurator.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 15/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class ViewConfigurator<ViewType: UIView> {
    
    // TODO:
    // separate stack on setup and cleanup stacks
    // mark which configurations have already performed
    
    typealias ViewConfiguration = (ViewType, Bool) -> ()
    private var configurationStack: [ViewConfiguration] = []
    
    func add(_ configuration: @escaping ViewConfiguration) {
        configurationStack.append(configuration)
    }
    
    func reset() {
        configurationStack.removeAll()
    }
    
    func configure(view: ViewType) {
        configurationStack.forEach { $0(view, true) }
    }
    
    func prepareForReuse(view: ViewType) {
        configurationStack.reversed().forEach { $0(view, false) }
    }
}
