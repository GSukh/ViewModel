//
//  CollectionViewModel.swift
//  ViewModel
//
//  Created by Григорий Сухоруков on 18/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit




class CollectionViewModel: ViewModel<UICollectionView, ViewConfiguration<UICollectionView>> {
    
    private var sections: [CollectionSection] = []
    
    private var viewStorage = ViewStorage()
    private let layoutQueue = DispatchQueue(label: "com.ViewModel.collectionViewLayoutQueue")
    private var containerSize: CGSize = .zero
    
    var direction: UICollectionView.ScrollDirection
    var showScrollIndicator: Bool = false

    init(scrollDirection: UICollectionView.ScrollDirection) {
        direction = scrollDirection
        super.init()
    }

    override func createView() -> UICollectionView {
        let collectionViewLayout = GridCollectionViewLayout()
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
        if let layout = self.view?.collectionViewLayout as? GridCollectionViewLayout {
            layout.dataSource = self
        }
    }
    
    override func unbind(withViewStorage viewStorage: ViewStorage?) {
        self.view?.delegate = nil
        self.view?.dataSource = nil
        if let layout = self.view?.collectionViewLayout as? GridCollectionViewLayout {
            layout.dataSource = nil
        }
        
        super.unbind(withViewStorage: viewStorage)
    }
}

extension CollectionViewModel: CollectionViewLayout2000DataSource {
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

extension CollectionViewModel: UICollectionViewDelegate {
    
    fileprivate func reloadCellForViewModel(_ ViewModel: CellViewModel) {
        UIView.animate(withDuration: 1.0) {
            guard let collectionView = self.view else { return }
            collectionView.performBatchUpdates({
                for indexPath in collectionView.indexPathsForVisibleItems {
                    let cellViewModel = self.sections[indexPath.section].items[indexPath.row]
                    if cellViewModel.isEqual(ViewModel) {
                        cellViewModel.configureViewsTree()
                        if cellViewModel.needsLayout() {
                            let containerSize = cellViewModel.frame.size
                            cellViewModel.layout(with: containerSize)
                            cellViewModel.applyLayout()
                        }
                    }
                }
            }, completion: nil)

        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let ViewModel = self.sections[indexPath.section].items[indexPath.row]
        ViewModel.bind(toContainer: cell, withViewStorage: viewStorage)
        ViewModel.reloadCellHandler = { [weak self] ViewModel in
            self?.reloadCellForViewModel(ViewModel)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let ViewModel = self.sections[indexPath.section].items[indexPath.row]
        ViewModel.unbind(withViewStorage: viewStorage)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        let optViewModel = { () -> CellViewModel? in
            if indexPath.row == 0 {
                return sections[indexPath.section].header
            } else {
                return sections[indexPath.section].footer
            }
        }()
        guard let ViewModel = optViewModel else {
            fatalError()
        }
        
        ViewModel.bind(toContainer: view, withViewStorage: viewStorage)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        let optViewModel = { () -> CellViewModel? in
            if indexPath.row == 0 {
                return sections[indexPath.section].header
            } else {
                return sections[indexPath.section].footer
            }
        }()
        guard let ViewModel = optViewModel else {
            fatalError()
        }
        
        ViewModel.unbind(withViewStorage: viewStorage)
    }
    
}
