//
//  ViewStorage.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 15/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class ViewStorage {
    
    private var viewsStorage: Dictionary<String, Array<UIView>> = [:]
    
    func enqueue(view: UIView, withIdentifier identifier: String) {
        var views = self.viewsStorage[identifier]
        if views == nil {
            views = Array<UIView>()
        }
        
        views!.append(view)
        self.viewsStorage[identifier] = views
    }
    
    func dequeue(viewWithIdentifier identifier: String) -> UIView? {
        guard var views = self.viewsStorage[identifier] else { return nil }
        guard let view = views.first else { return nil }
        views.removeFirst()
        self.viewsStorage[identifier] = views
        
        return view
    }
    
}
