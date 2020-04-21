//
//  SimplePresenter.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 07/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit
import YogaKit

class SimplePresenter: CollectionPresenter {
    
    override func activate(with outputDelegate: PresenterOutput) {
        super.activate(with: outputDelegate)
        
        let section0 = { () -> CollectionSection in
            var items: [CellFutureView] = []
            for _ in 0...10 {
                let cell = CellFutureView()
                cell.configureLayout { (layout) in
                    layout.height = 50
                    layout.width = 50
                }
                
                let circle = FutureView<UIView> { (view, reuse) in
                    view.backgroundColor = UIColor.red
                    view.layer.cornerRadius = 25.0
                }
                circle.configureLayout { (layout) in
                    layout.height = 100%
                    layout.width = 100%
                }
                cell.add(circle)
                
                items.append(cell)
            }
            let horizontalSection = CollectionSection()
            horizontalSection.items = items
            
            let horizontalCellViewModel = HorizontalCellFutureView([horizontalSection], height: 60.0)
            
            
            let section = CollectionSection()
            section.items = [horizontalCellViewModel]
            
            return section
        }()
        
        
        let section1 = { () -> CollectionSection in
            var items: [CellFutureView] = []
            for _ in 0...4 {
                items.append(SmallCellFutureView())
            }
            
            let layoutPattern = GridLayoutPattern()
            layoutPattern.numberOfColumns = 2
            layoutPattern.itemMargin = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
            layoutPattern.sectionPadding = UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12)
            
            let section = CollectionSection(pattern: layoutPattern)
            section.items = items

            return section
        }()
        
        let section2 = { () -> CollectionSection in
            var items: [CellFutureView] = []
            for _ in 0...4 {
                items.append(SmallCellFutureView())
            }
            let section = CollectionSection()
            section.items = items
            return section
        }()
        
        
        collectionViewModel.reset(with: [section0, section1, section2])
    }

}
