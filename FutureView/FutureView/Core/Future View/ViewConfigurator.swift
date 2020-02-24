//
//  ViewConfigurator.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 15/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class ViewConfigurator<ViewType: UIView> {
    
    typealias ViewConfiguration = (ViewType, Bool) -> ()
    private var configurationStack: [ViewConfiguration] = []
    
    typealias ViewCleanup = (ViewType) -> ()
    private var cleanupStack: [ViewCleanup] = []
    
    func add(_ configuration: @escaping ViewConfiguration) {
        configurationStack.append(configuration)
    }
    
    func reset() {
        configurationStack.removeAll()
    }
    
    func configure(view: ViewType) {
        cleanupStack.forEach {
            $0(view)
        }
        cleanupStack.removeAll()
        configurationStack.forEach { (viewConfiguration) in
            viewConfiguration(view, true)
            cleanupStack.append({ viewConfiguration($0, false) })
        }
    }
    
    func prepareForReuse(view: ViewType) {
        cleanupStack.forEach {
            $0(view)
        }
        cleanupStack.removeAll()    }
}
