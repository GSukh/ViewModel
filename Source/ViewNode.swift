//
//  ViewNode.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 12.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import YogaKit

open class ViewNode<View: UIView>: LayoutNode, YogaSizeBuilder, YogaMarginBuilder {
    
    private var backgroundColor: UIColor?
    private(set) weak var view: View?
    
//    public override init() {
//        super.init()
//    }
    
    func createView() -> View {
        return View.init(frame: .zero)
    }
    
    open func configure(view: View) {
        view.backgroundColor = backgroundColor
        view.isUserInteractionEnabled = false
    }
    
    open func prepareToReuse(view: View) {
        view.backgroundColor = nil
    }
    
    open override func bind(from viewStorage: ViewStorage, to view: UIView, offset: CGPoint) {
        super.bind(from: viewStorage, to: view, offset: offset)
        let _view: View = viewStorage.dequeue(viewWithIdentifier: viewIdentifier) ?? createView()
        configure(view: _view)

        view.addSubview(_view)
        _view.frame = frame.addingOrigin(offset)
        self.view = _view
    }
    
    open override func unbind(to viewStorage: ViewStorage) {
        super.unbind(to: viewStorage)
        guard let view = view else { return }
        prepareToReuse(view: view)

        view.removeFromSuperview()
        viewStorage.enqueue(view: view, withIdentifier: viewIdentifier)
        self.view = nil
    }
    
    private var viewIdentifier: String {
        return String(describing: View.self)
    }
    
    // MARK: - Builders
    open func backgroundColor(_ color: UIColor) -> Self {
        backgroundColor = color
        return self
    }
}

extension CGRect {
    func addingOrigin(_ origin: CGPoint) -> CGRect {
        let x = self.origin.x + origin.x
        let y = self.origin.y + origin.y
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
