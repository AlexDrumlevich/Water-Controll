//
//  GameViewController.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 21.05.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import AVFoundation

//for send type of actions after animation
enum TypeAnimationComplitionFromMenuViewController {
    case openPourWaterIntoGlass, pourWaterIntoBottle, transferCurrentUserInMenuViewController
}
//bubles animation type
enum BubleAnimationType {
    case none, slow, fast
}

class GameViewController: UIViewController {
    
    
    var isChangeWaterLevelFromPourWaterInBottle = false
    
    var currentWaterLevel: Float? = nil {
        didSet {
            guard currentWaterLevel != nil else {
                return
            }
            if currentUser != nil {
                let waterWasDrunkPercentsNewValue = currentUser!.currentVolume * 100 / currentUser!.fullVolume
                let waterWasDrunkPercentsNewValueRounded = roundf(waterWasDrunkPercentsNewValue)
                self.isGlassesPutOn = waterWasDrunkPercentsNewValueRounded >= 100
            }
            setupWaterLevel(from: oldValue)
        }
    }
    
    var currentWaterLevelAtTheMoment: Float = 0
    
    //device vibrate properties
    var needToStopVibrate = true
    //set it when we need vibrate in some action
    var needToVibrateInThisAction = false
    
    //we set current user when we change user in menu view controller
    var currentUser: User? {
        didSet {
            setupWaterLavelWhenUserChanges()
        }
    }
    
    
    //reduse animation
    var isWithOutAnimation = false
    
    var typeAnimationComplitionFromMenuViewController: TypeAnimationComplitionFromMenuViewController = .openPourWaterIntoGlass
    var cameraNode: SCNNode? = nil
    var lightNode: SCNNode? = nil
    var ambientLightNode: SCNNode? = nil
    
    var bottleEmptyNode: SCNNode?
    var waterNode: SCNNode?
    var pupilsNode: SCNNode?
    var emptyGlassesNode: SCNNode?
    var menuViewController: MenuViewController?
    
    //bottle walking
    var emptyBottleNodeFirstPosition: SCNVector3?
    //left -right
    let possibleDistanceRangeX = -3...3
    //up - down
    let possibleDistanceRangeY = -3...3
    // ahead - back
    let possibleDistanceRangeZ = -5...3
    
    //bottle rotation
    
    let possibleAngleRange = -0.1 ... 0.1
    
    
    //pupils movement
    var pupilsNodeFirstPosition: SCNVector3?
    //left -right
    let possibleDistancePupilsMovementRangeX = -0.02 ... 0.02
    //up - down
    let possibleDistancePupilsMovementRangeY = -0.03 ... 0.03
    // ahead - back
    let possibleDistancePupilsMovementRangeZ = -0.03 ... 0.03
    
    // rain - pouer water is bottle
    var rainNode: SCNNode?
    var rainNodePosition: SCNVector3?
    var finishRainNode: SCNNode?
    var finishRainNodePosition: SCNVector3?
    var countOfRainAction = 3
    
    //bubles
    var bubleFirstNode: SCNNode?
    var bubleSecondNode: SCNNode?
    var bubleThirdNode: SCNNode?
    var bublesArray = [SCNNode?]()
    var finishBubleNode: SCNNode?
    var startBubleNode: SCNNode?
    let possibleDistanceBubleAppearFromStartBubleNode: ClosedRange<Float> = -1.5 ... 1.5
    let fastBubleActionTime: ClosedRange<Double> = 0.3 ... 0.6
    let slowBubleActionTime: ClosedRange<Double> = 2 ... 4
    let minimumLevelOfWaterForBubleAnimation: Float = 0.1
    var bubleAnimationType: BubleAnimationType = .none
    
    
    //sun node
    var sunNode: SCNNode?
    let sunRisePosition = SCNVector3(-5, 8.5, -17.5)
    let sunSetPosition = SCNVector3(-5, -10, -17.5)
    
    //time sun and glass action duration
    let sunAndGlassActionDuration: TimeInterval = 2
    
    // aim reched
    var cupNode: SCNNode?
    var needToAimReachAction = false
    
    //glasses put on / off
    var isGlassesPutOn = false
    

