//
//  CollectionSection.swift
//  ViewModel
//
//  Created by Григорий Сухоруков on 20/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit


protocol CollectionSectionLayoutPattern {
    func layoutForSection(_ section: Section, context: CollectionSectionLayoutContext) -> CollectionSectionLayout
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
    var header: CGRect?
    var footer: CGRect?
    var size: CGSize
    
    init(itemFrames: [CGRect], size: CGSize, header: CGRect? = nil, footer: CGRect? = nil) {
        self.itemFrames = itemFrames
        self.size = size
        self.header = header
        self.footer = footer
    }
}


class CollectionSection: Section {
//    var name: String?
//    var footer: CellViewModel?
//    var items: [CellViewModel] = []
//    var header: CellViewModel?
    
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
        
        let layout = layoutPattern.layoutForSection(self, context: context)
        defer {
            lastContext = context
            lastLayout = layout
        }
        return layout
    }
}
