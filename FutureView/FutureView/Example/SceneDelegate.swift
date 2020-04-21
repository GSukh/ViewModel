//
//  SceneDelegate.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 15/02/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        if let windowScene = scene as? UIWindowScene {
//            let tableVC = ExampleController()
            let presenter = SimplePresenter()
            let vc = SimpleViewController(with: presenter)
//            let vc = TestCollectionViewController()
            let rootNC = UINavigationController(rootViewController: vc)

            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = rootNC
            window.makeKeyAndVisible()
            self.window = window
        }
    }
    
}

