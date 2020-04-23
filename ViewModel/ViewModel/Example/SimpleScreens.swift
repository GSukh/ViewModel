//
//  SimpleScreens.swift
//  ViewModel
//
//  Created by Григорий Сухоруков on 23/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

enum SimpleScreens: Routable {
    case main
    case friend(String)
    
    func viewController() -> UIViewController {
        switch self {
        case .main:
            let presenter = SimplePresenter()
            return SimpleViewController(with: presenter)

        case .friend(let title):
            let presenter = FriendPresenter()
            let vc = FriendViewController(with: presenter)
            vc.title = title
            return vc
        }
    }
    
    func prefferedPresentationStyle() -> PresentationStyle {
        return .push(true)
    }
    
}
