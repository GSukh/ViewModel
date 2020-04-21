//
//  CollectionViewLayout2000.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 09/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

protocol CollectionViewLayout2000DataSource: UICollectionViewDataSource {
        
    func collectionView(_ collectionView: UICollectionView, layoutForSection section: Int) -> CollectionSectionLayout

}

private class CollectionViewSectionAttributes {
    var frame: CGRect
    var items: [UICollectionViewLayoutAttributes]
    var header: UICollectionViewLayoutAttributes?
    var footer: UICollectionViewLayoutAttributes?
    
    init(with frame: CGRect, items: [UICollectionViewLayoutAttributes], header: UICollectionViewLayoutAttributes? = nil, footer: UICollectionViewLayoutAttributes? = nil) {
        self.frame = frame
        self.items = items
        self.header = header
        self.footer = footer
    }
}

class CollectionViewLayout2000: UICollectionViewLayout {
    
    var direction: UICollectionView.ScrollDirection = .vertical
    
    weak var dataSource: CollectionViewLayout2000DataSource? = nil
    
    private var layoutSize: CGSize = .zero
    override open var collectionViewContentSize: CGSize {
        return layoutSize
    }
    
    fileprivate var sections: [CollectionViewSectionAttributes] = []
    

    open override func prepare() {
        guard let dataSource = dataSource else { return }
        guard let collectionView = collectionView else { return }
        let numberOfSections = dataSource.numberOfSections?(in: collectionView) ?? 0
    
        sections = []
        
        var totalFrame: CGRect = .zero
        for s in 0..<numberOfSections {
            let sectionLayout = dataSource.collectionView(collectionView, layoutForSection: s)
            
            let originX: CGFloat = direction == .horizontal ? totalFrame.maxX : 0.0
            let originY: CGFloat = direction == .vertical ? totalFrame.maxY : 0.0
            
            var headerAttributes: UICollectionViewLayoutAttributes? = nil
            if let headerFrame = sectionLayout.header {
                headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: s))
                headerAttributes?.frame = headerFrame
                headerAttributes?.frame.origin.x += originX
                headerAttributes?.frame.origin.y += originY
            }
            
            let items: [UICollectionViewLayoutAttributes] = sectionLayout.itemFrames.enumerated().map { (index, frame) -> UICollectionViewLayoutAttributes in
                let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: index, section: s))
                attributes.frame = frame
                attributes.frame.origin.x += originX
                attributes.frame.origin.y += originY
                return attributes
            }
            
            var footerAttributes: UICollectionViewLayoutAttributes? = nil
            if let footerFrame = sectionLayout.footer {
                footerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: IndexPath(item: 1, section: s))
                footerAttributes?.frame = footerFrame
                footerAttributes?.frame.origin.x += originX
                footerAttributes?.frame.origin.y += originY
            }

            let sectionFrame = CGRect(origin: CGPoint(x: originX, y: originY), size: sectionLayout.size)
            totalFrame = totalFrame.union(sectionFrame)
            sections.append(CollectionViewSectionAttributes(with: sectionFrame, items: items, header: headerAttributes, footer: footerAttributes))
        }
        
        layoutSize = totalFrame.size
    }

    
//    func addAttributes(_ pattern: SquareMosaicPattern, rows: Int, section: Int) {
//        var attributes = [UICollectionViewLayoutAttributes]()
//        var row: Int = 0
//        let blocks = pattern.blocks(rows)
//        for (index, block) in blocks.enumerated() {
//            guard row < rows else { break }
//            addSeparatorBlock(.betweenBlocks, block: index, blocks: blocks.count, pattern: pattern)
//            let side = self.direction == .vertical ? self.size.width : self.size.height
//            let frames = block.blockFrames(origin: self.total, side: side)
//            var total: CGFloat = 0
//            for x in 0..<block.blockFrames() {
//                guard row < rows else { break }
//                let indexPath = IndexPath(row: row, section: section)
//                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//                attribute.frame = frames[x]
//                attribute.zIndex = 0
//                switch self.direction {
//                case .vertical:
//                    let dy = attribute.frame.origin.y + attribute.frame.height - self.total
//                    total = dy > total ? dy : total
//                case .horizontal:
//                    let dx = attribute.frame.origin.x + attribute.frame.width - self.total
//                    total = dx > total ? dx : total
//                }
//                attributes.append(attribute)
//                row += 1
//            }
//            self.total += total
//        }
//        attributesForCells[section] = attributes
//    }

//    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        return object?.layoutAttributesForItem(at: indexPath)
//    }
//
//    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        return object?.layoutAttributesForElements(in: rect)
//    }
//
//    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        return object?.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
//    }
    
//    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
//        return collectionView?.contentOffset ?? CGPoint.zero
//    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.section < sections.count else { return  nil }
        let sectionAttributes = sections[indexPath.section]
        
        guard indexPath.row < sectionAttributes.items.count else { return nil }
        return sectionAttributes.items[indexPath.row]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let sectionsInRect = sections.filter { (section) -> Bool in
            return section.frame.intersects(rect)
        }
        
        return sectionsInRect.flatMap { (section) -> [UICollectionViewLayoutAttributes] in
            var attributes = section.items.filter { (item) -> Bool in
                return item.frame.intersects(rect)
            }
            
            if let header = section.header, header.frame.intersects(rect) {
                attributes.append(header)
            }
            
            if let footer = section.footer, footer.frame.intersects(rect) {
                attributes.append(footer)
            }
            
            return attributes
        }
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let section = sections[indexPath.section]
        if indexPath.row == 0 {
            return section.header
        } else {
            return section.footer
        }
    }
}
