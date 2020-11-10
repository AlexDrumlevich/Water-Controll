//
//  GraphCollectionViewDelegates.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 23.09.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

extension GraphCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let numberForItems = gotWatersData?.count else {
            return 0
        }

        return numberForItems
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = dequeueReusableCell(withReuseIdentifier: GraphCollectionViewCell.cellIdentifire, for: indexPath) as! GraphCollectionViewCell
        
        guard let gotWaters = gotWatersData else { return cell }
        guard gotWaters.count > indexPath.row else { return cell }
        guard let gotWater = gotWaters[indexPath.row] as? GotWater else { return cell }
        
   
        
        var dateInCell = "--.--.--"
        let calendar = Calendar.current
      
        if let date = gotWater.data {
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
            if isFirstDayDateType {
                dateInCell = String(day) + "." + String(month) + "." + String(year)
            } else {
                dateInCell = String(month) + "." + String(day) + "." + String(year)
            }
        }
        
        cell.date = dateInCell
        cell.volume = gotWater.volumeGet
        cell.targetVolume = gotWater.volumeTarget
        
        let volumeTypeComplitely = gotWater.isOzType ? " oz" : " L"
        cell.volumeType = volumeTypeComplitely
        
        cell.setupCell()
        
        if !isSetLastPosition {
            setLastPosition()
            isSetLastPosition = true
        }
        
        return cell
    }
    
    
    
    
    //MARK: UICollectionViewDelegateFlowLayout
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.width / 6, height: bounds.height * 0.9)
    }
    
}
