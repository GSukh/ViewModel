//
//  TableViewController.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 15/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {

    var tableFutureView: TableFutureView
    
    init() {
        self.tableFutureView = TableFutureView(withConfiguration: {_,_  in })
        super.init(nibName: nil, bundle: nil)
        tableFutureView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableFutureView.bind(toContainer: view, withViewStorage: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableFutureView.view?.frame = view.bounds
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableFutureView.view?.frame = view.bounds
    }
    
}

extension TableViewController: TableFutureViewDelegate {
    func tableFutureView(_ tableFutureView: TableFutureView, didSelectCell cell: CellFutureView, atIndexPath indexPath: IndexPath) {
        
    }
}
