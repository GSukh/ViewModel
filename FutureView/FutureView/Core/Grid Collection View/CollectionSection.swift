//
//  CollectionSection.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 20/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit


protocol CollectionSectionLayoutPattern {
    func layoutForItems(_ items: [CellFutureView], context: CollectionSectionLayoutContext) -> CollectionSectionLayout
}


class CollectionSectionLayoutContext {
    let containerSize: CGSize
    let direction: UICollectionView.ScrollDirection
    
    init(direction: UICollectionView.ScrollDirection, containerSize: CGSize) {
        self.direction = direction
        self.containerSize = containerSize
    }
    
    static func ~=(lhs: CollectionSectionLayoutContext, rhs: CollectionSectionLayoutContext) -> Bool {
        guard lhs.direction == rhs.direction else { return false }
        switch lhs.direction {
        case .vertical:
            return lhs.containerSize.width == rhs.containerSize.width
        case .horizontal:
            return lhs.containerSize.height == rhs.containerSize.height
        @unknown default:
            return false
        }
    }
}


class CollectionSectionLayout {
    var itemFrames: [CGRect]
    var size: CGSize
    
    init(itemFrames: [CGRect], size: CGSize) {
        self.itemFrames = itemFrames
        self.size = size
    }
}


class CollectionSection {
    var name: String?
    var footer: CellFutureView?
    var items: [CellFutureView] = []
    var header: CellFutureView?
    
    let layoutPattern: CollectionSectionLayoutPattern
    private(set) var lastContext: CollectionSectionLayoutContext?
    private(set) var lastLayout: CollectionSectionLayout?

    
    init(pattern layoutPattern: CollectionSectionLayoutPattern = GridLayoutPattern.plain()) {
        self.layoutPattern = layoutPattern
    }
    
    func prepareLayout(forContext context: CollectionSectionLayoutContext) {
        _ = layout(forContext: context)
    }
    
    func layout(forContext context: CollectionSectionLayoutContext) -> CollectionSectionLayout {
        if let lastLayout = lastLayout, let lastContext = lastContext, lastContext ~= context {
            return lastLayout
        }
        
        
        let layout = layoutPattern.layoutForItems(items, context: context)
        defer {
            lastContext = context
            lastLayout = layout
        }
        return layout
    }
}
