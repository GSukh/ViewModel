//
//  HTMLSampleWidget.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 30.09.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import YogaKit
import YogaUI

class HTMLSampleWidget: StatelessWidget {

    let htmlString: String
    init(htmlString: String) {
        self.htmlString = htmlString
        super.init()
    }
    
    override func build(forContext context: WidgetRenderContext) -> LayoutNode {
        return VContainer {
            TextNode(htmlString)
                .systemFont(ofSize: 15.0, weight: .regular)
                .lineHeight(20.0)
                .markHTML()
                .margin(20)
        }
        .backgroundColor(.orange)
        .identifier("html_sample")
    }
}
