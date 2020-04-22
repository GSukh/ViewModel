//
//  ButtonViewModel.swift
//  ViewModel
//
//  Created by Григорий Сухоруков on 22/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

typealias ButtonViewModel = ViewModel<HighlightableButton, ButtonConfiguration>

class TargetActionHandler: Equatable {
    
    let target: NSObject?
    let action: Selector
    let controlEvents: UIControl.Event
    
    init(_ target: NSObject?, action: Selector, for controlEvents: UIControl.Event) {
        self.target = target
        self.action = action
        self.controlEvents = controlEvents
    }
    
    static func == (lhs: TargetActionHandler, rhs: TargetActionHandler) -> Bool {
        if lhs.target != rhs.target {
            return false
        }
        if lhs.action != rhs.action {
            return false
        }
        return true
    }
}

class TargetActionStorage {
    // могут быть ошибки если много раз добавлять и удалять действия
    private var actionHandlers: [TargetActionHandler] = []
    
    func addTarget(_ target: NSObject?, action: Selector, for controlEvents: UIControl.Event) {
        let handler = TargetActionHandler(target, action: action, for: controlEvents)
        actionHandlers.append(handler)
    }
    
    func removeTarget(_ target: NSObject?, action: Selector?, for controlEvents: UIControl.Event) {
        if let action = action {
            actionHandlers.removeAll { $0.target == target && $0.action == action && $0.controlEvents.rawValue == controlEvents.rawValue }
        } else {
            actionHandlers.removeAll { $0.action == action && $0.controlEvents.rawValue == controlEvents.rawValue }
        }
    }
    
    func apply(toControl control: UIControl) {
        actionHandlers.forEach { (handler) in
            control.addTarget(handler.target, action: handler.action, for: handler.controlEvents)
        }
    }
    
    func prepareToReuse(control: UIControl) {
        actionHandlers.forEach { (handler) in
            control.removeTarget(handler.target, action: handler.action, for: handler.controlEvents)
        }
    }
}

class ButtonConfiguration: ViewConfiguration<HighlightableButton> {
    
    var title: String? = nil
    var zoom: Bool = false
    
    private var targetActionStorage = TargetActionStorage()
    
    func addTarget(_ target: NSObject?, action: Selector, for controlEvents: UIControl.Event) {
        targetActionStorage.addTarget(target, action: action, for: controlEvents)
    }
    
    func removeTarget(_ target: NSObject?, action: Selector?, for controlEvents: UIControl.Event) {
        targetActionStorage.removeTarget(target, action: action, for: controlEvents)
    }
    
    override func apply(toView view: HighlightableButton) {
        super.apply(toView: view)
        if let title = title {
            view.setTitle(title, for: .normal)
        }
        view.zoomEnabled = zoom
        targetActionStorage.apply(toControl: view)
    }
    
    override func prepareToReuse(view: HighlightableButton) {
        super.prepareToReuse(view: view)
        view.setTitle(nil, for: .normal)
        view.zoomEnabled = false
        targetActionStorage.prepareToReuse(control: view)
    }
}

