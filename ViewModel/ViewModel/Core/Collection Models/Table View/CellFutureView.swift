//
//  CellViewModel.swift
//  ViewModel
//
//  Created by Григорий Сухоруков on 15/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class CellViewModel: EmptyViewModel {
    
    var selectable: Bool = false
    
    var reloadCellHandler: ((CellViewModel) -> ())?

    override func safeSetFrame(_ frame: CGRect) {
        super.safeSetFrame(frame)
    }
}
