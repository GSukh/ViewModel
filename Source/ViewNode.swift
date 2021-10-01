//
//  ViewNode.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 12.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import YogaKit

struct Shadow {
    let color: UIColor
    let opacity: Float
    let offset: CGSize
    let radius: CGFloat
}

open class ViewNode<View: UIView>: LayoutNode, YogaSizeBuilder, YogaMarginBuilder {
    
    private var backgroundColor: UIColor?
    private var cornerRadius: CGFloat = 0.0
    private var maskedCorners: CACornerMask = .all
    private var borderWidth: CGFloat = 0.0
    private var borderColor: UIColor?
    private var userInteractionEnabled: Bool = false
    private var contentMode: UIView.ContentMode = .scaleToFill
    private var shadow: Shadow?
    private var identifier: String?

    private weak var _view: View?
    open var view: View? {
        return _view
    }
    
    open func createView() -> View {
        return View.init(frame: .zero)
    }
    
    open func configure(view: View) {
        view.backgroundColor = backgroundColor
        view.isUserInteractionEnabled = userInteractionEnabled
        view.layer.cornerRadius = cornerRadius
        view.layer.maskedCorners = maskedCorners
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor?.cgColor
        view.clipsToBounds = true
        view.contentMode = contentMode
        if let shadow = shadow {
            view.layer.shadowColor = shadow.color.cgColor
            view.layer.shadowOpacity = shadow.opacity
            view.layer.shadowOffset = shadow.offset
            view.layer.shadowRadius = shadow.radius
            view.clipsToBounds = false
        }
        view.accessibilityIdentifier = identifier
    }
    
    open func prepareToReuse(view: View) {
        view.backgroundColor = nil
        view.isUserInteractionEnabled = false
        view.layer.cornerRadius = 0.0
        view.layer.maskedCorners = []
        view.layer.borderWidth = 0.0
        view.layer.borderColor = nil
        view.contentMode = .scaleToFill
        if shadow != nil {
            view.layer.shadowColor = nil
            view.layer.shadowOpacity = 0.0
            view.layer.shadowOffset = CGSize(width: 0, height: -3)
            view.layer.shadowRadius = 3
            view.clipsToBounds = false
        }
        view.accessibilityIdentifier = nil
    }
    
    open override func bind(from viewStorage: ViewStorage, to view: UIView, offset: CGPoint) {
        super.bind(from: viewStorage, to: view, offset: offset)
        let newView: View = viewStorage.dequeue(viewWithIdentifier: viewIdentifier) ?? createView()
        configure(view: newView)

        view.addSubview(newView)
        newView.frame = frame.addingOrigin(offset)
        _view = newView
    }
    
    open override func unbind(to viewStorage: ViewStorage) {
        super.unbind(to: viewStorage)
        guard let view = view else { return }
        prepareToReuse(view: view)

        view.removeFromSuperview()
        viewStorage.enqueue(view: view, withIdentifier: viewIdentifier)
        _view = nil
    }
    
    private var viewIdentifier: String {
        return String(describing: View.self)
    }
    
    // MARK: - Builders
    open func backgroundColor(_ color: UIColor) -> Self {
        backgroundColor = color
        return self
    }

    open func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        return self.cornerRadius(cornerRadius, maskedCorners: .all)
    }
    
    open func cornerRadius(_ cornerRadius: CGFloat, maskedCorners: CACornerMask) -> Self {
        self.cornerRadius = cornerRadius
        self.maskedCorners = maskedCorners
        return self
    }
    
    open func border(width: CGFloat, color: UIColor) -> Self {
        self.borderWidth = width
        self.borderColor = color
        return self
    }
    
    open func userInteractionEnabled(_ userInteractionEnabled: Bool) -> Self {
        self.userInteractionEnabled = userInteractionEnabled
        return self
    }
    
    open func contentMode(_ contentMode: UIView.ContentMode) -> Self {
        self.contentMode = contentMode
        return self
    }
    
    open func shadow(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat) -> Self {
        shadow = Shadow(color: color, opacity: opacity, offset: offset, radius: radius)
        return self
    }
    
    open func identifier(_ identifier: String) -> Self {
        self.identifier = identifier
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

extension CACornerMask {
    static var all: CACornerMask {
        return [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    }
}
