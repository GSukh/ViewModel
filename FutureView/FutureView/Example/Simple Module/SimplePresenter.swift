//
//  SimplePresenter.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 07/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class SimplePresenter: CollectionPresenter {
    
    override func activate(with outputDelegate: PresenterOutput) {
        super.activate(with: outputDelegate)
        
        let section1 = { () -> CollectionSection in
            var items: [CellFutureView] = []
            for _ in 0...4 {
                items.append(SmallCellFutureView())
            }
            let section = CollectionSection()
            section.items = items
            
            let layoutPattern = GridLayoutPattern()
            layoutPattern.numberOfColumns = 2
    //        layoutPattern.itemHeight = 80
            layoutPattern.itemMargin = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
            layoutPattern.sectionPadding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            section.layoutPattern = layoutPattern
            return section
        }()
        
        let section2 = { () -> CollectionSection in
            var items: [CellFutureView] = []
            for _ in 0...4 {
                items.append(SmallCellFutureView())
            }
            let section = CollectionSection()
            section.items = items
            
            let layoutPattern = GridLayoutPattern()
            layoutPattern.numberOfColumns = 1
    //        layoutPattern.itemHeight = 80
            layoutPattern.itemMargin = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
            layoutPattern.sectionPadding = UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12)
            section.layoutPattern = layoutPattern
            return section
        }()
        
        
        collectionViewModel.reset(with: [section1, section2])
    }

}
