//
//  TestCollectionViewController.swift
//  FutureView
//
//  Created by Григорий Сухоруков on 09/04/2020.
//  Copyright © 2020 Григорий Сухоруков. All rights reserved.
//

import UIKit

//class GridCollectionView: UICollectionView {
//    private var gridDataSource
//    var dataSource: CollectionViewLayout2000DataSource?
//}

class TestCollectionViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    let sections = 3
    let items = [5, 7, 10]
    var layoutPatterns: [SectionLayoutPattern2000]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let pattern1 = SectionLayoutPattern2000()
        pattern1.numberOfColumns = 4
        pattern1.itemHeight = 80
        pattern1.itemMargin = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        pattern1.sectionPadding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let pattern2 = SectionLayoutPattern2000()
        pattern2.numberOfColumns = 2
        pattern2.itemHeight = 60
        pattern2.itemMargin = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        pattern2.sectionPadding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let pattern3 = SectionLayoutPattern2000()
        pattern3.numberOfColumns = 1
        pattern3.itemHeight = 80
        pattern3.itemMargin = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        pattern3.sectionPadding = UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12)

        layoutPatterns = [pattern1, pattern2, pattern3]
        
        let collectionViewLayout = CollectionViewLayout2000()
        collectionViewLayout.dataSource = self
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1234567890")
        collectionView.backgroundColor = .yellow
        view.addSubview(collectionView)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.bounds
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TestCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section]
    }

    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1234567890", for: indexPath)
        cell.backgroundColor = .green
        return cell
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections
    }
}

extension TestCollectionViewController: CollectionViewLayout2000DataSource {
    
    func collectionView(_ collectionView: UICollectionView, layoutPatternForSection section: Int) -> SectionLayout {
        return layoutPatterns[section]
    }
}
