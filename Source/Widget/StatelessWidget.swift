//
//  Widget.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 15.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import UIKit

open class StatelessWidget: NSObject, Widget {
    
    private var lastNode: LayoutNode?
    private var lastNodeContextHash: Int?
    public var accessibilityIdentifier: String?
        
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
    
    public func rebuild() {
        // Придумать лучшую реализацию ребилда
        // Вынести виджет с ребилдом в StatefullWidget
        guard let lastNode = lastNode else { return }
        guard let widgetView = lastNode.superView as? WidgetView else { return }
        guard let widgetContext = widgetView.lastContext else { return }
        
        lastNodeContextHash = nil
        widgetView.setWidget(self, withContext: widgetContext)
    }
    
    public var cellIdentifier: String {
        return String(describing: Self.self)
    }
}
