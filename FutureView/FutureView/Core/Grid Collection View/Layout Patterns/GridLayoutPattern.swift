//
//  GridLayoutPattern.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 20/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit



class GridLayoutPattern: CollectionSectionLayoutPattern {
    
    enum GrowBehavior {
        case automatic
        case fixed(CGFloat)
    }
    
    static func plain() -> GridLayoutPattern {
        let pattern = GridLayoutPattern()
        return pattern
    }
    
    var numberOfColumns: UInt = 1
    
    var itemMargin: UIEdgeInsets = .zero
    
    var sectionPadding: UIEdgeInsets = .zero
    
    var growBehavior: GrowBehavior = .automatic
    
    func layoutForItems(_ items: [CellFutureView], context: CollectionSectionLayoutContext) -> CollectionSectionLayout {
        switch context.direction {
        case .vertical:
            return verticalLayoutForItems(items, context: context)
        case .horizontal:
            return horizontalLayoutForItems(items, context: context)
        default:
            fatalError()
        }
    }
    
    func horizontalLayoutForItems(_ items: [CellFutureView], context: CollectionSectionLayoutContext) -> CollectionSectionLayout {
        let containerSize = context.containerSize
        let count = items.count

        var x = sectionPadding.left
        var y = sectionPadding.top
        let height = containerSize.height - sectionPadding.top - sectionPadding.bottom
        let itemHeight = height / CGFloat(numberOfColumns) - itemMargin.top - itemMargin.bottom
        let itemContainerSize = CGSize(width: CGFloat.nan, height: itemHeight)
        
        var column = 0
        x += itemMargin.left
        var itemFrames = [CGRect]()
        for (index, viewModel) in items.enumerated() {
            y += itemMargin.top

            if viewModel.needsLayout() {
                viewModel.layout(with: itemContainerSize)
            }
            
            let itemWidth = { () -> CGFloat in
                switch growBehavior {
                case .automatic:
                    return viewModel.frame.size.width
                case .fixed(let fixedWidth):
                    return fixedWidth
                }
            }()
                
            itemFrames.append(CGRect(x: x, y: y, width: itemWidth, height: itemHeight))
            y += itemHeight + itemMargin.bottom
            
            column += 1
            if column == numberOfColumns || index == count-1 {
                column = 0
                y = sectionPadding.top
                x += itemWidth + itemMargin.left + itemMargin.right
            }
        }

        x += sectionPadding.right
        
        let sectionSize = CGSize(width: x, height: height)
        return CollectionSectionLayout(itemFrames: itemFrames, size: sectionSize)
    }
    
    func verticalLayoutForItems(_ items: [CellFutureView], context: CollectionSectionLayoutContext) -> CollectionSectionLayout {
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
            
            let height = { () -> CGFloat in
                switch growBehavior {
                case .automatic:
                    return viewModel.frame.size.height
                case .fixed(let fixedHeight):
                    return fixedHeight
                }
            }()
                
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
