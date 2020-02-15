//
//  TableViewController.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 15/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {

    var viewModel: TableFutureView
    
    init() {
        self.viewModel = TableFutureView(withConfiguration: {_,_  in })
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(toContainer: view, withViewStorage: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.view?.frame = view.bounds
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.view?.frame = view.bounds
    }
    
}

extension TableViewController: TableViewModelDelegate {
    func tableViewModel(_ tableViewModel: TableFutureView, didSelectCell cell: CellFutureView, atIndexPath indexPath: IndexPath) {
        // for subclasses
    }
}
