//
//  CellFutureView.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 15/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class CellFutureView: EmptyFutureView {
    
    var selectable: Bool = false
    
    var reloadCellHandler: ((CellFutureView) -> ())?

}
