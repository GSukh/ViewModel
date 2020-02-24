//
//  FutureView.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 15/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit
import YogaKit

typealias FutureButton = FutureView<UIButton>
typealias FutureImageView = FutureView<UIImageView>

class FutureView<ViewType: UIView>: EmptyFutureView {
    
    fileprivate(set) var view: ViewType?
    fileprivate(set) var viewConfigurator: ViewConfigurator<ViewType>
    
    init(withConfiguration configuration: @escaping (ViewType, Bool) -> ()) {
        viewConfigurator = ViewConfigurator<ViewType>()
        viewConfigurator.add(configuration)
        super.init()
    }
    
    typealias AddFutureView = (EmptyFutureView) -> ()
    convenience init(withConfiguration configuration: @escaping (ViewType, Bool) -> (), constructor:(AddFutureView)->()) {
        self.init(withConfiguration: configuration)
        constructor({self.add($0)})
    }
    
    func createView() -> ViewType {
        return ViewType.init(frame: .zero)
    }
    
    // superclass methods
    override func bind(toContainer container: UIView, withViewStorage viewStorage: ViewStorage?) {
        let iden = viewIdentifier()
        var viewCandidate: ViewType? = viewStorage?.dequeue(viewWithIdentifier: iden) as? ViewType
        if viewCandidate == nil {
            viewCandidate = createView()
        }
        
        if let view = viewCandidate {
            container.addSubview(view)
            view.frame = frame
            self.view = view
            configureView()
                    
            super.bind(toContainer: view, withViewStorage: viewStorage)
        } else {
            super.bind(toContainer: container, withViewStorage: viewStorage)
        }
    }
    
    override func unbind(withViewStorage viewStorage: ViewStorage?) {
        prepareForReuse()
        
        if let view = view {
            view.removeFromSuperview()
            let iden = viewIdentifier()
            viewStorage?.enqueue(view: view, withIdentifier: iden)
            
            self.view = nil
        }
        
        super.unbind(withViewStorage: viewStorage)
    }
    
    func configureView() {
        if let view = view {
            viewConfigurator.configure(view: view)
        }
    }
    
    override func configureViewsTree() {
        super.configureViewsTree()
        configureView()
    }
    
    func prepareForReuse() {
        if let view = view {
            viewConfigurator.prepareForReuse(view: view)
        }
    }
    
    override func applyLayout() {
        super.applyLayout()
        
        assert(Thread.isMainThread)
        if let view = view {
            view.frame = frame
        }
    }
    
    // PRIVATE FUNCS
    private func viewIdentifier() -> String {
        return String(describing: ViewType.self)
    }
}
