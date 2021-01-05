//
//  GameViewControolerRichedAimAnimation.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 17.12.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

//riched aim

extension GameViewController {
    
    
    func putOnGlasses() {
        let action = SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 2)
        emptyGlassesNode?.isHidden = false
        emptyGlassesNode?.runAction(action)
        
    }
    
    
    func putOffGlasses() {
        let action = SCNAction.rotateTo(x: -1, y: 0, z: 0, duration: 2)
            emptyGlassesNode?.runAction(action, completionHandler: {
            DispatchQueue.main.async {
                if !self.isGlassesPutOn {
                self.emptyGlassesNode?.isHidden = true
                }
            }
        })
        
    }
    
    
    
    
  
    func richedAimAction(completionBlock: @ escaping () -> Void) {
        
        guard cupNode != nil else { return }
        bottleEmptyNode?.isHidden = true
        let durationAnimation: Double = 6
        // starNode?.opacity = 0
        cupNode?.scale = SCNVector3(0, 0, 0)
       cupNode?.isHidden = false
        
        
        
       // cupNode?.runAction(getStarRoteteAction(duration: durationAnimation + 1))
        
        
        cupNode?.runAction(getCupGoToMaxScaleAction(duration: durationAnimation / 2), completionHandler: {
            DispatchQueue.main.async {
                
                self.cupNode?.runAction(self.getCupGoToMinScaleAction(duration: durationAnimation / 2), completionHandler: {
                    DispatchQueue.main.async {
                        self.cupNode?.isHidden = true
                        self.bottleEmptyNode?.isHidden = false
                        self.needToAimReachAction = false
                        completionBlock()
                    }
                })
            }
        })
    }
    
    
    private func getCupGoToMaxScaleAction(duration: Double) -> SCNAction {
        //let action = SCNAction.fadeOpacity(to: 1, duration: 2)
        let action = SCNAction.scale(to: 9, duration: duration)
        
        return action
    }
    
    private func getCupGoToMinScaleAction(duration: Double) -> SCNAction {
       // let action = SCNAction.fadeOpacity(to: 0, duration: 2)
        let action = SCNAction.scale(to: 0, duration: duration)
        return action
    }
    
    /*
    private func getStarRoteteAction(duration: Double) -> SCNAction {
        
        let action = SCNAction.rotate(by: 20, around: SCNVector3(1, 1, 1), duration: duration)
        return action
    }
    */
 
}
