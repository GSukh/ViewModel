//
//  ViewStorage.swift
//  ViewModel
//
//  Created by Григорий Сухоруков on 15/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

public class ViewStorage {
    
    private var viewsStorage: Dictionary<String, Array<UIView>> = [:]
    
    public init() {}
    
    public func enqueue(view: UIView, withIdentifier identifier: String) {
        var views = viewsStorage[identifier] ?? []
        views.append(view)
//        if views == nil {
//            views = Array<UIView>()
//        }
//
//        views!.append(view)
        viewsStorage[identifier] = views
    }
    
    public func dequeue<View: UIView>(viewWithIdentifier identifier: String) -> View? {
        guard var views = viewsStorage[identifier] else { return nil }
        guard let view = views.first as? View else { return nil }
        views.removeFirst()
        viewsStorage[identifier] = views
        
        return view
    }
    
}
