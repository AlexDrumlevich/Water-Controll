//
//  SettingsTableViewCell.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 25.05.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit


// setup cells in table view into Settings
class SettingsTableViewCell: UITableViewCell {
    
    static let cellID = "settingsTableViewCell"
    let constraintConstant: CGFloat = 5
    
    var textField: UITextField!
    var youNameLabel: UILabel!
    
    var volumeLabel: UILabel!
    var bottleImageView: UIImageView!
    var isAutoFillBottleLabelView: UILabel!
    
    var needToSetCornerRadius = false
    
    var lowCellHeight: CGFloat = 44
    //setup cells depending of type (SettingsViewControllerTableViewCellType) of cell
    func setupCell(with type: SettingsViewControllerTableViewCellType, cellIsHidden: Bool = false, lowCellHeight: CGFloat = 44) {
        
        self.selectionStyle = .none
        backgroundColor = .clear
        switch type {
        case .name:
            self.lowCellHeight = lowCellHeight
            setupNameCell()
            
        case .bottleSettings:
            setupBottleSettingsCell()
            
            
        case .notification:
            setupNotificationCell()
            
        case .isAutoFillWater:
            self.lowCellHeight = lowCellHeight
            if cellIsHidden {
                break
            } else {
            setupIsAutoFillWater()
            }
        case .deleteUser:
            setupDeleteUserCell()
         
        case .restorePurchases:
            self.lowCellHeight = lowCellHeight
            if cellIsHidden {
                break
            } else {
            setupLabelOnlyCells(labelText: AppTexts.restorePurchasesAppTexts)
            }
        case .rateTheApp:
            self.lowCellHeight = lowCellHeight
            setupLabelOnlyCells(labelText: AppTexts.rateTheAppAppTexts)
        case .shareTheApp:
            self.lowCellHeight = lowCellHeight
            setupLabelOnlyCells(labelText: AppTexts.shareTheAppAppTexts)
        }
    }
    
    
    
    // setup text fild for name in cell
    private func setupNameCell () {
         textField = UITextField()
        let textFildHeight = (lowCellHeight - (constraintConstant * 2))
       
        //text settings
       
        textField.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        textField.textAlignment = .center
        textField.backgroundColor = .clear
        textField.font = UIFont(name: "AmericanTypewriter", size:  textFildHeight * 0.3)
        textField.minimumFontSize = 0.3
        textField.adjustsFontForContentSizeCategory = true
        textField.returnKeyType = UIReturnKeyType.done
        //add text field into cell
        contentView.addSubview(textField)
        //setup constraints
        setupConstraints(subView: textField)
        //corner radius
        textField.layer.cornerRadius = textFildHeight / 2
        textField.layer.borderWidth = 3
        textField.layer.borderColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        textField.clipsToBounds = true
        needToSetCornerRadius = true
        
        youNameLabel = UILabel()
        youNameLabel.text = AppTexts.nameAppTexts
        youNameLabel.textColor = .gray
        youNameLabel.backgroundColor = .clear
        youNameLabel.alpha = 0.5
        youNameLabel.font = UIFont(name: "AmericanTypewriter", size:  textFildHeight * 0.7)
        youNameLabel.textAlignment = .center
        youNameLabel.minimumScaleFactor = 0.5
        youNameLabel.isHidden = true
        addSubview(youNameLabel)
        setupConstraints(subView: youNameLabel)
        
    }
    
    private func setupLabelOnlyCells(labelText: String) {
       
        let label = UILabel()
        let lableHeight = (lowCellHeight - (constraintConstant * 2))
       
       //text settings

        label.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = UIFont(name: "AmericanTypewriter", size:  lableHeight * 0.3)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
//        label.sizeToFit()
        label.text = labelText
        
      
       label.layer.cornerRadius = lableHeight / 2
       label.layer.borderWidth = 3
       label.layer.borderColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
       label.clipsToBounds = true
        needToSetCornerRadius = true
        //add text field into cell
        contentView.addSubview(label)
        //setup constraints
        setupConstraints(subView: label)
     
    }
    
    // setup image for bottleVolume question
    private func setupBottleSettingsCell() {
        bottleImageView = UIImageView()
        bottleImageView.image = UIImage(named: "bottleVolume")
        addSubview(bottleImageView)
        setupConstraints(subView: bottleImageView)
        
        volumeLabel = UILabel()
        setLabel(label: volumeLabel, leftPartView: bottleImageView)
    }
    
    
    // setup image for notifications
    private func setupNotificationCell () {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "notification")
        addSubview(imageView)
        setupConstraints(subView: imageView)
        
        let label = UILabel()
        setLabel(label: label, text: AppTexts.notificationsAppTexts, leftPartView: imageView)
    }
    
    
    
    
    //setup IsAutoFillWater
    private func setupIsAutoFillWater() {
        // puer water into bottle image
        let puerWaterIntoBottleImageView = UIImageView()
        puerWaterIntoBottleImageView.image = UIImage(named: "pourWaterIntoBottle")
        addSubview(puerWaterIntoBottleImageView)
        setupConstraints(subView: puerWaterIntoBottleImageView)
        
        
        isAutoFillBottleLabelView = UILabel()
        
        setLabel(label: isAutoFillBottleLabelView, leftPartView: puerWaterIntoBottleImageView)
       
    }
    
    
    
    // setup image for deleteUserCell
    private func setupDeleteUserCell () {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "delete")
        addSubview(imageView)
        setupConstraints(subView: imageView)
        
        let label = UILabel()
        setLabel(label: label, text: AppTexts.deleteUserAppTexts, leftPartView: imageView, textColor: .red, isMultyString: true)
        
    }
    
    
    private func setLabel(label: UILabel, text: String = "", leftPartView: UIView, textColor: UIColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1), isMultyString: Bool = false) {
        let lableHeight = (bounds.height - (constraintConstant * 2)) * 0.8
        label.text = text
        if isMultyString {
            label.numberOfLines = 0
        }
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = UIFont(name: "AmericanTypewriter", size:  lableHeight)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.05
        label.sizeToFit()
        label.textColor = textColor
        addSubview(label)
        setupConstraintsForTheRightPart(subView: label, leftPartView: leftPartView)
        
    }
    
    private func setupConstraints(subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        
        
        subView.topAnchor.constraint(equalTo: topAnchor, constant: constraintConstant).isActive = true
        subView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -constraintConstant).isActive = true
        
        if subView is UITextField || subView is UILabel {
            subView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constraintConstant).isActive = true
            subView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constraintConstant).isActive = true
        } else {
            //one object like a cube in the middle of cell
            subView.leadingAnchor.constraint(equalTo: leadingAnchor, constant:  constraintConstant).isActive = true
            subView.widthAnchor.constraint(equalTo: subView.heightAnchor).isActive = true
            
        }
        
    }
    
    private func setupConstraintsForTheRightPart(subView: UIView, leftPartView: UIView) {
        
        subView.translatesAutoresizingMaskIntoConstraints = false
        subView.topAnchor.constraint(equalTo: topAnchor, constant: constraintConstant).isActive = true
        subView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constraintConstant * 2).isActive = true
        subView.leadingAnchor.constraint(equalTo: leftPartView.trailingAnchor).isActive = true
        subView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -constraintConstant).isActive = true
    }
    
}


