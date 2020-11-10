//
//  ExtentionVolumeSubsettingsPickerDelegates.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 08.06.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

//MARK: extention UIPickerViewDataSource
extension SettingsViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.ozPicker {
            return numberOfMaxOz
        } else if pickerView == self.literIntegerPicker {
            return numberOfMaxIntegerLites
        } else {
            return 10
        }
    }
    
    
}

//MARK: extention UIPickerViewDelegate
extension SettingsViewController: UIPickerViewDelegate {
    
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        pickerSpinTimes += 1
          //disable buttons
            buttonsEnable(buttons: [okButton, ozButton, literButton], isEnable: false)
        
        var pickerViewLabel = UILabel()
        if let currentLabel = view as? UILabel {
            pickerViewLabel = currentLabel
        } else {
            pickerViewLabel = UILabel()
        }
        
        pickerViewLabel.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        pickerViewLabel.textAlignment = .center
        pickerViewLabel.font = UIFont(name: "AmericanTypewriter", size: pickerView.bounds.width * 0.3)
        pickerViewLabel.text = String(row)
        defer {
            //enable buttons
            //we wait 1 second after last call this method (we now that it last if value stay the same in 1 second
            let controlPickerSpiningTimes = pickerSpinTimes
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.buttonsEnable(buttons: [self.cancelButton], isEnable: true)
                if self.pickerSpinTimes == controlPickerSpiningTimes {
                    self.buttonsEnable(buttons: [self.okButton, self.ozButton, self.literButton], isEnable: true)
                    self.pickerSpinTimes = 0
                }
            }
        }
        return pickerViewLabel
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerView.bounds.width * 0.3
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //save volume bottle in fullBottleVolume from SettingsViewController.swift
        
        
        switch pickerView {
        case ozPicker:
            isSubMinimumVolume = row == 0
            if isSubMinimumVolume {
                pickerView.selectRow(1, inComponent: 0, animated: true)
                fullBottleVolume = 1
            } else {
            fullBottleVolume = Float(row)
            }
        default:
            isSubMinimumVolume = literIntegerPicker.selectedRow(inComponent: 0) == 0 && literTenthPicker.selectedRow(inComponent: 0) == 0
            if isSubMinimumVolume {
                literTenthPicker.selectRow(1, inComponent: 0, animated: true)
                fullBottleVolume = 0.1
            } else {
            
            fullBottleVolume = Float(literIntegerPicker.selectedRow(inComponent: 0)) + (Float(literTenthPicker.selectedRow(inComponent: 0)) / 10)
        }
        }
        
        print(fullBottleVolume)
    }
}
