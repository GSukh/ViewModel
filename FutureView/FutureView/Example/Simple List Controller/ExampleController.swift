//
//  ExampleController.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 15/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class ExampleController: TableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMockedItems()
    }
    
    private func loadMockedItems() {
        var items: [CellFutureView] = []
        for _ in 0...20 {
            items.append(SmallCellFutureView())
        }
        let section = Section()
        section.items = items
        tableFutureView.update(sections: [section])
    }

}
