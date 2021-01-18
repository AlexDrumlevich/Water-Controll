//
//  GameViewControllerBublesAnimation.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 06.01.2021.
//  Copyright © 2021 ALEXEY DRUMLEVICH. All rights reserved.
//



import Foundation

import UIKit
import QuartzCore
import SceneKit

enum  ActionKeys: String {
    case bubleAction
}

extension GameViewController {
    
    // botle walking action
    func startBublesAnimation(animationType: BubleAnimationType) {
        
        self.stopBubleAction()
        
        
        DispatchQueue.main.async {
            
           
            var timeDuration: ClosedRange<Double> = 0...1
            
            switch animationType {
            case .fast:
                timeDuration = self.fastBubleActionTime
            case .slow:
                timeDuration = self.slowBubleActionTime
            default:
                return
            }
           
           
            
            self.bubleAnimationType = animationType
            
            guard self.finishBubleNode != nil, self.currentWaterLevel != nil, self.startBubleNode != nil else {
                return
            }
            
            guard !self.bublesArray.isEmpty else {
                return
            }
            
            for buble in self.bublesArray {
                if buble == nil {
                    continue
                }
                
                self.bubleAction(bubleNode: buble, timeDuration: timeDuration)
            }
        }
        
    }
    
    private func bubleAction(bubleNode: SCNNode?, timeDuration: ClosedRange<Double>) {
        guard bubleNode != nil else {
            return
        }
        setRandomPosition(for: bubleNode)
        bubleNode?.isHidden = false
        bubleNode?.runAction(bubleMovement(startPosition: bubleNode?.position, timeDuration: Double.random(in: timeDuration)), forKey: ActionKeys.bubleAction.rawValue, completionHandler: {
            DispatchQueue.main.async {
                bubleNode?.isHidden = true
             
                self.setRandomPosition(for: bubleNode)
                self.bubleAction(bubleNode: bubleNode, timeDuration: timeDuration)
            }
        })
    }
    
    private func bubleMovement(startPosition: SCNVector3?, timeDuration: Double) -> SCNAction {
         
        // if water goes down we take the minimem end position else we take water position at tre moment
        let endWaterPosition = currentWaterLevelAtTheMoment > currentWaterLevel ?? 0 ? currentWaterLevel : currentWaterLevelAtTheMoment
        let aimYAxisWaterLevel = abs((finishBubleNode!.position.y - (startBubleNode?.position.y)!) * endWaterPosition!)
        let aimYAxisToGo = (startBubleNode?.position.y)! + aimYAxisWaterLevel
        
        let aimToGo = SCNVector3(startPosition?.x ?? startBubleNode!.position.x, aimYAxisToGo,  startPosition?.z ?? startBubleNode!.position.z)
        
        let action = SCNAction.move(to: aimToGo, duration: timeDuration)
        return action
    }
    
    private func setRandomPosition(for bubleNode: SCNNode?) {
        
        bubleNode?.position.x = (self.startBubleNode?.position.x)! + (Float.random(in: self.possibleDistanceBubleAppearFromStartBubleNode))
        bubleNode?.position.z = (self.startBubleNode?.position.z)! + (Float.random(in: self.possibleDistanceBubleAppearFromStartBubleNode))
        bubleNode?.position.y = (self.startBubleNode?.position.y)!
        
    }
    
    func stopBubleAction() {
        DispatchQueue.main.async {
            self.bubleAnimationType = .none
            guard self.startBubleNode != nil else {
                return
            }
            for buble in self.bublesArray {
                buble?.isHidden = true
                buble?.position = self.startBubleNode!.position
                buble?.removeAction(forKey: ActionKeys.bubleAction.rawValue)
            }
        }
    }
}




