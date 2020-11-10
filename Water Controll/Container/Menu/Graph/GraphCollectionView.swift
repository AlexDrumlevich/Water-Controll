//
//  GraphCollectionView.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 23.09.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit



class GraphCollectionView: UICollectionView {
    
    var gotWatersData: NSMutableOrderedSet!
    var isFirstDayDateType: Bool!
    //flag - we set end position in delegate`s metod cell for row at when the method colled 1-st time and then we change this flag
    var isSetLastPosition = false
    
    
    init(data: NSMutableOrderedSet, isFirstDayDateType: Bool) {
        gotWatersData = data
        self.isFirstDayDateType = isFirstDayDateType
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor = .clear
        delegate = self
        dataSource = self
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = true
        showsHorizontalScrollIndicator = true
        
        register(GraphCollectionViewCell.self, forCellWithReuseIdentifier: GraphCollectionViewCell.cellIdentifire)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // set position - call in delegate
    func setLastPosition() {
        self.scrollToItem(at: IndexPath(item: self.gotWatersData.count - 1, section: 0), at: .right, animated: false)
    }
}
