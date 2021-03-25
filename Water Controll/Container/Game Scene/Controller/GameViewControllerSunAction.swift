//
//  GameViewControllerSunAction.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 24.02.2021.
//  Copyright © 2021 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

extension GameViewController {
    
    func startSunPulsingAction() {
        guard sunNode != nil else {
            return
        }
        let scaleMoreSunFactor: CGFloat = 1.002
        let scaleLessSunFactor: CGFloat = 0.997
        let scaleChangeDuration: Double = 0.25
        let scaleMoreAction = SCNAction.scale(by: scaleMoreSunFactor, duration: scaleChangeDuration)
        let scaleLessAction = SCNAction.scale(by: scaleLessSunFactor, duration: scaleChangeDuration)
        
        sunNode?.runAction(scaleMoreAction, completionHandler: {
            self.sunNode?.runAction(scaleLessAction, completionHandler: {
                self.startSunPulsingAction()
            })
        })
        
    }
    
}
