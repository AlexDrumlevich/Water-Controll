//
//  MenuViewControllerExtentionGraph.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 24.09.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

enum GotWatersGetResults {
    case fail
    case success(NSMutableOrderedSet)
}
// graph menu
extension MenuViewController {
    
    // graph view include graph collection view
    //create graph view
    func  createGraphView() {
        // fill missed data in got water
        if let containerVC = self.parent as? ContainerViewController {
            containerVC.gotWaterFill()
        }
        
        graphView = UIView()
        graphView?.backgroundColor = .clear
        guard graphView != nil else { return }
        graphView!.layer.cornerRadius = 10
        graphView!.clipsToBounds = true
        // add bottomMenuCollectionView to MenuViewController
        view.addSubview(graphView!)
        // constraints for graphCollectionView
        graphView!.translatesAutoresizingMaskIntoConstraints = false
        graphView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        graphView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        graphView!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        graphView!.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: constraintConstant * 2).isActive = true
        //set content to bottom menu collection view
        createAddSubviewsIntoGraphView()
    }
    
    // delete graph view
    func deleteGraphView() {
        guard  graphView != nil else { return }
        graphView!.removeFromSuperview()
        graphView = nil
        gotWatersDataLinkToDelete = nil
        deleteGraphDataButton = nil
        graphCollectionView = nil
        cancelGraphViewButton = nil
        countDaysHistoryToDelete = nil
        countDeletDaysHistirySlider = nil
        deleletLabel = nil
    }
    

    // set subviews
    private func createAddSubviewsIntoGraphView() {
        
        //graph collection view
        
        let result = getGotWatersData()
        switch result {
        case .fail:
            deleteGraphView()
            return
        case .success(let gotWatersData):
            countDaysHistory = gotWatersData.count
            gotWatersDataLinkToDelete = gotWatersData
            
            //blur view
            blurViewForGraphView = UIVisualEffectView()
            let blurEffect = UIBlurEffect(style: .prominent)
            blurViewForGraphView!.effect = blurEffect
            graphView?.addSubview(blurViewForGraphView!)
            
            //collection view
            graphCollectionView = GraphCollectionView(data: gotWatersData, isFirstDayDateType: currentUser.volumeType != "oz")
            //add graph as subview
            graphView?.addSubview(graphCollectionView!)
            //create cancel button
            createCancelButton()
            //create delete grahp data button
            if countDaysHistory! > 1 {
                createDeleteGraphDataButton()
            }
            //setup constraints
            setupConstraintsOfSubviewIntoGraphView()
        }
       
    }
    
    // get GotWatersData
    private func getGotWatersData() -> GotWatersGetResults {
        
        guard let gotWatersData = currentUser.gotWaters?.mutableCopy() as? NSMutableOrderedSet else {
            deleteGraphView()
            return .fail
        }
        return .success(gotWatersData)
    }
    
    
    //create cancel button method
    private func createCancelButton() {
        cancelGraphViewButton = UIButton()
        if let imageButton = UIImage(named: "cancelSmallBlue") {
            cancelGraphViewButton?.setImage(imageButton, for: .normal)
        } else {
            cancelGraphViewButton?.setTitle("X", for: .normal)
        }
        //add target
        cancelGraphViewButton?.addTarget(self, action: #selector(cancelGraphView), for: .touchUpInside)
        //add cancel button
        graphView?.addSubview(cancelGraphViewButton!)
    }
    // cancel button action
    @objc func cancelGraphView() {
        if deleletLabel == nil {
            deleteGraphView()
        } else {
            cancelDeleteMenu()
        }
    }
    
    
    //create delete button method
    private func createDeleteGraphDataButton() {
        deleteGraphDataButton = UIButton()
        if let imageButton = UIImage(named: "deleteCommon") {
            deleteGraphDataButton?.setImage(imageButton, for: .normal)
        } else {
            deleteGraphDataButton?.setTitle("Delete", for: .normal)
        }
        //add target
        deleteGraphDataButton?.addTarget(self, action: #selector(deleteGraphDataButtonAction), for: .touchUpInside)
        //add button into view
        graphView?.addSubview(deleteGraphDataButton!)
    }
    // delete button action
    @objc func deleteGraphDataButtonAction() {
        //if we aren`t in delete menu
        if deleletLabel == nil {
            //open delete menu
            createDeleteMenu()
        } else {
            //create alert controller custom
            guard countDaysHistoryToDelete != nil else {
                cancelDeleteMenu()
                return
            }
            createAlertControllerCustomToConfirmDeleteGotWaterData(countOfDaysToDelete: countDaysHistoryToDelete!)
            //deleteGotWaterData()
        }
    }
    
    
    // create alert controller custom to confirm delete data
    private func createAlertControllerCustomToConfirmDeleteGotWaterData (countOfDaysToDelete: Int) {
        if alertControllerCustom != nil {
            alertControllerCustom?.clouseAlert()
        }
        
        
        let countDaysSring: String = (countOfDaysToDelete > 1 ? String(countOfDaysToDelete) + AppTexts.daysAppTexts : String(countOfDaysToDelete) + AppTexts.dayAppTexts)
        alertControllerCustom = AlertControllerCustom()
        let textConfirmDeleteGotWaterData = AppTexts.doYouReallyWantToDeleteTheFirstAppTexts + String(countDaysSring) + AppTexts.ofWaterConsumptionAppTexts
        guard alertControllerCustom != nil else { return }
        alertControllerCustom!.createAlert(observer: self, alertIdentifire: .deleteGotWaterData, view: view, text: textConfirmDeleteGotWaterData, imageName: nil, firstButtonText: "cancelSmallBlue", secondButtonText: "deleteCommon", thirdButtonText: nil, imageInButtons: true)
    }
    
    //constraints
    private func setupConstraintsOfSubviewIntoGraphView() {
       
        guard let superViewOfGraphCollectionView = graphCollectionView?.superview, graphCollectionView != nil, cancelGraphViewButton != nil, blurViewForGraphView != nil else {
            deleteGraphView()
            return
        }
        
        //blur view
        blurViewForGraphView!.translatesAutoresizingMaskIntoConstraints = false
        blurViewForGraphView!.leadingAnchor.constraint(equalTo: graphView!.leadingAnchor).isActive = true
        blurViewForGraphView!.topAnchor.constraint(equalTo: graphView!.topAnchor).isActive = true
        blurViewForGraphView!.trailingAnchor.constraint(equalTo: graphView!.trailingAnchor).isActive = true
        blurViewForGraphView!.bottomAnchor.constraint(equalTo: graphView!.bottomAnchor).isActive = true
        
        
        //cancel button constraints
        cancelGraphViewButton?.translatesAutoresizingMaskIntoConstraints = false
        cancelGraphViewButton?.widthAnchor.constraint(equalTo: superViewOfGraphCollectionView.widthAnchor, multiplier: 0.15).isActive = true
        cancelGraphViewButton!.heightAnchor.constraint(equalTo: superViewOfGraphCollectionView.widthAnchor, multiplier: 0.15).isActive = true
        //cancelGraphViewButton!.leadingAnchor.constraint(equalTo: superViewOfGraphCollectionView.leadingAnchor, constant: 5).isActive = true
        cancelGraphViewButton!.trailingAnchor.constraint(equalTo: superViewOfGraphCollectionView.trailingAnchor, constant:  -5).isActive = true
        cancelGraphViewButton!.topAnchor.constraint(equalTo: superViewOfGraphCollectionView.topAnchor, constant: 5).isActive = true
        
        //delete graph data button
        if deleteGraphDataButton != nil {
        deleteGraphDataButton!.translatesAutoresizingMaskIntoConstraints = false
        deleteGraphDataButton!.widthAnchor.constraint(equalTo: cancelGraphViewButton!.widthAnchor).isActive = true
        deleteGraphDataButton!.heightAnchor.constraint(equalTo: deleteGraphDataButton!.widthAnchor).isActive = true
        //cancelGraphViewButton!.leadingAnchor.constraint(equalTo: superViewOfGraphCollectionView.leadingAnchor, constant: 5).isActive = true
        deleteGraphDataButton!.trailingAnchor.constraint(equalTo: superViewOfGraphCollectionView.trailingAnchor, constant:  -5).isActive = true
            deleteGraphDataButton!.bottomAnchor.constraint(equalTo: superViewOfGraphCollectionView.bottomAnchor, constant: -20).isActive = true
        }
        //graph collection view constraints
        
        graphCollectionView!.leadingAnchor.constraint(equalTo: superViewOfGraphCollectionView.leadingAnchor, constant: constraintConstant).isActive = true
        graphCollectionView!.trailingAnchor.constraint(equalTo: cancelGraphViewButton!.leadingAnchor, constant: -5).isActive = true
        graphCollectionView!.bottomAnchor.constraint(equalTo: superViewOfGraphCollectionView.bottomAnchor).isActive = true
        graphCollectionView!.topAnchor.constraint(equalTo: superViewOfGraphCollectionView.topAnchor).isActive = true
        
    }
    

    //create delete menu
    private func createDeleteMenu() {
        graphCollectionView?.isHidden = true
        var needToCreateCountDeletDaysHistirySlider = false
        var labelDeleteGraphDataText = "Do you want to delete the entire history of water consumption?"
        if countDaysHistory != nil {
            labelDeleteGraphDataText = AppTexts.youHaveAppTexts + " \(String(countDaysHistory!)) "
            if countDaysHistory! > 2 {
                needToCreateCountDeletDaysHistirySlider = true
                labelDeleteGraphDataText += AppTexts.daysAppTexts + " " + AppTexts.ofWaterConsumptionHistoryAppTexts + "! " + AppTexts.doYouReallyWantToDeleteTheFirstAppTexts + " 1 " + AppTexts.dayAppTexts + " " + AppTexts.ofWaterConsumptionAppTexts
            } else {
                labelDeleteGraphDataText += AppTexts.dayAppTexts + " " + AppTexts.ofWaterConsumptionHistoryAppTexts + "! " + AppTexts.doYouWantToDeleteThisHistoryAppTexts + "?"
            }
            //start value to delete
            countDaysHistoryToDelete = 1
            deleletLabel?.text = labelDeleteGraphDataText
            createDeleteLabel(with: labelDeleteGraphDataText)
            if needToCreateCountDeletDaysHistirySlider {
                createCountDeletDaysHistirySlider(maxValue: countDaysHistory! - 1)
            }
            setConstraintsForDeleteGraphDataMenu()
        } else {
            cancelDeleteMenu()
        }
    }
    
    //cancel delete menu without delete data
    private func cancelDeleteMenu() {
        deleletLabel?.removeFromSuperview()
        deleletLabel = nil
        countDeletDaysHistirySlider?.removeFromSuperview()
        countDeletDaysHistirySlider = nil
        graphCollectionView?.isHidden = false
        
    }
    
    // func to delete data from data base
    func deleteGotWaterData() {
        
        guard countDaysHistoryToDelete != nil, countDaysHistory != nil, gotWatersDataLinkToDelete != nil, let containerVC = self.parent as? ContainerViewController else {
            cancelDeleteMenu()
            return
        }
        guard countDaysHistoryToDelete! < countDaysHistory! else {
            cancelDeleteMenu()
            return
        }
        
        
        for _ in 1...countDaysHistoryToDelete! {
            if gotWatersDataLinkToDelete?.count != 0 {
                gotWatersDataLinkToDelete?.removeObject(at: 0)
            }
        }
        currentUser.gotWaters = gotWatersDataLinkToDelete
        containerVC.saveContextInLocalDataBase()
        deleteGraphView()
        createGraphView()
        
    }
    
    //create delete label
    private func createDeleteLabel(with text: String) {
        
        guard graphView != nil else {
            return
        }
        deleletLabel = UILabel()
        graphView?.addSubview(deleletLabel!)
        let fontSize = graphView!.frame.width * 1/10
        deleletLabel?.text = text
        deleletLabel?.textAlignment = .center
        deleletLabel?.numberOfLines = 0
        deleletLabel?.adjustsFontSizeToFitWidth = true
        deleletLabel?.font = UIFont(name: "AmericanTypewriter", size:  fontSize)
        deleletLabel?.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        deleletLabel?.minimumScaleFactor = 0.1
    }
    
    //update text in label
    func updateTextDeleteLabel(valueOfDays: Int) {
        let dayText = valueOfDays == 1 ? AppTexts.dayAppTexts + " " : AppTexts.daysAppTexts + " " //" day " : " days "
        deleletLabel?.text = AppTexts.youHaveAppTexts + " \(String(countDaysHistory!))" + " " + AppTexts.daysAppTexts + " " + AppTexts.ofWaterConsumptionHistoryAppTexts + "! " + AppTexts.doYouReallyWantToDeleteTheFirstAppTexts + " \(valueOfDays)" + dayText + AppTexts.ofWaterConsumptionAppTexts//"of this history?"
    }
    
    //create delete days slider
    private func createCountDeletDaysHistirySlider(maxValue: Int) {
        countDeletDaysHistirySlider = UISlider()
        countDeletDaysHistirySlider?.maximumTrackTintColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        countDeletDaysHistirySlider?.minimumTrackTintColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        countDeletDaysHistirySlider?.minimumValue = 1
        countDeletDaysHistirySlider?.maximumValue = Float(maxValue)
        graphView?.addSubview(countDeletDaysHistirySlider!)
        countDeletDaysHistirySlider?.addTarget(self, action: #selector(countDeletDaysHistirySliderAction), for: .valueChanged)
    }
    //slider action
    @objc func countDeletDaysHistirySliderAction(sender: UISlider) {
        countDaysHistoryToDelete = Int(sender.value.rounded())
        guard countDaysHistoryToDelete != nil else {
            cancelDeleteMenu()
            return
        }
        updateTextDeleteLabel(valueOfDays: countDaysHistoryToDelete!)
    }
    
    //constraints for delete graph menu
    private func setConstraintsForDeleteGraphDataMenu() {
        guard let superView = deleletLabel?.superview, cancelGraphViewButton != nil else { return }
        //delete label constraints
        deleletLabel?.translatesAutoresizingMaskIntoConstraints = false
        deleletLabel?.heightAnchor.constraint(equalTo: superView.heightAnchor, multiplier: 2/3).isActive = true
        deleletLabel?.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 10).isActive = true
        deleletLabel?.trailingAnchor.constraint(equalTo: cancelGraphViewButton!.leadingAnchor, constant:  -10).isActive = true
        deleletLabel!.topAnchor.constraint(equalTo: superView.topAnchor, constant: 10).isActive = true
        
        guard  countDeletDaysHistirySlider != nil else {
            return
        }
        countDeletDaysHistirySlider?.translatesAutoresizingMaskIntoConstraints = false
        countDeletDaysHistirySlider?.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 10).isActive = true
        countDeletDaysHistirySlider?.trailingAnchor.constraint(equalTo: cancelGraphViewButton!.leadingAnchor, constant:  -10).isActive = true
        countDeletDaysHistirySlider?.topAnchor.constraint(equalTo: deleletLabel!.bottomAnchor, constant: 10).isActive = true
    }
    
}

