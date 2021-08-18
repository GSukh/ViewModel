//
//  WidgetCollectionCell.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 17.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import UIKit
import YogaUI

class WidgetCollectionCell: UICollectionViewCell {
    let widgetView = WidgetView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(widgetView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(widgetView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        widgetView.frame = bounds
    }
}
