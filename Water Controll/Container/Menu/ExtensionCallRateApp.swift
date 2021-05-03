//
//  ExtensionCallRateApp.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 03.01.2021.
//  Copyright © 2021 ALEXEY DRUMLEVICH. All rights reserved.
//

import Foundation
import StoreKit

//Call user rate app and share app

enum  AppStoreReviewManager  {
    static  func  requestReviewIfAppinent () {
        if #available(iOS 14.0, *) {
                if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            } else {
                SKStoreReviewController.requestReview()
            }
    }
}

extension MenuViewController {
    
    // we wach for new version of the app in data base file in ContainerViewController (when we get access from data base)
    func  requestCallRateTheApp () {
        
        guard var timesToCallUserToRateTheApp = accessController?.needTimesPourWaterToCallRateTheApp, let containerVC = self.parent as? ContainerViewController else {
            return
        }
        
        if timesToCallUserToRateTheApp > 0 {
            timesToCallUserToRateTheApp -= 1
            accessController?.needTimesPourWaterToCallRateTheApp = timesToCallUserToRateTheApp
            containerVC.saveContextInLocalDataBase()
            if timesToCallUserToRateTheApp == 0 {
                AppStoreReviewManager.requestReviewIfAppinent()
            }
        } else {
            return
        }
        
    }
    
}


