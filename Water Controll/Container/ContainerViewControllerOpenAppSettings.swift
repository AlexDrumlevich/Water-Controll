//
//  ContainerViewControllerOpenAppSettings.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 29.11.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

extension ContainerViewController {
    
    func openAppSettingsInsidePhoneSettings() -> Bool {
        var isGoodResult = false
        
        if let url = URL(string: UIApplication.openSettingsURLString) {
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                isGoodResult = true
            } else {
                isGoodResult = false
            }
            
        } else {
            isGoodResult = false
        }
        
        return isGoodResult
    }
}
