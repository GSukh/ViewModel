//
//  CollectionFutureView.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 18/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit




class CollectionFutureView: FutureView<UICollectionView> {
    
    private var sections: [CollectionSection] = []
    
    private var viewStorage = ViewStorage()
    private let layoutQueue = DispatchQueue(label: "com.futureView.collectionViewLayoutQueue")
    private var containerSize: CGSize = .zero
    
    var direction: UICollectionView.ScrollDirection
    var showScrollIndicator: Bool = false

    init(scrollDirection: UICollectionView.ScrollDirection) {
        direction = scrollDirection
        super.init(withConfiguration: {_,_  in})
    }

    override func createView() -> UICollectionView {
        let collectionViewLayout = CollectionViewLayout2000()
        collectionViewLayout.direction = direction
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1234567890")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionReusableView")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterCollectionReusableView")
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.showsVerticalScrollIndicator = showScrollIndicator
        collectionView.showsHorizontalScrollIndicator = showScrollIndicator
        return collectionView
    }
    
    func reset(with sections: [CollectionSection]) {
        guard view != nil else {
            self.sections = sections
            return
        }
        
        prepareLayoutFor(sections: sections) {
            guard let collectionView = self.view else { return }

            self.sections = sections
            collectionView.performBatchUpdates({
                collectionView.insertSections(IndexSet(integersIn: 0...(sections.count - 1)))
            }, completion: nil)
        }
    }
    
    private func prepareLayoutFor(sections: [CollectionSection], completion: @escaping () -> ()) {
        let group = DispatchGroup()
        
        guard let width = view?.frame.width else {
            completion()
            return
        }

        let containerSize = CGSize(width: width, height: CGFloat.nan)
        let context = CollectionSectionLayoutContext(direction: .vertical, containerSize: containerSize)
        for section in sections {
            layoutQueue.async(group: group, execute: DispatchWorkItem(block: {
                section.prepareLayout(forContext: context)
            }))
        }
        
        group.notify(queue: DispatchQueue.main, work: DispatchWorkItem(block: completion))
    }
    
    
    override func bind(toContainer container: UIView, withViewStorage viewStorage: ViewStorage?) {
        super.bind(toContainer: container, withViewStorage: viewStorage)
        containerSize = view?.frame.size ?? .zero
        
        self.view?.delegate = self
        self.view?.dataSource = self
        if let layout = self.view?.collectionViewLayout as? CollectionViewLayout2000 {
            layout.dataSource = self
        }
    }
    
    override func unbind(withViewStorage viewStorage: ViewStorage?) {
        self.view?.delegate = nil
        self.view?.dataSource = nil
        if let layout = self.view?.collectionViewLayout as? CollectionViewLayout2000 {
            layout.dataSource = nil
        }
        
        super.unbind(withViewStorage: viewStorage)
    }
}

extension CollectionFutureView: CollectionViewLayout2000DataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "1234567890", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionFooter) {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterCollectionReusableView", for: indexPath)
        } else if (kind == UICollectionView.elementKindSectionHeader) {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCollectionReusableView", for: indexPath)
        }
        fatalError()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layoutForSection section: Int) -> CollectionSectionLayout {
        let containerSize = { () -> CGSize in
            switch direction {
                case .vertical: return CGSize(width: view?.frame.width ?? 0, height: CGFloat.nan)
                case .horizontal: return CGSize(width: CGFloat.nan, height: view?.frame.height ?? 0)
                default: fatalError()
            }
        }()
        let context = CollectionSectionLayoutContext(direction: direction, containerSize: containerSize)
        return sections[section].layout(forContext: context)
    }
}

extension CollectionFutureView: UICollectionViewDelegate {
    
    fileprivate func reloadCellForFutureView(_ futureView: CellFutureView) {
        UIView.animate(withDuration: 1.0) {
            guard let collectionView = self.view else { return }
            collectionView.performBatchUpdates({
                for indexPath in collectionView.indexPathsForVisibleItems {
                    let cellFutureView = self.sections[indexPath.section].items[indexPath.row]
                    if cellFutureView.isEqual(futureView) {
                        cellFutureView.configureViewsTree()
                        if cellFutureView.needsLayout() {
                            let containerSize = cellFutureView.frame.size
                            cellFutureView.layout(with: containerSize)
                            cellFutureView.applyLayout()
                        }
                    }
                }
            }, completion: nil)

        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let futureView = self.sections[indexPath.section].items[indexPath.row]
        futureView.bind(toContainer: cell, withViewStorage: viewStorage)
        futureView.reloadCellHandler = { [weak self] futureView in
            self?.reloadCellForFutureView(futureView)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let futureView = self.sections[indexPath.section].items[indexPath.row]
        futureView.unbind(withViewStorage: viewStorage)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        let optFutureView = { () -> CellFutureView? in
            if indexPath.row == 0 {
                return sections[indexPath.section].header
            } else {
                return sections[indexPath.section].footer
            }
        }()
        guard let futureView = optFutureView else {
            fatalError()
        }
        
        futureView.bind(toContainer: view, withViewStorage: viewStorage)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        let optFutureView = { () -> CellFutureView? in
            if indexPath.row == 0 {
                return sections[indexPath.section].header
            } else {
                return sections[indexPath.section].footer
            }
        }()
        guard let futureView = optFutureView else {
            fatalError()
        }
        
        futureView.unbind(withViewStorage: viewStorage)
    }
    
}
