//
//  GridLayoutPattern.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 20/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class GridLayoutPattern: CollectionSectionLayoutPattern {
    
    var numberOfColumns: UInt = 1
    
    var itemMargin: UIEdgeInsets = .zero
    
    var sectionPadding: UIEdgeInsets = .zero
    
    var itemHeight: CGFloat = 0
    
    func layoutForItems(_ items: [CellFutureView], context: CollectionSectionLayoutContext) -> CollectionSectionLayout {
        let containerSize = context.containerSize
        let count = items.count

        var x = sectionPadding.left
        var y = sectionPadding.top
        let width = containerSize.width - sectionPadding.left - sectionPadding.right
        let itemWidth = width / CGFloat(numberOfColumns) - itemMargin.left - itemMargin.right
        let itemContainerSize = CGSize(width: itemWidth, height: CGFloat.nan)
        
        var column = 0
        y += itemMargin.top
        var itemFrames = [CGRect]()
        for (index, viewModel) in items.enumerated() {
            x += itemMargin.left
            
            if viewModel.needsLayout() {
                viewModel.layout(with: itemContainerSize)
            }
            let height = viewModel.frame.size.height
                
            itemFrames.append(CGRect(x: x, y: y, width: itemWidth, height: height))
            x += itemWidth + itemMargin.right
            
            column += 1
            if column == numberOfColumns || index == count-1 {
                column = 0
                x = sectionPadding.left
                y += height + itemMargin.top + itemMargin.bottom
            }
        }

        y += sectionPadding.bottom
        
        let sectionSize = CGSize(width: width, height: y)
        return CollectionSectionLayout(itemFrames: itemFrames, size: sectionSize)
    }
    
}
