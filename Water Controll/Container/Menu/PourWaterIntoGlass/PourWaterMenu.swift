//
//  PourWaterMenu.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 24.07.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit


extension MenuViewController {
    
    //create and add VolumeSubsettingsMenu
    func showPourWaterMenu() {
        
        guard  currentUser != nil else {
            print("current user is nil in func showPourWaterMenu")
            return
        }
        
        //bottle is empty
        if currentUser.isEmptyBottle {
                 noWaterIntoBottleAlertController()
                 return
             }
        
       // bottomMenuCollectionView.isUserInteractionEnabled = false
        bottomMenuCollectionView.isHidden = true
        pourWaterMenu = UIView()
        
        //setup full volume and volume type from data base
        
        isOzType = currentUser.volumeType == "oz"
        volumeTypeForPourWaterMenu = isOzType ? currentUser.volumeType : "ml"
        
        //add view in Settings View Controller
       view.addSubview(pourWaterMenu)
        setConstraintsForPourWaterMenu()
        addSubviewsIntoPourWaterMenu()
        setConstraintsAndOtherSetupsForSubviewsIntoPourWaterMenu()
        
        pickers = [unitPicker, tenthPicker, hundredPicker]
        if thousandPicker != nil {
            pickers.append(thousandPicker)
        }
        
        willPourWaterVolume = currentUser.middlePourWaterVolume
        setupPickersValue()
        
        cancelButtonInPourWaterMenu.addTarget(self, action: #selector(cancelActionInPourWaterMenu), for: .touchUpInside)
        
        pourWaterButton.addTarget(self, action: #selector(pourWaterButtonAction), for: .touchUpInside)

    }
    
    //delete and add VolumeSubsettingsMenu
    func deletePourWaterMenu() {
        
        self.pourWaterMenu.removeFromSuperview()
        self.pourWaterMenu = nil
        bottomMenuCollectionView.isUserInteractionEnabled = true
        bottomMenuCollectionView.isHidden = false
    }
    
    // add buttons in VolumeSubsettingsMenu
    func addSubviewsIntoPourWaterMenu() {
        
        //cancel button add
        cancelButtonInPourWaterMenu = UIButton()
        pourWaterMenu.addSubview(cancelButtonInPourWaterMenu)
        //ok button add
        pourWaterButton = UIButton()
        pourWaterMenu.addSubview(pourWaterButton)
        //volumeTypeLabelForPourWaterMenu
        volumeTypeLabelForPourWaterMenu = UILabel()
        pourWaterMenu.addSubview(volumeTypeLabelForPourWaterMenu)
        //unitPicker
        unitPicker = UIPickerView()
        pourWaterMenu.addSubview(unitPicker)
        unitPicker.delegate = self
        //tenthPicker
        tenthPicker = UIPickerView()
        pourWaterMenu.addSubview(tenthPicker)
        tenthPicker.delegate = self
        //hundredPicker
        hundredPicker = UIPickerView()
        pourWaterMenu.addSubview(hundredPicker)
        hundredPicker.delegate = self
        //thousandPicker
        if !isOzType {
            thousandPicker = UIPickerView()
            pourWaterMenu.addSubview(thousandPicker)
            thousandPicker.delegate = self
        } else {
            thousandPicker = nil
    }
        unitPicker.backgroundColor = .black
        tenthPicker.backgroundColor = .black
        hundredPicker.backgroundColor = .black
    }
    //constraints PourWaterMenu
    func setConstraintsForPourWaterMenu() {
        pourWaterMenu.translatesAutoresizingMaskIntoConstraints = false
        pourWaterMenu.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant:  2 * constraintConstant).isActive = true
        pourWaterMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2 * constraintConstant).isActive = true
        pourWaterMenu.bottomAnchor.constraint(equalTo: bottomMenuCollectionView.topAnchor, constant: -2 * constraintConstant).isActive = true
        pourWaterMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2 * constraintConstant).isActive = true
    }
    
    //subview`s constraints
    func setConstraintsAndOtherSetupsForSubviewsIntoPourWaterMenu() {
        //cancel button
        cancelButtonInPourWaterMenu.translatesAutoresizingMaskIntoConstraints = false
        cancelButtonInPourWaterMenu.leadingAnchor.constraint(equalTo: pourWaterMenu.leadingAnchor, constant: constraintConstant).isActive = true
        cancelButtonInPourWaterMenu.topAnchor.constraint(equalTo: pourWaterMenu.topAnchor, constant: constraintConstant).isActive = true
        cancelButtonInPourWaterMenu.widthAnchor.constraint(equalTo: pourWaterMenu.widthAnchor, multiplier: 0.15).isActive = true
        cancelButtonInPourWaterMenu.heightAnchor.constraint(equalTo: cancelButtonInPourWaterMenu.widthAnchor).isActive = true
        
        cancelButtonInPourWaterMenu.setImage(UIImage(named: "cancelButtonInBlueRing"), for: .normal)
        //pourWaterButton
        pourWaterButton.translatesAutoresizingMaskIntoConstraints = false
        pourWaterButton.trailingAnchor.constraint(equalTo: pourWaterMenu.trailingAnchor, constant: -constraintConstant).isActive = true
        pourWaterButton.topAnchor.constraint(equalTo: pourWaterMenu.topAnchor, constant: constraintConstant).isActive = true
        pourWaterButton.widthAnchor.constraint(equalTo: cancelButtonInPourWaterMenu.widthAnchor).isActive = true
        pourWaterButton.heightAnchor.constraint(equalTo: cancelButtonInPourWaterMenu.heightAnchor).isActive = true
        
        pourWaterButton.setImage(UIImage(named: "pourWaterFromGlass"), for: .normal)
        
        //volumeTypeLabelForPourWaterMenu
        volumeTypeLabelForPourWaterMenu.translatesAutoresizingMaskIntoConstraints = false
        volumeTypeLabelForPourWaterMenu.trailingAnchor.constraint(equalTo: pourWaterButton.leadingAnchor, constant: -constraintConstant).isActive = true
        volumeTypeLabelForPourWaterMenu.leadingAnchor.constraint(equalTo: cancelButtonInPourWaterMenu.trailingAnchor, constant: constraintConstant).isActive = true
        volumeTypeLabelForPourWaterMenu.topAnchor.constraint(equalTo: pourWaterMenu.topAnchor, constant: constraintConstant).isActive = true
        volumeTypeLabelForPourWaterMenu.heightAnchor.constraint(equalTo: cancelButtonInPourWaterMenu.heightAnchor).isActive = true
        // text settings volumeTypeLabelForPourWaterMenu
        volumeTypeLabelForPourWaterMenu.textAlignment = .center
        volumeTypeLabelForPourWaterMenu.font = UIFont(name: "AmericanTypewriter", size:  view.bounds.width * 12 / 100 )
        volumeTypeLabelForPourWaterMenu.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        volumeTypeLabelForPourWaterMenu.adjustsFontSizeToFitWidth = true
        volumeTypeLabelForPourWaterMenu.minimumScaleFactor = 0.2
        volumeTypeLabelForPourWaterMenu.text = volumeTypeForPourWaterMenu
       
        
        //pickers
        //picker width
        let pickerWidth = isOzType ? view.bounds.width * 0.7 / 3 : view.bounds.width * 0.7 / 4
        //first center X position
        let centerXPosition = isOzType ? (view.bounds.width - (4 * constraintConstant))  / 4 : (view.bounds.width - (4 * constraintConstant)) / 5
        print("pickerWidth: \(pickerWidth), centerXPosition: \(centerXPosition)")
        
        //thousandPicker
        if thousandPicker != nil {
            thousandPicker.translatesAutoresizingMaskIntoConstraints = false
            thousandPicker.topAnchor.constraint(equalTo: cancelButtonInPourWaterMenu.bottomAnchor, constant: constraintConstant).isActive = true
            thousandPicker.bottomAnchor.constraint(equalTo: pourWaterMenu.bottomAnchor, constant: -constraintConstant).isActive = true
            thousandPicker.widthAnchor.constraint(equalToConstant: pickerWidth).isActive = true
            thousandPicker.centerXAnchor.constraint(equalTo: pourWaterMenu.leadingAnchor, constant: centerXPosition).isActive = true
            
            thousandPicker.tag = 3
        }
        //hundredPicker
        hundredPicker.translatesAutoresizingMaskIntoConstraints = false
        hundredPicker.topAnchor.constraint(equalTo: cancelButtonInPourWaterMenu.bottomAnchor, constant: constraintConstant).isActive = true
        hundredPicker.bottomAnchor.constraint(equalTo: pourWaterMenu.bottomAnchor, constant: -constraintConstant).isActive = true
        hundredPicker.widthAnchor.constraint(equalToConstant: pickerWidth).isActive = true
        hundredPicker.centerXAnchor.constraint(equalTo: pourWaterMenu.leadingAnchor, constant: isOzType ? centerXPosition : centerXPosition * 2).isActive = true
        
        hundredPicker.tag = 2
        
        //tenthPicker
        tenthPicker.translatesAutoresizingMaskIntoConstraints = false
        tenthPicker.topAnchor.constraint(equalTo: cancelButtonInPourWaterMenu.bottomAnchor, constant: constraintConstant).isActive = true
        tenthPicker.bottomAnchor.constraint(equalTo: pourWaterMenu.bottomAnchor, constant: -constraintConstant).isActive = true
        tenthPicker.widthAnchor.constraint(equalToConstant: pickerWidth).isActive = true
        tenthPicker.centerXAnchor.constraint(equalTo: pourWaterMenu.leadingAnchor, constant: isOzType ? centerXPosition * 2 : centerXPosition * 3).isActive = true
        
        tenthPicker.tag = 1
        
        
        //tenthPicker
        unitPicker.translatesAutoresizingMaskIntoConstraints = false
        unitPicker.topAnchor.constraint(equalTo: cancelButtonInPourWaterMenu.bottomAnchor, constant: constraintConstant).isActive = true
        unitPicker.bottomAnchor.constraint(equalTo: pourWaterMenu.bottomAnchor, constant: -constraintConstant).isActive = true
        unitPicker.widthAnchor.constraint(equalToConstant: pickerWidth).isActive = true
        unitPicker.centerXAnchor.constraint(equalTo: pourWaterMenu.leadingAnchor, constant: isOzType ? centerXPosition * 3 : centerXPosition * 4).isActive = true
        
        unitPicker.tag = 0
    }

    
    private func setupPickersValue() {
        let middleWaterVolumeString = String(String(willPourWaterVolume).reversed())
        print(middleWaterVolumeString)
        for (itemNumber, picker) in pickers.enumerated() {
            if middleWaterVolumeString.count > itemNumber {
                let index = middleWaterVolumeString.index(middleWaterVolumeString.startIndex, offsetBy: itemNumber)
                let number = String(middleWaterVolumeString[index])
                picker.selectRow(Int(number) ?? 0, inComponent: 0, animated: true)
            } else {
                 picker.selectRow(0, inComponent: 0, animated: true)
            }
        }
        
        if isOzType {
            
        }
    }
    
    
    private func calculateCurrentVolumeInDecimal() -> Float {
       
        return Float(roundf(currentUser.currentVolumeInBottle / currentUser.fullVolume * 100) / 100)
    }

    //actions
    
    @objc func cancelActionInPourWaterMenu() {
        deletePourWaterMenu()
        //send currentWaterLevel as decimal in gameSceneController
         gameSceneController?.currentWaterLevel = calculateCurrentVolumeInDecimal()
    }
    
    @objc func  pourWaterButtonAction() {
        //save middlePourWaterVolume and current volume
    
        
        
        let drankWaterVolume = currentUser.volumeType == "oz" ? Float(willPourWaterVolume) : Float(round(100 * (Float(willPourWaterVolume) / 1000)) / 100)
        print("\(drankWaterVolume)")
        
        //change middle pour in 1 time volume
        currentUser.middlePourWaterVolume = willPourWaterVolume
        //change current volume (current voleme + drank water
        
        //currentUser.currentVolume = currentUser.fullVolume - currentUser.currentVolume >= drankWaterVolume ? Float(roundf((currentUser.currentVolume + drankWaterVolume) * 100) / 100) : currentUser.fullVolume
    
        currentUser.currentVolume = Float(roundf((currentUser.currentVolume + drankWaterVolume) * 100) / 100)
        
        currentUser.currentVolumeInBottle = currentUser.currentVolumeInBottle >= drankWaterVolume ? Float(roundf(( currentUser.currentVolumeInBottle - drankWaterVolume) * 100) / 100) : 0
        
        if currentUser.currentVolumeInBottle == 0 {
            currentUser.isEmptyBottle = true
            
        }
        
        //change text in label
       setupTextInPouredWaterLabel()
        
        //save context
        guard let containerViewController = self.parent as? ContainerViewController  else {
            print("can`t get ContainerViewController in  pourWaterButtonAction")
            return
        }
        
        containerViewController.saveContextInLocalDataBase()
        //save got waters for current user for graph, current data check automaticly
        containerViewController.addPourWaterData(wasPoured: drankWaterVolume, date: nil, user: currentUser)
        
    
            //delete
        deletePourWaterMenu()
        //set gameSceneController?.menuViewController if user isn`t single and if user drank not all water, so after animation we open Poure Water Menu Again
        if !isSinglUser && !currentUser.isEmptyBottle {
            gameSceneController?.typeAnimationComplitionFromMenuViewController = .openPourWaterIntoGlass
            gameSceneController?.menuViewController = self
            
        }
        // if isAutoFillBottleType and we have empty bottle
        if currentUser.isEmptyBottle && currentUser.isAutoFillBottleType {
            gameSceneController?.typeAnimationComplitionFromMenuViewController = .pourWaterIntoBottle
                       gameSceneController?.menuViewController = self
        }
        
             //send currentWaterLevel as decimal in gameSceneController
            gameSceneController?.currentWaterLevel = calculateCurrentVolumeInDecimal()
     
    }
    
    private func noWaterIntoBottleAlertController() {
      
        if alertControllerCustom != nil {
            alertControllerCustom?.clouseAlert()
        }
        
        alertControllerCustom = AlertControllerCustom()
        let textNoWaterInTheBottle = "There is no water in the bottle. You should fill the bottle!"
        guard alertControllerCustom != nil else { return }
        alertControllerCustom!.createAlert(observer: self, alertIdentifire: .noWaterInBottle, view: view, text: textNoWaterInTheBottle, imageName: nil, firstButtonText: "cancelSmallBlue", secondButtonText: "pourWaterIntoBottle", thirdButtonText: nil, imageInButtons: true)
        print("No water in bottle")
    }
}

