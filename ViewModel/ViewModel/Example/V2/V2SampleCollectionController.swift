//
//  V2SampleCollectionController.swift
//  ViewModel
//
//  Created by Grigoriy Sukhorukov on 17.08.2021.
//  Copyright © 2021 Григорий Сухоруков. All rights reserved.
//

import UIKit
import YogaUI

class V2SampleCollectionController: UIViewController {
    
    static let htmlSamples: [String] = [
        "<ul><li>Morbi in sem quis dui placerat ornare. Pellentesque odio nisi, euismod in, pharetra a, ultricies in, diam. Sed arcu. Cras consequat.</li><li>Praesent dapibus, neque id cursus faucibus, tortor neque egestas augue, eu vulputate magna eros eu erat. Aliquam erat volutpat. Nam dui mi, tincidunt quis, accumsan porttitor, facilisis luctus, metus.</li><li>Phasellus ultrices nulla quis nibh. Quisque a lectus. Donec consectetuer ligula vulputate sem tristique cursus. Nam nulla quam, gravida non, commodo a, sodales sit amet, nisi.</li><li>Pellentesque fermentum dolor. Aliquam quam lectus, facilisis auctor, ultrices ut, elementum vulputate, nunc.</li></ul>",
        "<dl><dt>Definition list</dt><dd>Consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</dd><dt>Lorem ipsum dolor sit amet</dt><dd>Consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</dd></dl>"
    ]
    
    lazy var widgets: [Widget] = {
        var result = [Widget]()
        for htmlSample in Self.htmlSamples {
            result.append(HTMLSampleWidget(htmlString: htmlSample))
        }
        for _ in 0...100 {
            result.append(SampleWidget())
        }
        return result
    }()
    static var cellReuseIdentifier = "cellReuseIdentifier"
    private var widgetRenderContext = WidgetRenderContext(flexDirection: .vertical, containerSize: .zero)
    
    private let viewStorage = ViewStorage()
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(WidgetCollectionCell.self, forCellWithReuseIdentifier: Self.cellReuseIdentifier)
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let collectionFrame = view.bounds.inset(by: view.safeAreaInsets)
        widgetRenderContext = WidgetRenderContext(flexDirection: .vertical, containerSize: collectionFrame.size)
        collectionView.frame = collectionFrame
    }
}

extension V2SampleCollectionController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return widgets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.cellReuseIdentifier, for: indexPath) as! WidgetCollectionCell
        
        cell.widgetView.viewStorage = viewStorage
        cell.widgetView.setWidget(widgets[indexPath.item], withContext: widgetRenderContext)
        
        return cell
    }
}

extension V2SampleCollectionController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widget = widgets[indexPath.item]
        let size = widget.size(forContext: widgetRenderContext)
        return size
    }

}
