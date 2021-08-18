//
//  SampleWidget.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 17.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import YogaKit
import YogaUI

class SampleWidget: StatelessWidget {
    override func build(forContext context: WidgetRenderContext) -> LayoutNode {
        return VContainer {
            let numberOfLines = Int.random(in: 1..<4)
            for i in 0..<numberOfLines {
                TextNode("text \(i)")
                    .margin(4)
            }
        }
        .backgroundColor(.red)
    }
}
