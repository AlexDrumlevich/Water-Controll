//
//  GameViewControllerWalkAnimation.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 15.12.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

extension GameViewController {
    
    
    //go home bottle
    //    status: @escaping (UNAuthorizationStatus) -> Void
    func bottleGoHome(completionBlock: @ escaping () -> Void) {
        guard emptyBottleNodeFirstPosition != nil else {
            completionBlock()
            return
        }
        
        bottleEmptyNode?.removeAllActions()
        
        if bottleEmptyNode?.position.x != emptyBottleNodeFirstPosition?.x || bottleEmptyNode?.position.y != emptyBottleNodeFirstPosition?.y || bottleEmptyNode?.position.z != emptyBottleNodeFirstPosition?.z {
            let goHomeAction = SCNAction.move(to: emptyBottleNodeFirstPosition!, duration: 0.5)
            bottleEmptyNode?.runAction(goHomeAction) {
                completionBlock()
            }
        } else {
            completionBlock()
        }
        
    }
    
    
    
    func startBottleAction () {
        startBottleWalking()
        startBottleRotation()
    }
    
    // botle walking action
    private func startBottleWalking() {
        
        
        bottleEmptyNode?.runAction(getSCNActionToGo(), completionHandler: {
            DispatchQueue.main.async {
                self.startBottleWalking()
            }
        })
        
    }
    
    
    private func getSCNActionToGo() -> SCNAction {
        let aimXAxisToGo = Int.random(in: possibleDistanceRangeX)
        let aimYAxisToGo = Int.random(in: possibleDistanceRangeY)
        let aimZAxisToGo = Int.random(in: possibleDistanceRangeZ)
        let aimToGo = SCNVector3(aimXAxisToGo, aimYAxisToGo, aimZAxisToGo)
        return SCNAction.move(to: aimToGo, duration: 10)
    }
    
    
    private func startBottleRotation() {
        bottleEmptyNode?.runAction(getSCNActionRotation(), completionHandler: {
            DispatchQueue.main.async {
                self.startBottleRotation()
            }
        })
    }
    
    private func getSCNActionRotation() -> SCNAction {
        //  let aimXAxisRotate = Double.random(in: possibleAngleRange)
        // let aimYAxisRotate = Double.random(in: possibleAngleRange)
        //let aimZAxisRotate = Double.random(in: possibleAngleRange)
        let aimWRotated = Double.random(in: possibleAngleRange)
        
        
        let rotateAction = SCNAction.rotate(toAxisAngle: SCNVector4(0, 0.1, 0, aimWRotated), duration: 3)
        return rotateAction
    }
    
}
