//
//  GameViewControllerPupilsMovementAnimation.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 15.12.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

extension GameViewController {
    
    // botle walking action
    func startPupilMovements() {

        
        pupilsNode?.runAction(getSCNActionToPupilsMovement(), completionHandler: {
            DispatchQueue.main.async {
                self.startPupilMovements()
            }
        })
         
    }
    
    private func getSCNActionToPupilsMovement() -> SCNAction {
        let aimXAxisToGo = Float(Double.random(in: possibleDistancePupilsMovementRangeX))
        let aimYAxisToGo = Float(Double.random(in: possibleDistancePupilsMovementRangeY))
        let aimZAxisToGo = Float(Double.random(in: possibleDistancePupilsMovementRangeZ))
        let aimToGo = SCNVector3(aimXAxisToGo, aimYAxisToGo, aimZAxisToGo)
        return SCNAction.move(to: aimToGo, duration: 3)
    }
    
}
