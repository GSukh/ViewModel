//
//  CellView.swift
//  ViewModel
//
//  Created by Григорий Сухоруков on 15/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class CellView: UITableViewCell {
    
    var ViewModel: CellViewModel?
    private(set) var viewStorage: ViewStorage?

    func adopt(ViewModel: CellViewModel, withStorage viewStorage: ViewStorage) {
        self.viewStorage = viewStorage
        self.ViewModel = ViewModel
        ViewModel.bind(toContainer: self.contentView, withViewStorage: viewStorage)
    }
    
}
