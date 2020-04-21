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
        
        let bannersSection = { () -> CollectionSection in
            let colors: [UIColor] = [.red, .purple, .orange, .green]
            var items: [CellFutureView] = []
            for i in 0...3 {
                let cell = BannerHorizontalCellViewModel(color: colors[i])
                items.append(cell)
            }
            
            let horizontalLayoutPattern = GridLayoutPattern()
            horizontalLayoutPattern.sectionPadding = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 0.0, right: 12.0)
            horizontalLayoutPattern.itemMargin = UIEdgeInsets(top: 0.0, left: 4.0, bottom: 0.0, right: 4.0)

            let horizontalSection = CollectionSection(pattern: horizontalLayoutPattern)
            horizontalSection.items = items
            
            
            let height = BannerHorizontalCellViewModel.size.height + 12.0
            let horizontalCellViewModel = HorizontalCellFutureView([horizontalSection], height: height)
            
            let section = CollectionSection()
            section.items = [horizontalCellViewModel]
            section.footer = FooterCellViewModel()
            
            return section
        }()
        
        let familySection = { () -> CollectionSection in
            let titles = ["Григорий Сухоруков", "Михаил Сухоруков", "Алексей Сухоруков", "Людмила Сухорукова"]
            let colors: [UIColor] = [.orange, .green, .blue, .purple]
            var items: [CellFutureView] = []
            for i in 0...3 {
                let cell = FriendHorizontalCellViewModel(title: titles[i], color: colors[i])
                items.append(cell)
            }
            
            let horizontalLayoutPattern = GridLayoutPattern()
            horizontalLayoutPattern.sectionPadding = UIEdgeInsets(top: 12.0, left: 8.0, bottom: 0.0, right: 8.0)
            horizontalLayoutPattern.itemMargin = UIEdgeInsets(top: 0.0, left: 4.0, bottom: 0.0, right: 4.0)

            let horizontalSection = CollectionSection(pattern: horizontalLayoutPattern)
            horizontalSection.items = items
            
            
            let height = FriendHorizontalCellViewModel.size.height + 12.0
            let horizontalCellViewModel = HorizontalCellFutureView([horizontalSection], height: height)
            
            let section = CollectionSection()
            section.items = [horizontalCellViewModel]
            section.header = HeaderCellViewModel(title: "Моя семья", buttonText: "Показать все")
            section.footer = FooterCellViewModel()
            
            return section
        }()
        
        
        let menuSection = { () -> CollectionSection in
            let titles = ["Товары", "Магазины", "Скидки", "Подписки", "Акции", "Платежи", "Музыка"]
            let colors: [UIColor] = [.orange, .green, .blue, .purple, .orange, .green, .blue]
            var items: [CellFutureView] = []
            for i in 0...6 {
                items.append(MenuItemCellFutureView(title: titles[i], color: colors[i]))
            }
            
            let layoutPattern = GridLayoutPattern()
            layoutPattern.numberOfColumns = 3
            layoutPattern.itemMargin = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
            layoutPattern.sectionPadding = UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12)
            
            let section = CollectionSection(pattern: layoutPattern)
            section.items = items

            return section
        }()
        
//        let section2 = { () -> CollectionSection in
//            var items: [CellFutureView] = []
//            for _ in 0...4 {
//                items.append(SmallCellFutureView())
//            }
//            let section = CollectionSection()
//            section.items = items
//            return section
//        }()
        
        
        collectionViewModel.reset(with: [bannersSection, familySection, menuSection])
    }

}
