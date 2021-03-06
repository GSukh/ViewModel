//
//  Presenter.swift
//  ViewModel
//
//  Created by Григорий Сухоруков on 24/03/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import Foundation
import UIKit

/*
 У элементов модуля должены быть только output протоколы
 Стрелки только влево на схеме Model <- Presenter <- View
 */

/*
 Не должен уметь работать с UIView
 Не должен уметь работать с UIViewController
 Может работать с ViewModel
 В сабклассах можно избегать работы с ViewController, работая ТОЛЬКО с ViewModel
 
 Input: выполнение протокола модели
 
 Output: ипользование протокола вью контроллера
 -bindViewModel: ViewModel
 
 
 */

protocol NavigationPerformer: NSObjectProtocol {
    func supportPresentationStyle(_ presentationStyle: PresentationStyle) -> Bool
    
    func push(_ viewController: UIViewController, animated: Bool)
    func present(_ viewController: UIViewController, animated: Bool)

    func dismiss()
}


protocol PresenterOutput: NSObjectProtocol {
//    // Когда нужно полностью снести старую модель
//    func presenter(_ presenter: Presenter, didChangedViewModel viewModel: ViewModel)
//
//    // Когда нужно обновить мадель (к примеру после изменений в Вью)
//    func presenter(_ presenter: Presenter, shouldRelayoutViewModel viewModel: ViewModel)
}

class Presenter: NSObject {
    
    //    private(set) var lastViewContext: ViewContext?
    private(set) weak var navigationPerformer: NavigationPerformer!
    private(set) weak var outputDelegate: PresenterOutput!
    
    func activate(with navigationPerformer: NavigationPerformer) {
        self.navigationPerformer = navigationPerformer
        
        // activate model to load smth
    }
    
    
    // презентер не должен ничего знать о изменении размеров вью?
    // тогда как презентер сможет сделать пререндеринг?
    // но должен ли он заниматься пререндерингом?
    //
    // мы можем представить много ситуаций, в которых размер и ориентация вью будет влиять на логику работы экрана
//    func containerSizeDidChanged(_ containerSize: CGSize) {
//        viewModel.layout(with: containerSize)
//    }
    
//    func viewContextDidChanged(_ viewContext: ViewContext) {
//        var shouldRelayout = true
//        if let lastViewContext = lastViewContext {
//            let widthChanged = !lastViewContext.size.width.isEqual(to: viewContext.size.width)
//            let heightChanged = !lastViewContext.size.height.isEqual(to: viewContext.size.height)
//            let orientationChanged = lastViewContext.orientation == viewContext.orientation
//            shouldRelayout = widthChanged || heightChanged || orientationChanged
//        }
//
//        guard shouldRelayout else { return }
//
//        layoutViewModel()
////        outputDelegate.presenter(self, didChangedViewModel: viewModel)
//    }
    
}

extension Presenter: Router {
    func route(_ routable: Routable) -> Bool {
        let prefferedPresentationStyle = routable.prefferedPresentationStyle()
        return route(routable, presentationStyle: prefferedPresentationStyle)
    }
    
    func route(_ routable: Routable, presentationStyle: PresentationStyle) -> Bool {
        guard navigationPerformer.supportPresentationStyle(presentationStyle) else {
            print("Unsupported navigation style")
            return false
        }
        let viewController = spawnViewController(forRoutable: routable)

        switch presentationStyle {
        case .push(let animated): navigationPerformer.push(viewController, animated: animated)
        case .modal(let animated): navigationPerformer.present(viewController, animated: animated)
        }
        
        return true
    }
    
    func spawnViewController(forRoutable routable: Routable) -> UIViewController {
        return routable.viewController()
    }
}

