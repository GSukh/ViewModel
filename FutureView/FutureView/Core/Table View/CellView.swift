//
//  CellView.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 15/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class CellView: UITableViewCell {
    
    var futureView: CellFutureView?
    private(set) var viewStorage: ViewStorage?

    func adopt(futureView: CellFutureView, withStorage viewStorage: ViewStorage) {
        self.viewStorage = viewStorage
        self.futureView = futureView
        futureView.bind(toContainer: self.contentView, withViewStorage: viewStorage)
    }
    
}
