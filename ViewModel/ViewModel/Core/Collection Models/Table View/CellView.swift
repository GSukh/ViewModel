//
//  CellView.swift
//  ViewModel
//
//  Created by Григорий Сухоруков on 15/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit
import YogaUI

class CellView: UITableViewCell {
    
    var viewModel: CellViewModel?
    private(set) var viewStorage: ViewStorage?

    func adopt(viewModel: CellViewModel, withStorage viewStorage: ViewStorage) {
        self.viewStorage = viewStorage
        self.viewModel = viewModel
        viewModel.bind(toContainer: contentView, origin: .zero, viewStorage: viewStorage)
    }
    
}
