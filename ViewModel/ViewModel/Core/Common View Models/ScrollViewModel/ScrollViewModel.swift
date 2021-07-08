//
//  ScrollConfiguration.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 07.07.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import UIKit
import YogaKit

class ScrollConfiguration: ViewConfiguration<UIScrollView> {
    var showsVerticalScrollIndicator: Bool = false
    var showsHorizontalScrollIndicator: Bool = false

    override func apply(toView view: UIScrollView) {
        super.apply(toView: view)
        view.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        view.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
    }
    
    override func prepareToReuse(view: UIScrollView) {
        super.prepareToReuse(view: view)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
    }
}

class ScrollViewModel: ViewModel<UIScrollView, ScrollConfiguration> {
    private var contentOffset: CGPoint = .zero

    override func configure(view: UIScrollView) {
        super.configure(view: view)
        view.contentSize = yoga.intrinsicSize
        view.contentOffset = contentOffset
        view.isScrollEnabled = true
    }

    override func prepareForReuse(view: UIScrollView) {
        super.prepareForReuse(view: view)
        contentOffset = view.contentOffset
    }
}
