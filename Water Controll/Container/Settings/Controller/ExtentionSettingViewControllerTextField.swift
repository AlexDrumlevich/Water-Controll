//
//  ExtentionKeyBoardControl.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 08.06.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

extension SettingsViewController {
    //notification by keybord
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboarShowHide(notification: )),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboarShowHide(notification: )),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboarShowHide(notification: Notification) {
        
        //get size of keyboard
        guard
            let userInfo = notification.userInfo as? [String: Any],
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        //if keyboard is showen
        if notification.name == UIResponder.keyboardWillShowNotification {
            //change constraints
            
            bottomOkButtonConstraint.isActive = false
            bottomOkButtonConstraint.constant =  -keyboardFrame.height - 5
            bottomOkButtonConstraint.isActive = true
            
            bottomCancelButtonConstraint.isActive = false
            bottomCancelButtonConstraint.constant = -keyboardFrame.height - 5
            bottomCancelButtonConstraint.isActive = true
            
            //show buttons ok and cancel
            if settingsMode != .firstUser {
                hiddenButtons(buttons: [okButton, cancelButton], isHidden: false)
            } else {
                hiddenButtons(buttons: [okButton], isHidden: false)
            }
            //set marker
            isKeyboardHidden = false
            
        } else {
            //if keyboard is hidden
            bottomOkButtonConstraint.isActive = false
            bottomOkButtonConstraint.constant = -30
            bottomOkButtonConstraint.isActive = true
            
            
            bottomCancelButtonConstraint.isActive = false
            bottomCancelButtonConstraint.constant = -30
            bottomCancelButtonConstraint.isActive = true
            
            //hide buttons
            hiddenButtons(buttons: [okButton, cancelButton], isHidden: true)
            //set marker
            isKeyboardHidden = true
        }
    }
    
    
    
    
    //MARK: TEXT field actions
    //nameTextFieldChanged ACTIONS
    //action when name text field changed from ExtentionSettingsViewControllerTableview.swift
    @objc func nameTextFieldChanged() {
        
        //check to nil
        guard var name = nameTextField.text else { return }
        if name == " " {
            nameTextField.text = ""
            name = ""
        }
        nameLabel.text = name
        // we hidden label "Name" in text field if we don t have user`s name (name is "") or we don`t have text in text field
        youNameLabelInCell.isHidden = !name.isEmpty || !currentUser.name!.isEmpty
        //disable ok button when text field is empty
        buttonsEnable(buttons: [okButton], isEnable: !name.isEmpty)
    }
    
    // begin editing
    @objc func nameTextFieldBeginEditing() {
        tableViewMainSettings.isScrollEnabled = false
        if settingsMode == .firstUser || settingsMode == .newUser {
            nameTextField.text = nameLabel.text ?? ""
            youNameLabelInCell.isHidden = !nameTextField.text!.isEmpty
        } else {
            nameTextField.text = currentUser.name
        }
        //disable ok button when text field is empty
        buttonsEnable(buttons: [okButton], isEnable: !nameTextField.text!.isEmpty)
        //hide plus button and back button
        hiddenButtons(buttons: [plusButton, backButton, deleteButton, leftButton, rightButton], isHidden: true)
    }
    
    
    //end editing
    @objc func nameTextFieldEndEditing() {
        endEditingNameTextField()
        
    }
    
    //end editing name text field call from nameTextFieldEndEditing and from table view porotocol method
    func endEditingNameTextField() {
        //clouse key board
        
        nameTextField.resignFirstResponder()
        tableViewMainSettings.isScrollEnabled = true
        var name = nameTextField.text ?? ""
        deleteSpacesAfterName(name: &name)
        
        //setup user name from text field
        currentUser.name = name
        //setup plaseholder text
        nameTextField.text = ""
        nameTextField.placeholder = AppTexts.changeNameAppTexts//currentUser.name
        nameLabel.text = currentUser.name
        //save context in local data base - send this cjmplition in container view controller
        settingsViewControllerComplitionActions(.saveContextInLocalDataBase)
        settingsViewControllerComplitionActions(.updateMenuViewController)
        
        // show Volume Subsettings Menu after end editing
        if currentUser!.fullVolume == 0 || currentUser.volumeType == nil {
            self.showVolumeSubsettingsMenu()
            return
        }
           // hiddenButtons(buttons: [deleteButton], isHidden: false)
        hiddenButtons(buttons: [plusButton, backButton], isHidden: false)
        hiddenButtons(buttons: [leftButton, rightButton], isHidden: isSinglUser)
        
    }
    
    
    private func deleteSpacesAfterName ( name: inout String) {
        
        while name.last == " " {
            name.removeLast()
        }
    }
    
    
    
    
}
