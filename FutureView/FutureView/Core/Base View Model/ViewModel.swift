//
//  ViewModel.swift
//  ViewModel
//
//  Created by Григорий Сухоруков on 15/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit
import YogaKit


typealias SimpleViewModel = ViewModel<UIView, ViewConfiguration<UIView>>

class ViewModel<ViewType: UIView, ConfigurationType: ViewConfiguration<ViewType>>: EmptyViewModel {
    
    fileprivate(set) var view: ViewType?
    let configuration: ConfigurationType = ConfigurationType()
    
    convenience init(_ configurator: (ConfigurationType) -> ()) {
        self.init()
        configurator(configuration)
    }
    
    typealias AddViewModel = (EmptyViewModel) -> ()
    convenience init(_ configurator: (ConfigurationType) -> (), constructor:(AddViewModel)->()) {
        self.init(configurator)
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
            configure(view: view)
            self.view = view

            super.bind(toContainer: view, withViewStorage: viewStorage)
        } else {
            super.bind(toContainer: container, withViewStorage: viewStorage)
        }
    }
    
    override func unbind(withViewStorage viewStorage: ViewStorage?) {
        if let view = view {
            prepareForReuse(view: view)
            
            view.removeFromSuperview()
            let iden = viewIdentifier()
            viewStorage?.enqueue(view: view, withIdentifier: iden)
            
            self.view = nil
        }
        
        super.unbind(withViewStorage: viewStorage)
    }
    
    func configure(view: ViewType) {
        configuration.apply(toView: view)
    }
    
    override func configureViewsTree() {
        super.configureViewsTree()
        if let view = view {
            configure(view: view)
        }
    }
    
    func prepareForReuse(view: ViewType) {
        configuration.prepareToReuse(view: view)
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
