//
//  HorizontalCellViewModel.swift
//  ViewModel
//
//  Created by Григорий Сухоруков on 21/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit
import YogaKit

class HorizontalCellViewModel: CellViewModel {

    init(_ sections: [CollectionSection], height: CGFloat) {
        super.init()
        
        let collectionViewModel = CollectionViewModel(scrollDirection: .horizontal)
            .width(100%)
            .height(100%)
        collectionViewModel.reset(with: sections)
        add(collectionViewModel)
        
        layout {
            $0.height = YGValue(height)
        }
    }
    
}
