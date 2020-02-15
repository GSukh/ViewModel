//
//  CellView.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 15/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class CellView: UITableViewCell {
    
    var viewModel: CellFutureView?
    private(set) var viewStorage: ViewStorage?

    func adopt(viewModel: CellFutureView, withStorage viewStorage: ViewStorage) {
        self.viewStorage = viewStorage
        self.viewModel = viewModel
        viewModel.bind(toContainer: self.contentView, withViewStorage: viewStorage)
    }
    
}
