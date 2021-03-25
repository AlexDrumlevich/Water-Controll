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
        let action = SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: sunAndGlassActionDuration)
        emptyGlassesNode?.isHidden = false
        emptyGlassesNode?.runAction(action)
    }
    
    
    func putOffGlasses() {
        let action = SCNAction.rotateTo(x: -1, y: 0, z: 0, duration: sunAndGlassActionDuration)
        emptyGlassesNode?.runAction(action, completionHandler: {
            DispatchQueue.main.async {
                if !self.isGlassesPutOn {
                    self.emptyGlassesNode?.isHidden = true
                    
                }
            }
        })
    }
    
    func sunRise() {
        let sunRiseAction = SCNAction.move(to: sunRisePosition, duration: sunAndGlassActionDuration)
        let sunOpacityAction = SCNAction.fadeOpacity(to: 0.9, duration: sunAndGlassActionDuration)
        sunNode?.isHidden = false
        sceneWaterBottle?.background.contents = backgroundColorWithSun
        DispatchQueue.main.async {
            if let containerVC = self.parent as? ContainerViewController {
                containerVC.blurViewBehindBanner?.backgroundColor = self.backgroundColorWithSun
            }
        }
       
        //backgroundSunRiseAnimation()
        sunNode?.runAction(sunRiseAction)
        sunNode?.runAction(sunOpacityAction)
    }
    
    func sunSet() {
        let actionSunset = SCNAction.move(to: sunSetPosition, duration: sunAndGlassActionDuration)
        let sunOpacityAction = SCNAction.fadeOpacity(to: 0, duration: sunAndGlassActionDuration)
        // backgroundSunSetAnimation()
        sceneWaterBottle?.background.contents = backgroundColorWithOutSun
        DispatchQueue.main.async {
            if let containerVC = self.parent as? ContainerViewController {
                containerVC.blurViewBehindBanner?.backgroundColor = self.backgroundColorWithOutSun
            }
        }
        sunNode?.runAction(sunOpacityAction)
        sunNode?.runAction(actionSunset, completionHandler: {
            if !self.isGlassesPutOn {
                self.emptyGlassesNode?.isHidden = true
            }
        })
    }
    
 /*
    func backgroundSunRiseAnimation() {
        
        let animation = CABasicAnimation(keyPath: "contents")
        // animation.fromValue = backgroundColorWithOutSun
        animation.toValue = self.backgroundColorWithSun
        animation.duration = sunAndGlassActionDuration
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        animation.setValue("backgroundSunRiseAnimation", forKey: "animationType")
        sceneWaterBottle?.background.addAnimation(animation, forKey: "backgroundSunRiseAnimation")
        
        
    }
    
    func backgroundSunSetAnimation() {
        let animation = CABasicAnimation(keyPath: "contents")
        //animation.fromValue = backgroundColorWithOutSun
        animation.toValue = backgroundColorWithOutSun
        animation.duration = sunAndGlassActionDuration
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        animation.setValue("backgroundSunSetAnimation", forKey: "animationType")
        sceneWaterBottle?.background.addAnimation(animation, forKey: "backgroundSunSetAnimation")
        
    }
 */
    
    func richedAimAction(completionBlock: @ escaping () -> Void) {
        completionBlock()
        //developing
        /*
        guard cupNode != nil else { return }
        bottleEmptyNode?.isHidden = isWithOutAnimation ? false : true
        let durationAnimation: Double = isWithOutAnimation ? 2 : 6
        // starNode?.opacity = 0
        cupNode?.scale = SCNVector3(0, 0, 0)
        cupNode?.isHidden = false
        
        cupNode?.runAction(getCupGoToMaxScaleAction(duration: durationAnimation / 2), completionHandler: {
            DispatchQueue.main.async {
               // self.cupNode?.isHidden = true
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
 */
    }
    /*
    
    private func getCupGoToMaxScaleAction(duration: Double) -> SCNAction {
        //let action = SCNAction.fadeOpacity(to: 1, duration: 2)
        let action = SCNAction.scale(to: 7, duration: duration)
        return action
    }
    
    private func getCupGoToMinScaleAction(duration: Double) -> SCNAction {
        // let action = SCNAction.fadeOpacity(to: 0, duration: 2)
        let action = SCNAction.scale(to: 0, duration: duration)
        return action
    }
     */
}
 


/*
extension GameViewController: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        guard let animationValue = anim.value(forKey: "animationType") as? String else { return }
        
        if animationValue == "backgroundSunRiseAnimation" {
            sceneWaterBottle?.background.contents = backgroundColorWithSun
        }
        if animationValue == "backgroundSunSetAnimation" {
            sceneWaterBottle?.background.contents = backgroundColorWithOutSun
        }
    }
 
}
*/
