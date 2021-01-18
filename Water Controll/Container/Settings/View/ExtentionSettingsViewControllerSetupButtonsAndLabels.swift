//
//  ExtentionSettingsViewControllerSetupUI.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 25.05.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

extension SettingsViewController {
    
    
    
    func addViews() {
         view.addSubview(blurView)
         blurView.contentView.addSubview(backButton)
         blurView.contentView.addSubview(plusButton)
         blurView.contentView.addSubview(rightButton)
         blurView.contentView.addSubview(leftButton)
         blurView.contentView.addSubview(nameLabel)
         blurView.contentView.addSubview(cancelButton)
         blurView.contentView.addSubview(okButton)
         blurView.contentView.addSubview(deleteButton)
        
    }
    
    
    //add blurView setup constraints and effects for blurView
    func setupBlurView() {
     
        blurView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        let blurEffect = UIBlurEffect(style: .regular)
        blurView.effect = blurEffect
        
    }
    
    //add backButton setup constraints for backButton
    func setupBackButton()  {
       
        backButton.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 10).isActive = true
        backButton.topAnchor.constraint(equalTo: blurView.topAnchor, constant:  30).isActive = true
        
        backButton.widthAnchor.constraint(equalTo: blurView.widthAnchor, multiplier: 0.12).isActive = true
        backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor).isActive = true
    }
    
    //add plusButton setup constraints for plusButton
    func setupPlusButton()  {
        
        //font
        
        var fontSize = view.frame.height * 1/35
        if fontSize == 0 {
           fontSize = UIScreen.main.bounds.height * 1/35
        }
        var font = UIFont(name: "AmericanTypewriter", size: fontSize)
        if font == nil {
            font = UIFont.systemFont(ofSize: fontSize)
        }
    
        plusButton.titleLabel?.adjustsFontSizeToFitWidth = true
        plusButton.titleLabel?.minimumScaleFactor = 0.1
        
        let titleAttributesNormalState: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: font!, NSAttributedString.Key.foregroundColor: UIColor.blue
        ]
        let titleAttributesAssignState: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: font!, NSAttributedString.Key.foregroundColor: UIColor.purple
        ]
        
        let text = AppTexts.addUserAppTexts
        let attributedStringNormal = NSMutableAttributedString(string: text, attributes: titleAttributesNormalState)
        let attributedStringAssigne = NSMutableAttributedString(string: text, attributes: titleAttributesAssignState)
        plusButton.setAttributedTitle(attributedStringNormal, for: .normal)
        plusButton.setAttributedTitle(attributedStringAssigne, for: .highlighted)
    
       //constraints
        plusButton.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -10).isActive = true
        plusButton.topAnchor.constraint(equalTo: blurView.topAnchor, constant:  30).isActive = true
        plusButton.widthAnchor.constraint(equalTo: blurView.widthAnchor, multiplier: 0.3).isActive = true
        plusButton.heightAnchor.constraint(equalTo: blurView.widthAnchor, multiplier: 0.12).isActive = true
    }
     
    //setup constraints for nameLabel
       func setupNameLabel() {
    
           //set constraints
           nameLabel.centerXAnchor.constraint(equalTo: blurView.centerXAnchor).isActive = true
           nameLabel.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 10).isActive = true
           nameLabel.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor, constant: constraintConstant).isActive = true
           nameLabel.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor, constant: -constraintConstant).isActive = true
           
           nameLabel.heightAnchor.constraint(equalTo: blurView.widthAnchor, multiplier: 0.12).isActive = true
           //set text settings
           nameLabel.textAlignment = .center
           nameLabel.font = UIFont(name: "AmericanTypewriter", size:  view.bounds.width * 12 / 100 )
           nameLabel.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        nameLabel.adjustsFontSizeToFitWidth = true
           nameLabel.minimumScaleFactor = 0.5
           
       }
       
    
    
    //add right button into blurView and set constraints
    func setupRightButton() {

        //set constraints
        rightButton.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -constraintConstant).isActive = true
        rightButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 1 / 10).isActive = true
    rightButton.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 10).isActive = true
        rightButton.heightAnchor.constraint(equalTo: nameLabel.heightAnchor, multiplier: 0.7).isActive = true
        
    }
    
    //add left button into blurView and set constraints
    func setupLeftButton() {

        //set constraints
        leftButton.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: constraintConstant).isActive = true
        leftButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 1 / 10).isActive = true
        leftButton.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 10).isActive = true
        leftButton.heightAnchor.constraint(equalTo: nameLabel.heightAnchor, multiplier: 0.7).isActive = true
    }
    
    
    
  
    
    
    //add cancelButton setup constraints for cancelButton
    func setupCancelButton()  {
  
        cancelButton.widthAnchor.constraint(equalTo: blurView.widthAnchor, multiplier: 0.12).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: blurView.widthAnchor, multiplier: 0.12).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: blurView.centerXAnchor, constant: -view.bounds.width * 24 / 100 ).isActive = true
        bottomCancelButtonConstraint = cancelButton.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant:  -30)
        bottomCancelButtonConstraint.isActive = true
    }
    
    
    //add okButton setup constraints for okButton
    func setupOkButton()  {
     
        okButton.widthAnchor.constraint(equalTo: blurView.widthAnchor, multiplier: 0.12).isActive = true
        okButton.heightAnchor.constraint(equalTo: blurView.widthAnchor, multiplier: 0.12).isActive = true
        okButton.centerXAnchor.constraint(equalTo: blurView.centerXAnchor, constant: view.bounds.width * 24 / 100 ).isActive = true
        bottomOkButtonConstraint = okButton.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant:  -30)
        bottomOkButtonConstraint.isActive = true
        
    }
    
    //add deleteButton setup constraints for deleteButton
    func setupDeleteButton()  {
      
        deleteButton.widthAnchor.constraint(equalTo: blurView.widthAnchor, multiplier: 0.14).isActive = true
        deleteButton.heightAnchor.constraint(equalTo: blurView.widthAnchor, multiplier: 0.14).isActive = true
        deleteButton.centerXAnchor.constraint(equalTo: blurView.centerXAnchor).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant:  -30).isActive = true
        
    }
    
    
    
    //func for hide or show buttons
    func hiddenButtons(buttons: [UIButton], isHidden: Bool) {
        for button in buttons {
            button.isHidden = isHidden
        }
    }
    
    //func for enable or disable buttons
    func buttonsEnable(buttons: [UIButton], isEnable: Bool) {
        for button in buttons {
            button.isEnabled = isEnable
            button.alpha = isEnable ? 1 : 0.5
        }
    }
    
    
}