    //background scene
    let backgroundColorWithSun =  UIColor(displayP3Red: 1, green: 0.9741613642, blue: 0.9106182112, alpha: 1) //#colorLiteral(red: 1, green: 0.9741613642, blue: 0.9106182112, alpha: 1)
    let backgroundColorWithOutSun = UIColor(displayP3Red: 0.8907909838, green: 0.8919594846, blue: 1, alpha: 1)//#colorLiteral(red: 0.8907909838, green: 0.8919594846, blue: 1, alpha: 1)
    var backgroundColor = UIColor(displayP3Red: 1, green: 0.9889768786, blue: 0.9721240949, alpha: 1)
 
    
    //scene sceneView
    var sceneWaterBottle: SCNScene?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isWithOutAnimation = UIAccessibility.isReduceMotionEnabled
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/bottle.scn")!
        //add camera
        scene.rootNode.addChildNode(addCamera())
        // create and add a light to the scene
        scene.rootNode.addChildNode(addLight())
        // create and add an ambient light to the scene
        scene.rootNode.addChildNode(addAmbientLight())
        
        //backgroun animation
        
        backgroundColor = backgroundColorWithOutSun
        scene.background.contents = backgroundColor
    
        
        //create bottle and other parts
        bottleEmptyNode = scene.rootNode.childNode(withName: "bottleEmptyNode", recursively: true)!
        pupilsNode = scene.rootNode.childNode(withName: "pupilsNode", recursively: true)!
        waterNode = scene.rootNode.childNode(withName: "water", recursively: true)!
        cupNode = scene.rootNode.childNode(withName: "cupNode", recursively: true)
        cupNode?.isHidden = true
        // glasses
        emptyGlassesNode = scene.rootNode.childNode(withName: "emptyGlassesNode", recursively: true)
        emptyGlassesNode?.isHidden = true
        
        //pour water
        rainNode = scene.rootNode.childNode(withName: "rain", recursively: true)
        rainNode?.isHidden = true
        rainNodePosition = rainNode?.position
        finishRainNode = scene.rootNode.childNode(withName: "finishRainNode", recursively: true)
        finishRainNodePosition = finishRainNode?.position
        
        //bubles animation
        bubleFirstNode = scene.rootNode.childNode(withName: "buble1", recursively: true)
        bubleFirstNode?.isHidden = true
        bublesArray.append(bubleFirstNode)
        bubleSecondNode = scene.rootNode.childNode(withName: "buble2", recursively: true)
        bubleSecondNode?.isHidden = true
        bublesArray.append(bubleSecondNode)
        bubleThirdNode = scene.rootNode.childNode(withName: "buble3", recursively: true)
        bubleThirdNode?.isHidden = true
        bublesArray.append(bubleThirdNode)
        finishBubleNode = scene.rootNode.childNode(withName: "finishBubleNode", recursively: true)
        startBubleNode = scene.rootNode.childNode(withName: "startBubleNode", recursively: true)
        
        //sun
        sunNode = scene.rootNode.childNode(withName: "sun", recursively: true)
        sunNode?.isHidden = true
        sunNode?.scale = SCNVector3(4, 4, 4)
        // animate the 3d object
        //  ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        self.sceneWaterBottle = scene
        
        // allows the user to manipulate the camera
        //scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        //scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black//backgroundColorWithOutSun//UIColor.black
        
        // add a tap gesture recognizer
        // let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        //scnView.addGestureRecognizer(tapGesture)
        
        // get first position on empty bottle node
        emptyBottleNodeFirstPosition = bottleEmptyNode?.position
        pupilsNodeFirstPosition = pupilsNode?.position
        
        // we start it when water level changes
        //startBottleAction()
        if !isWithOutAnimation {
            startPupilMovements()
            //sun action
            startSunPulsingAction()
        }
        
