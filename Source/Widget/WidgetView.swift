//
//  WidgetView.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 15.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import UIKit

public protocol Widget: AnyObject {
    func node(forContext context: WidgetRenderContext) -> LayoutNode
    func size(forContext context: WidgetRenderContext) -> CGSize
    var cellIdentifier: String { get }
}

public struct WidgetRenderContext: Hashable {
    public enum FlexDirection: Int {
        case none
        case vertical
        case horizontal
    }
    
    public let flexDirection: FlexDirection
    public let containerSize: CGSize
    
    public init(flexDirection: FlexDirection, containerSize: CGSize) {
        self.flexDirection = flexDirection
        self.containerSize = containerSize
    }
    
    public var layoutSize: CGSize {
        switch flexDirection {
        case .none:
            return containerSize
        case .vertical:
            return CGSize(width: containerSize.width, height: .nan)
        case .horizontal:
            return CGSize(width: .nan, height: containerSize.height)
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(flexDirection)
        hasher.combine(Int(containerSize.width))
        hasher.combine(Int(containerSize.height))
    }
}

public class WidgetView: UIView {
    public lazy var viewStorage = ViewStorage()
    
    private var widget: Widget?
    private var layoutNode: LayoutNode?
    private(set) var lastContext: WidgetRenderContext?

    public func setWidget(_ widget: Widget, withContext context: WidgetRenderContext) {
        removeWidget()
        
        let node = widget.node(forContext: context)
        if node.superView != nil {
            node.unbind(to: viewStorage)
        }
        node.layout(in: context.layoutSize)
        
        if subviews.count > 0 {
            fatalError()
        }
        
        node.bind(from: viewStorage, to: self)
        layoutNode = node
        self.widget = widget
        self.lastContext = context
    }
    
    public func removeWidget() {
        if let node = layoutNode,
           node.superView == self {
            node.unbind(to: viewStorage)
        }
        layoutNode = nil
        widget = nil
        lastContext = nil
    }
}
