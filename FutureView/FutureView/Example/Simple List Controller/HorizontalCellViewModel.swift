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
        collectionViewModel.reset(with: sections)
        collectionViewModel.configureLayout { (layout) in
            layout.height = 100%
            layout.width = 100%
        }
        add(collectionViewModel)
        
        configureLayout(withBlock: {
            $0.height = YGValue(height)
        })
        
        
    }
    
}
