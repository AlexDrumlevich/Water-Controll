//
//  BottomMenuCollectionView.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 23.05.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

class BottomMenuCollectionView: UICollectionView {

    //complition for present SettingsViewController from ContainerViewController
    var complitionBottomMenuActions: ((BottomMenuModelIdentifire) -> Void)!
    var complitionPourWaterIntoBottleAccess: ((UILabel) -> Void)!
    
    var menuModel = [BottomMenuModel]()
    
     init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor = .clear
        delegate = self
        dataSource = self
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        register(BottomMenuCollectionViewCell.self, forCellWithReuseIdentifier: BottomMenuCollectionViewCell.cellIdentifire)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //fill arrey of menuModel
    func getMenuModel(menuModel: [BottomMenuModel] ) {
        self.menuModel = menuModel
    }
    
    

}


//MARK: UICollectionViewDelegate
extension BottomMenuCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //close alerts
        complitionBottomMenuActions(.closeCustomAlerts)
        
        switch menuModel[indexPath.row].identifire {
        case .pourWaterIntoGlass:
            complitionBottomMenuActions(.pourWaterIntoGlass)
        case .pourWaterIntoBottle:
            complitionBottomMenuActions(.pourWaterIntoBottle)
        case .notification:
             complitionBottomMenuActions(.notification)
        case .graph:
            complitionBottomMenuActions(.graph)
        case .settings:
            complitionBottomMenuActions(.settings)
        case  .getOneMoreBottleInBottomMenu:
            complitionBottomMenuActions(.getOneMoreBottleInBottomMenu)
        case .closeCustomAlerts:
            break
        case .adsSettings:
            complitionBottomMenuActions(.adsSettings)
        }
        
    }
}

//MARK: UICollectionViewDataSource
extension BottomMenuCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        menuModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: BottomMenuCollectionViewCell.cellIdentifire, for: indexPath) as! BottomMenuCollectionViewCell
        //hide label
        cell.countLabel.isHidden = true
        
        if menuModel[indexPath.row].image != nil {
        cell.imageView.image = menuModel[indexPath.row].image!
            
            //send label from pour water into bottle cell
            if menuModel[indexPath.row].identifire.rawValue == BottomMenuModelIdentifire.pourWaterIntoBottle.rawValue {
                
                complitionPourWaterIntoBottleAccess(cell.countLabel)
            }
        }
        
        return cell
    }
}





//MARK: UICollectionViewDelegateFlowLayout
extension BottomMenuCollectionView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (bounds.width / 4) - 10 , height: (bounds.width / 4) - 10 )
    }
}

