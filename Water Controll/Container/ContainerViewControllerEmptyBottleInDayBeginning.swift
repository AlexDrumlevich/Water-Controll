//
//  ContainerViewControllerEmptyBottleInDayBeginning.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 14.09.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import Foundation

extension ContainerViewController {
    
    //  set empty bottles at the begining of the day
    
    func newDayBeginingSetEmptyBottlesControl() {
       
        //current date
        let currentDate = Date()
        let calendar = Calendar.current
        
        let currentDay = calendar.component(.weekday, from: currentDate)
        let currentMounth = calendar.component(.month, from: currentDate)
        
        //last session date
        guard accessController != nil else { return }
        guard let lastSessionDate = accessController!.currentDate else { return }
        let lastSessionDay = calendar.component(.weekday, from: lastSessionDate)
        let lastSessionMounth = calendar.component(.month, from: lastSessionDate)
  
        
        
        //if we have anouther day
        if currentDay != lastSessionDay || currentMounth != lastSessionMounth {
            
            accessController?.currentDate = currentDate
            
            for user in users {
                user.isEmptyBottle = true
                user.currentVolume = 0
                
                if gameViewController != nil {
                    (gameViewController as? GameViewController)?.currentUser = currentUser
                }
            }
        
            saveContextInLocalDataBase()
            
            guard currentUser != nil else {
                return
            }
            if currentUser.isAutoFillBottleType, gameViewController != nil, menuViewController != nil {
                (gameViewController as? GameViewController)?.currentWaterLevel = currentUser.currentVolume
                (gameViewController as! GameViewController).typeAnimationComplitionFromMenuViewController = .transferCurrentUserInMenuViewController
                (gameViewController as! GameViewController).menuViewController = menuViewController
            }
            
        }
        
    }
    
}