        if currentUser != nil {
            if currentUser!.isEmptyBottle {
                stopBubleAction()
            }
        }
        
        
        //addRainParticleSystem()
        
    }
    
    
    //add Camera
    func addCamera() -> SCNNode {
        cameraNode = SCNNode()
        cameraNode?.camera = SCNCamera()
        cameraNode?.position = SCNVector3(x: 0, y: 0, z: 15)
        guard cameraNode != nil else {return SCNNode()}
        return cameraNode!
    }
    
    //add light
    func addLight() -> SCNNode {
        lightNode = SCNNode()
        lightNode?.light = SCNLight()
        lightNode?.light!.type = .omni
        //lightNode?.light?.temperature = 9000
        //  lightNode?.light?.intensity = 3000
        lightNode?.position = SCNVector3(x: 0, y: 0 , z: 10)
        guard lightNode != nil else {return SCNNode()}
        return lightNode!
    }
    
    //  add ambien light
    func addAmbientLight() -> SCNNode {
        ambientLightNode = SCNNode()
        ambientLightNode?.light = SCNLight()
        ambientLightNode?.light!.type = .ambient
        ambientLightNode?.light!.color = UIColor.darkGray
        guard ambientLightNode != nil else {return SCNNode()}
        return ambientLightNode!
    }
    
    
    //    //add particle systems for rain
    //    func addRainParticleSystem() {
    //        let rainNode = SCNNode()
    //
    //        bottleEmptyNode?.addChildNode(rainNode)
    //
    //        let rainParticleSysyem = SCNParticleSystem()
    //        rainNode.position = SCNVector3(0, 4, 0)
    //        rainParticleSysyem.particleImage = UIImage(named: "rain")
    //        rainParticleSysyem.birthRate = 100
    //        rainParticleSysyem.blendMode = .screen
    //        rainParticleSysyem.particleColor = .blue
    //        rainParticleSysyem.particleLifeSpan = 3
    //        rainParticleSysyem.li
    //        rainParticleSysyem.emittingDirection = SCNVector3(0, 1, 0)
    //        rainParticleSysyem.particleSize = 1
    //        rainParticleSysyem.warmupDuration = 10
    //        rainNode.addParticleSystem(rainParticleSysyem)
    //
    //
    //    }
    
    
    
    //create bottle and othe bottle`s parts
    
    //setupWaterLevel
    private func setupWaterLavelWhenUserChanges() {
        if currentUser != nil {
            if currentUser!.isEmptyBottle {
                currentWaterLevel = 0
            } else {
                currentWaterLevel = Float(roundf(currentUser!.currentVolumeInBottle / currentUser!.fullVolume * 100) / 100)
            }
        } else {
            currentWaterLevel = 0
        }
    }
    
    
    
    
    
    //set scale and visible for water nodes
    func setupWaterLevel(from oldValue: Float?) {
        
        //  richedAimAction()
        
        //bottle go home
        let timeDurationAnimation = 2.0
        bottleGoHome {
            
            self.stopBubleAction()
            
            let waterLevel = self.currentWaterLevel ?? 1
            
            //current scale
            var startScaleY = self.waterNode?.scale.y ?? 0
            if startScaleY.isNaN {
                startScaleY = 0
            }
            //different between new and old scales on which we need to change scale
            let differentScaleY = waterLevel - startScaleY
            
            // create action (animation)
            let scaleAnimation = SCNAction.customAction(duration: timeDurationAnimation) { (node, timeLeftFromBegin) in
                //calculate scale in moments of animation
                let currentScaleY = startScaleY + differentScaleY * (Float(timeLeftFromBegin) / Float(timeDurationAnimation))
                
                //set z scale
                var scaleZ: Float = 1.0
                if currentScaleY <= 0.3 {
                    let scalePercent = currentScaleY / 0.3 * 0.12
                    scaleZ = scalePercent == 0 ? 0 : 0.88 + scalePercent
                }
                node.scale = SCNVector3(x: 1, y: currentScaleY, z: scaleZ)
                
                self.currentWaterLevelAtTheMoment = currentScaleY
                
                //stop/start buble action
                
                if self.bubleAnimationType == .slow {
                    self.stopBubleAction()
                }
                if self.bubleAnimationType == .fast && currentScaleY < self.minimumLevelOfWaterForBubleAnimation {
                    self.stopBubleAction()
                }
                if self.bubleAnimationType == .none && currentScaleY >= self.minimumLevelOfWaterForBubleAnimation {
                    self.stopBubleAction()
                    self.startBublesAnimation(animationType: .fast)
                }
                
                if self.currentUser != nil {
                    if self.currentUser!.isEmptyBottle {
                        self.stopBubleAction()
                        
                    }
                }
                
            }
            
            if self.needToAimReachAction {
                
                if self.isWithOutAnimation {
                    DispatchQueue.main.async {
                        self.needToAimReachAction = false
                        self.putOnGlasses()
                        self.sunRise()
                        self.waterChangeAction(scaleAnimation: scaleAnimation, timeDurtionAnimation: timeDurationAnimation, needRainAction: false)
                    }
                } else {
                    self.richedAimAction {
                        DispatchQueue.main.async {
                            self.needToAimReachAction = false
                            self.putOnGlasses()
                            self.sunRise()
                            self.waterChangeAction(scaleAnimation: scaleAnimation, timeDurtionAnimation: timeDurationAnimation, needRainAction: false)
                        }
                    }
                }
            } else {
                
                // if we poure water in bottle
                if self.isChangeWaterLevelFromPourWaterInBottle {
                    self.isChangeWaterLevelFromPourWaterInBottle = false
                    self.rainNode?.runAction(self.preparationToRainAction(withDuration:  timeDurationAnimation / 3), completionHandler: {
                        DispatchQueue.main.async {
                            self.rainNode?.isHidden = true
                            if self.rainNodePosition != nil {
                                self.rainNode?.position = self.rainNodePosition!
                            }
                            self.waterChangeAction(scaleAnimation: scaleAnimation, timeDurtionAnimation: timeDurationAnimation, needRainAction: true)
                        }
                    })
                    
                } else {
                    if self.isGlassesPutOn {
                        self.putOnGlasses()
                        self.sunRise()
                    } else {
                        self.putOffGlasses()
                        self.sunSet()
                    }
                    self.waterChangeAction(scaleAnimation: scaleAnimation, timeDurtionAnimation: timeDurationAnimation, needRainAction: false)
                }
            }
        }
    }
    
    
    
    private func waterChangeAction(scaleAnimation: SCNAction, timeDurtionAnimation: Double, needRainAction: Bool) {
        
        //apply change lewel water action
        DispatchQueue.main.async {
            //rain action
            
            if  needRainAction {
                self.rainAction(withDuration: timeDurtionAnimation / 3)
            }
            // buble action
            //            if self.currentWaterLevel != nil {
            //                if self.currentWaterLevel! > 0.1 {
            //                    self.startBublesAnimation(timeDuration: self.fastBubleActionTime)
            //                }
            //            }
            
            //vibrte when water lavel changing
            self.needToStopVibrate = false
            self.startVibrat()
            
            //water action
            self.waterNode?.runAction(scaleAnimation, completionHandler: {
                
                //scale animation complited
                
                //start buble slow animation
                self.stopBubleAction()
                if self.currentWaterLevel ?? 0 > self.minimumLevelOfWaterForBubleAnimation {
                    self.startBublesAnimation(animationType: .slow)
                }
                
                //stop vibrate
                self.needToStopVibrate = true
                self.needToVibrateInThisAction = false
                //complition block after animation (action)
                //start walking
                if !self.isWithOutAnimation{
                    self.startBottleAction()
                }
                
                if self.menuViewController != nil {
                    //open PourWaterMenu if menuViewController is not nil (we set menuViewController from MenuViewController when we pour water and user isn`t single
                    DispatchQueue.main.async {
                        
                        switch self.typeAnimationComplitionFromMenuViewController {
                        case .openPourWaterIntoGlass:
                            self.menuViewController?.showPourWaterMenu()
                            
                        case .pourWaterIntoBottle:
                            self.menuViewController?.pourWaterIntoBottle(with: self.menuViewController?.accessController)
                            
                        case .transferCurrentUserInMenuViewController:
                            self.menuViewController?.currentUser = self.currentUser
                        }
                        
                        self.menuViewController = nil
                    }
                }
            })
        }
    }
    
    private func startVibrat() {
        guard  needToVibrateInThisAction else {
            return
        }
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(30)) {
            guard !self.needToStopVibrate else {
                return
            }
            self.startVibrat()
        }
    }
    
    
    
    func rainAction(withDuration: Double) {
        //turn on vibrate action
        needToVibrateInThisAction = true
        rainNode?.runAction(preparationToRainAction(withDuration:  withDuration), completionHandler: {
            DispatchQueue.main.async {
                self.countOfRainAction -= 1
                self.rainNode?.isHidden = true
                if self.rainNodePosition != nil {
                    self.rainNode?.position = self.rainNodePosition!
                }
                if self.countOfRainAction == 0 {
                    self.countOfRainAction = 3
                } else {
                    self.rainAction(withDuration: withDuration)
                }
            }
        })
    }
    
    private func preparationToRainAction(withDuration: Double) -> SCNAction {
        guard finishRainNodePosition != nil && rainNodePosition != nil else {
            rainNode?.isHidden = true
            return SCNAction.fadeIn(duration: 0)
        }
        rainNode?.isHidden = false
        return SCNAction.move(to: finishRainNodePosition!, duration: withDuration)
    }
    
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
}
