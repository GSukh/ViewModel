//
//  TableViewModel.swift
//  ViewModel
//
//  Created by Григорий Сухоруков on 15/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class Section {
    var name: String?
    var footer: CellViewModel?
    var items: Array<CellViewModel> = []
    var header: CellViewModel?
}

protocol TableViewModelDelegate: NSObjectProtocol {
    func tableViewModel(_ tableViewModel: TableViewModel, didSelectCell cell: CellViewModel, atIndexPath indexPath: IndexPath)
    
    // TODO: add sufficient list of methods
}

private var cellViewModelIdentifier = "CellViewModelIdentifier"

class TableViewModel: ViewModel<UITableView, ViewConfiguration<UITableView>> {
    private(set) var sections: [Section] = []
    weak var delegate: TableViewModelDelegate?
    
    private var viewStorage = ViewStorage()
    private let layoutQueue = DispatchQueue(label: "com.ViewModel.tableViewLayoutQueue")
    private var containerSize: CGSize = .zero

    
    override func createView() -> UITableView {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        
        tableView.register(CellView.self, forCellReuseIdentifier: cellViewModelIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }
    
    func reset(with sections: [Section]) {
        calculateLayoutFor(sections: sections) {
            guard let tableView = self.view else { return }
            
            self.sections = sections
            tableView.performBatchUpdates({
                tableView.insertSections(IndexSet(integersIn: 0...(sections.count - 1)), with: .automatic)
            }, completion: nil)
        }
    }
    
//    func append(sections: [Section]) {
//    }
    
    private func calculateLayoutFor(sections: [Section], completion: @escaping () -> ()) {
        let group = DispatchGroup()
        
        let containerSize = CGSize(width: view?.frame.width ?? 0, height: CGFloat.nan)
        for section in sections {
            for ViewModel in section.items {
                layoutQueue.async(group: group, execute: DispatchWorkItem(block: {
                    ViewModel.layout(with: containerSize)
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
        if let cellViewModel = cell.ViewModel {
            cellViewModel.unbind(withViewStorage: viewStorage)
            cell.ViewModel = nil
        }
    }
    
    fileprivate func reloadCellForViewModel(_ ViewModel: CellViewModel) {
        UIView.animate(withDuration: 1.0) {
            guard let tableView = self.view else { return }
            tableView.beginUpdates()
            for indexPath in tableView.indexPathsForVisibleRows ?? [] {
                let cellViewModel = self.sections[indexPath.section].items[indexPath.row]
                if cellViewModel.isEqual(ViewModel) {
                    cellViewModel.configureViewsTree()
                    if cellViewModel.needsLayout() {
                        let containerSize = CGSize(width: tableView.frame.width, height: CGFloat.nan)
                        cellViewModel.layout(with: containerSize)
                        cellViewModel.applyLayout()
                    }
                }
            }
            tableView.endUpdates()
        }

    }
}

extension TableViewModel: UITableViewDataSource {
    
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

extension TableViewModel: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let ViewModel = self.sections[indexPath.section].items[indexPath.row]
        if let cellView = cell as? CellView {
            cellView.adopt(ViewModel: ViewModel, withStorage: viewStorage)
        }
        ViewModel.reloadCellHandler = { [weak self] ViewModel in
            self?.reloadCellForViewModel(ViewModel)
        }
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cellView = cell as? CellView {
            unbindCellIfNeeded(cellView)
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = self.sections[indexPath.section].items[indexPath.row]
        if cellViewModel.needsLayout() {
            let containerSize = CGSize(width: view?.frame.width ?? 0, height: CGFloat.nan)
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
