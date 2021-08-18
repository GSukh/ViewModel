//
//  CollectionViewController.swift
//  ViewModel
//
//  Created by Григорий Сухоруков on 09/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit
import YogaUI

class CollectionViewController: ViewController {
    
    var collectionPresenter: CollectionPresenter {
        return presenter as! CollectionPresenter
    }
    
    var collectionView: UICollectionView {
        return collectionPresenter.collectionViewModel.view!
    }
    
    @available(*, unavailable)
    required init(with presenter: Presenter){
        fatalError()
    }
    
    required init(with collectionPresenter: CollectionPresenter) {
        super.init(with: collectionPresenter)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionPresenter.collectionViewModel.bind(toContainer: view, origin: .zero, viewStorage: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutCollectionView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutCollectionView()
    }
    
    func layoutCollectionView() {
        collectionView.frame = collectionViewFrame()
        // TODO: Нотифицировать collectionViewModel о смене размера view
    }
    
    func collectionViewFrame() -> CGRect {
        return view.bounds
    }

}
