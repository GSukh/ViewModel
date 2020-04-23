//
//  Router.swift
//  ViewModel
//
//  Created by Григорий Сухоруков on 23/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

enum PresentationStyle {
    case push(Bool)
    case modal(Bool)
}

protocol Routable {
    func viewController() -> UIViewController
    func prefferedPresentationStyle() -> PresentationStyle
}

protocol Router: NSObjectProtocol {
    @discardableResult func route(_ routable: Routable) -> Bool
    @discardableResult func route(_ routable: Routable, presentationStyle: PresentationStyle) -> Bool
}
