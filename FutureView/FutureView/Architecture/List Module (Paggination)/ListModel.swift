//
//  ListModel.swift
//  ViewModel
//
//  Created by Григорий Сухоруков on 21/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import Foundation

class ListModelContext {
    var offset = 0
    var page = 20
    var count = 0
}

protocol Requestable {
    // HTTP request simulation
    
    func loadItems(_ completion: ([AnyObject]))
}

class ListModel: Model {
    
    
    
}
