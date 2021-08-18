//
//  Widget.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 15.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import UIKit

open class StatelessWidget: Widget {
    
    private var lastNode: LayoutNode?
    private var lastNodeContextHash: Int?
    
    public init() {}
    
    open func build(forContext context: WidgetRenderContext) -> LayoutNode {
        fatalError()
    }
    
    public func node(forContext context: WidgetRenderContext) -> LayoutNode {
        if let storedNode = storedNode(forContext: context) {
            return storedNode
        }
        let node = build(forContext: context)
        lastNode = node
        lastNodeContextHash = context.hashValue
        return node
    }
    
    private func storedNode(forContext context: WidgetRenderContext) -> LayoutNode? {
        guard let lastNode = lastNode,
              let lastNodeContextHash = lastNodeContextHash
        else { return nil }
        
        if lastNodeContextHash == context.hashValue {
            return lastNode
        }
        return nil
    }
    
    public func size(forContext context: WidgetRenderContext) -> CGSize {
        let node = node(forContext: context)
        node.layout(in: context.layoutSize)
        return node.frame.size
    }
    
    public var cellIdentifier: String {
        return String(describing: Self.self)
    }
}
