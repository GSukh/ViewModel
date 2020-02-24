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

protocol TableFutureViewDelegate: NSObjectProtocol {
    func tableFutureView(_ tableFutureView: TableFutureView, didSelectCell cell: CellFutureView, atIndexPath indexPath: IndexPath)
    
    // TODO: add sufficient list of methods
}

private var cellFutureViewIdentifier = "CellFutureViewIdentifier"

class TableFutureView: FutureView<UITableView> {
    private(set) var sections: [Section] = []
    weak var delegate: TableFutureViewDelegate?
    
    private var viewStorage = ViewStorage()
    private let layoutQueue = DispatchQueue(label: "com.futureView.tableViewLayoutQueue")
    private var containerSize: CGSize = .zero

    
    override func createView() -> UITableView {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        
        tableView.register(CellView.self, forCellReuseIdentifier: cellFutureViewIdentifier)
        
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
    
//    func append(sections: [Section]) {
//    }
    
    private func calculateLayoutFor(sections: [Section], completion: @escaping () -> ()) {
        let group = DispatchGroup()
        
        let containerSize = CGSize(width: view?.frame.width ?? 0, height: CGFloat.nan)
        for section in sections {
            for futureView in section.items {
                layoutQueue.async(group: group, execute: DispatchWorkItem(block: {
                    futureView.layout(with: containerSize)
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
        if let cellFutureView = cell.futureView {
            cellFutureView.unbind(withViewStorage: viewStorage)
            cell.futureView = nil
        }
    }
    
    fileprivate func reloadCellForFutureView(_ futureView: CellFutureView) {
        UIView.animate(withDuration: 1.0) {
            guard let tableView = self.view else { return }
            tableView.beginUpdates()
            for indexPath in tableView.indexPathsForVisibleRows ?? [] {
                let cellFutureView = self.sections[indexPath.section].items[indexPath.row]
                if cellFutureView.isEqual(futureView) {
                    cellFutureView.configureViewsTree()
                    if cellFutureView.needsLayout() {
                        let containerSize = CGSize(width: tableView.frame.width, height: CGFloat.nan)
                        cellFutureView.layout(with: containerSize)
                        cellFutureView.applyLayout()
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
        return tableView.dequeueReusableCell(withIdentifier: cellFutureViewIdentifier, for: indexPath)
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].name
    }
}

extension TableFutureView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let futureView = self.sections[indexPath.section].items[indexPath.row]
        if let cellView = cell as? CellView {
            cellView.adopt(futureView: futureView, withStorage: viewStorage)
        }
        futureView.reloadCellHandler = { [weak self] futureView in
            self?.reloadCellForFutureView(futureView)
        }
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cellView = cell as? CellView {
            unbindCellIfNeeded(cellView)
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellFutureView = self.sections[indexPath.section].items[indexPath.row]
        if cellFutureView.needsLayout() {
            let containerSize = CGSize(width: view?.frame.width ?? 0, height: CGFloat.nan)
            cellFutureView.layout(with: containerSize)
        }
        return cellFutureView.frame.size.height
    }
    
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let cellFutureView = self.sections[indexPath.section].items[indexPath.row]
        return cellFutureView.selectable
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellFutureView = self.sections[indexPath.section].items[indexPath.row]
        delegate?.tableFutureView(self, didSelectCell: cellFutureView, atIndexPath: indexPath)

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
