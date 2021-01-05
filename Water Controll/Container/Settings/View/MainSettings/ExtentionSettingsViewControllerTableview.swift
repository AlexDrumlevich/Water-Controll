//
//  ExtentionSettingsViewControllerSetupTableview.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 25.05.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

//addAndConfigureTableView into blur view
extension SettingsViewController {
    
    
    func addAndConfigureTableView(isHidden: Bool = false) {
        
        tableViewMainSettings = UITableView()
        tableViewMainSettings.isHidden = isHidden
        tableViewMainSettings.tag = 0
        tableViewMainSettings.delegate = self
        tableViewMainSettings.dataSource = self
        //register cell
        tableViewMainSettings.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.cellID)
        //add tableView into blur view
        blurView.contentView.addSubview(tableViewMainSettings)
        
    
        //with out lines betveen cells
        tableViewMainSettings.separatorStyle = .singleLine
        tableViewMainSettings.separatorColor = #colorLiteral(red: 0.1640408039, green: 0.2041007578, blue: 1, alpha: 1)
        //фон для tableView
        tableViewMainSettings.backgroundColor = UIColor(displayP3Red: 248, green: 248, blue: 255, alpha: 0.4)
        tableViewMainSettings.layer.cornerRadius = 10
        tableViewMainSettings.clipsToBounds = true
    }
    
    func setupConstraintsForTableViewMainSettings() {
    //setup constraints
    tableViewMainSettings.translatesAutoresizingMaskIntoConstraints = false
  tableViewMainSettings.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20).isActive = true
   tableViewMainSettings.bottomAnchor.constraint(equalTo: okButton.topAnchor, constant: -20).isActive = true
    tableViewMainSettings.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 10).isActive = true
    tableViewMainSettings.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -10).isActive = true
    
    }
    

    
    
    
    func setupVolumeBottleCell() {
        if currentUser.volumeType != nil {
            volumeBottleImageView.image = currentUser.volumeType == "oz" ? UIImage(named: "bottleOzVolume") : UIImage(named: "bottleLiterVolume")
            
            volumeLabel.text = currentUser.volumeType == "oz" ?  String(Int(currentUser.fullVolume)) : String(currentUser.fullVolume)
           
        }
    }
    
    func setupIsAutoFillBottleCell() {
        guard isAutoFillBottleTypeLabel != nil else { return }
             isAutoFillBottleTypeLabel.text = currentUser.isAutoFillBottleType ? "auto" : "manually"
            
     }
}

