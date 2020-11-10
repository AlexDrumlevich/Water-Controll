//
//  PourWaterMenuPickersDelegate.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 24.07.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

//MARK: extention UIPickerViewDataSource
extension MenuViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 && currentUser.volumeType != "oz" {
            return 1
        } else {
            return 10
        }
    }
}

//MARK: extention UIPickerViewDelegate
extension MenuViewController: UIPickerViewDelegate {
    
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        pickerSpinTimes += 1
          //disable buttons
        cancelButtonInPourWaterMenu.isEnabled = false
        pourWaterButton.isEnabled = false
            
        var pickerViewLabel = UILabel()
        if let currentLabel = view as? UILabel {
            pickerViewLabel = currentLabel
        } else {
            pickerViewLabel = UILabel()
        }
        
        pickerViewLabel.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        pickerViewLabel.textAlignment = .center
        pickerViewLabel.font = UIFont(name: "AmericanTypewriter", size: pickerView.bounds.width * 0.5)
        pickerViewLabel.text = String(row)
        defer {
            //enable buttons
            //we wait 1 second after last call this method (we now that it last if value stay the same in 1 second
            let controlPickerSpiningTimes = pickerSpinTimes
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                if self.pickerSpinTimes == controlPickerSpiningTimes {
                    self.cancelButtonInPourWaterMenu.isEnabled = true
                    self.pourWaterButton.isEnabled = true
                }
            }
        }
        return pickerViewLabel
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerView.bounds.width
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //save volume bottle in fullBottleVolume from SettingsViewController.swift
        
       var underMimimumLevel = true
        for picker in pickers {
            if picker.selectedRow(inComponent: 0) > 0 {
                underMimimumLevel = false
            }
        }
        
        if underMimimumLevel {
            if isOzType {
                unitPicker.selectRow(1, inComponent: 0, animated: true)
            } else {
                tenthPicker.selectRow(1, inComponent: 0, animated: true)
            }
        }
        
        var multiplicator: Int16 = 1
        willPourWaterVolume = 0
        for picker in pickers {
            willPourWaterVolume += Int16(picker.selectedRow(inComponent: 0)) * multiplicator
            multiplicator *= 10
                 }
            
        print(willPourWaterVolume)
    }
}
