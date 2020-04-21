//
//  CollectionPresenter.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 09/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class CollectionViewContext {
    var size: CGSize = .zero
    var orientation: UIInterfaceOrientation = .portrait
}

class CollectionPresenter: Presenter {
    
    var collectionViewModel: CollectionFutureView

    override init() {
        collectionViewModel = CollectionFutureView(scrollDirection: .vertical)
        super.init()
    }
    
    override func activate(with outputDelegate: PresenterOutput) {
        super.activate(with: outputDelegate)
        
        
//        collectionViewModel.delegate = self
    }
    
}

//extension CollectionPresenter: FutureViewDelegate {
//    func tableFutureView(_ tableFutureView: TableFutureView, didSelectCell cell: CellFutureView, atIndexPath indexPath: IndexPath) {
//        print("item selected")
//    }
//}
