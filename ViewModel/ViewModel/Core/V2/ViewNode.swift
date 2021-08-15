//
//  ViewNode.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 12.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import UIKit
import YogaKit

class ViewNode<View: UIView>: LayoutNode, BindableNode, LayoutSize, LayoutMargin {
    
    private var backgroundColor: UIColor?
    
    func createView() -> View {
        return View.init(frame: .zero)
    }
    
    func configure(view: View) {
        view.backgroundColor = backgroundColor
    }
    
    func prepareToReuse(view: View) {
        view.backgroundColor = nil
    }
    
    // MARK: - Builders
    func backgroundColor(_ color: UIColor) -> Self {
        backgroundColor = color
        return self
    }
    
    func bind(to view: UIView, offset: CGPoint) {
        let _view = createView()
        configure(view: _view)

        view.addSubview(_view)
        _view.frame = frame.addingOrigin(offset)
    }
}
