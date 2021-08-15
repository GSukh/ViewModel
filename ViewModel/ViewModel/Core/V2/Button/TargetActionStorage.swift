//
//  TargetActionStorage.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 15.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import UIKit

class TargetAction: Hashable {
    
    weak var target: NSObject?
    let action: Selector
    let controlEvents: UIControl.Event
    
    init(_ target: NSObject?, action: Selector, for controlEvents: UIControl.Event) {
        self.target = target
        self.action = action
        self.controlEvents = controlEvents
    }
    
    static func == (lhs: TargetAction, rhs: TargetAction) -> Bool {
        if lhs.target != rhs.target {
            return false
        }
        if lhs.action != rhs.action {
            return false
        }
        if lhs.controlEvents != rhs.controlEvents {
            return false
        }
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(target)
        hasher.combine(action)
        hasher.combine(Int(controlEvents.rawValue))
    }
}

class TargetActionStorage {
    private var targetActions = Set<TargetAction>()
    
    func addTarget(_ target: NSObject?, action: Selector, for controlEvents: UIControl.Event) {
        let targetAction = TargetAction(target, action: action, for: controlEvents)
        targetActions.insert(targetAction)
    }
    
    func removeTarget(_ target: NSObject?, action: Selector, for controlEvents: UIControl.Event) {
        let targetAction = TargetAction(target, action: action, for: controlEvents)
        targetActions.remove(targetAction)
    }
    
    func apply(toControl control: UIControl) {
        targetActions.forEach { (handler) in
            control.addTarget(handler.target, action: handler.action, for: handler.controlEvents)
        }
    }
    
    func prepareToReuse(control: UIControl) {
        targetActions.forEach { (handler) in
            control.removeTarget(handler.target, action: handler.action, for: handler.controlEvents)
        }
    }
}
