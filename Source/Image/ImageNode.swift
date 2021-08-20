//
//  ImageNode.swift
//  Pods-ViewModel
//
//  Created by Grigoriy Sukhorukov on 20.08.2021.
//

import YogaKit

open class ImageNode: ViewNode<UIImageView> {
    private let image: UIImage
    
    private var tintColor: UIColor?
    
    public init(_ image: UIImage) {
        self.image = image
        super.init()
    }
    
    open override func configure(view: UIImageView) {
        super.configure(view: view)
        view.image = image
        view.tintColor = tintColor
    }
    
    open override func prepareToReuse(view: UIImageView) {
        super.prepareToReuse(view: view)
        view.image = nil
        view.tintColor = nil
    }
    
    // MARK: - Builders
    open func tintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
}
