//
//  TableFutureView.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 15/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class Section {
    var name: String?
    var footer: CellFutureView?
    var items: Array<CellFutureView> = []
    var header: CellFutureView?
}

protocol TableViewModelDelegate: NSObjectProtocol {
    func tableViewModel(_ tableViewModel: TableFutureView, didSelectCell cell: CellFutureView, atIndexPath indexPath: IndexPath)
    
    // TODO: add sufficient list of methods
}

private var cellViewModelIdentifier = "CellViewModelReuseIdentifier"

class TableFutureView: FutureView<UITableView> {
    private(set) var sections: [Section] = []
    weak var delegate: TableViewModelDelegate?
    
    private var viewStorage = ViewStorage()
    private let layoutQueue = DispatchQueue(label: "com.viewModel.tableViewLayoutQueue")
    private var containerSize: CGSize = .zero

    
    override func createView() -> UITableView {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        
        tableView.register(CellView.self, forCellReuseIdentifier: cellViewModelIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }
    
    func update(sections: [Section]) {
        calculateLayoutFor(sections: sections) {
            guard let tableView = self.view else { return }
            
            self.sections = sections
            tableView.performBatchUpdates({
                tableView.insertSections(IndexSet(integersIn: 0...(sections.count - 1)), with: .automatic)
            }, completion: nil)
        }
    }
    
    func append(sections: [Section]) {
//        self.sections = section
    }
    
    private func calculateLayoutFor(sections: [Section], completion: @escaping () -> ()) {
        let group = DispatchGroup()
        
        let containerSize = CGSize(width: view?.frame.width ?? 0, height: CGFloat.greatestFiniteMagnitude)
        for section in sections {
            for cellViewModel in section.items {
                layoutQueue.async(group: group, execute: DispatchWorkItem(block: {
                    cellViewModel.layout(with: containerSize)
                }))
            }
        }
        
        group.notify(queue: DispatchQueue.main, work: DispatchWorkItem(block: completion))
    }
    
    override func bind(toContainer container: UIView, withViewStorage viewStorage: ViewStorage?) {
        super.bind(toContainer: container, withViewStorage: viewStorage)
        containerSize = view?.frame.size ?? .zero
    }
    
    override func unbind(withViewStorage viewStorage: ViewStorage?) {
        self.view?.delegate = nil
        self.view?.dataSource = nil
        
        super.unbind(withViewStorage: viewStorage)
    }
    
    fileprivate func unbindCellIfNeeded(_ cell: CellView) {
        if let cellViewModel = cell.viewModel {
            cellViewModel.unbind(withViewStorage: viewStorage)
            cell.viewModel = nil
        }
    }
    
    fileprivate func reloadCellForViewModel(_ viewModel: CellFutureView) {
//        for indexPath in tableView.indexPathsForVisibleRows ?? [] {
//            let cellViewModel = self.sections[indexPath.section].items[indexPath.row]
//            if cellViewModel.isEqual(viewModel) {
//                tableView.reloadRows(at: [indexPath], with: .automatic)
//            }
//        }
        UIView.animate(withDuration: 1.0) {
            guard let tableView = self.view else { return }
            tableView.beginUpdates()
            for indexPath in tableView.indexPathsForVisibleRows ?? [] {
                let cellViewModel = self.sections[indexPath.section].items[indexPath.row]
                if cellViewModel.isEqual(viewModel) {
                    if cellViewModel.needsLayout() {
                        let containerSize = CGSize(width: tableView.frame.width, height: CGFloat.greatestFiniteMagnitude)
                        cellViewModel.layout(with: containerSize)
                        cellViewModel.applyLayout()
                    }
                }
            }
            tableView.endUpdates()
        }

    }
}

extension TableFutureView: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cellViewModelIdentifier, for: indexPath)
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].name
    }
}

extension TableFutureView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let viewModel = self.sections[indexPath.section].items[indexPath.row]
        if let cellViewModelView = cell as? CellView {
            cellViewModelView.adopt(viewModel: viewModel, withStorage: viewStorage)
        }
//        viewModel.bind(toContainer: cell, withViewStorage: viewStorage)
        viewModel.reloadCellHandler = { [weak self] viewModel in
            self?.reloadCellForViewModel(viewModel)
        }
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cellViewModelView = cell as? CellView {
            unbindCellIfNeeded(cellViewModelView)
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = self.sections[indexPath.section].items[indexPath.row]
        if cellViewModel.needsLayout() {
            let containerSize = CGSize(width: view?.frame.width ?? 0, height: CGFloat.greatestFiniteMagnitude)
            cellViewModel.layout(with: containerSize)
        }
        return cellViewModel.frame.size.height
    }
    
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let cellViewModel = self.sections[indexPath.section].items[indexPath.row]
        return cellViewModel.selectable
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = self.sections[indexPath.section].items[indexPath.row]
        delegate?.tableViewModel(self, didSelectCell: cellViewModel, atIndexPath: indexPath)

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
