//
//  ButtonViewModel.swift
//  ViewModel
//
//  Created by Григорий Сухоруков on 22/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

typealias ButtonViewModel = ViewModel<HighlightableButton, ButtonConfiguration>

class ButtonConfiguration: ViewConfiguration<HighlightableButton> {
    
//    var title: String? = nil
    var zoom: Bool = false
    
    private let targetActionStorage = TargetActionStorage()
    
    func addTarget(_ target: NSObject?, action: Selector, for controlEvents: UIControl.Event) {
        targetActionStorage.addTarget(target, action: action, for: controlEvents)
    }
    
    func removeTarget(_ target: NSObject?, action: Selector, for controlEvents: UIControl.Event) {
        targetActionStorage.removeTarget(target, action: action, for: controlEvents)
    }
    
    override func apply(toView view: HighlightableButton) {
        super.apply(toView: view)
//        if let title = title {
//            view.setTitle(title, for: .normal)
//        }
        view.zoomEnabled = zoom
        targetActionStorage.apply(toControl: view)
    }
    
    override func prepareToReuse(view: HighlightableButton) {
        super.prepareToReuse(view: view)
//        view.setTitle(nil, for: .normal)
        view.zoomEnabled = false
        targetActionStorage.prepareToReuse(control: view)
    }
}

