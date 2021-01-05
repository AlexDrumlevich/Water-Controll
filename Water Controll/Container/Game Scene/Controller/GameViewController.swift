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


//for send type of actions after animation
enum TypeAnimationComplitionFromMenuViewController {
    case openPourWaterIntoGlass, pourWaterIntoBottle, transferCurrentUserInMenuViewController
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
    
    //we set current user when we change user in menu view controller
    var currentUser: User? {
        didSet {
            setupWaterLavelWhenUserChanges()
        }
    }
    
    
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
    let possibleDistancePupilsMovementRangeX = -0.01 ... 0.01
    //up - down
    let possibleDistancePupilsMovementRangeY = -0.02 ... 0.02
    // ahead - back
    let possibleDistancePupilsMovementRangeZ = -0.01 ... 0.01
    
    // rain - pouer water is bottle
    var rainNode: SCNNode?
    var rainNodePosition: SCNVector3?
    var finishRainNode: SCNNode?
    var finishRainNodePosition: SCNVector3?
    var countOfRainAction = 3
    
    // aim reched
    var cupNode: SCNNode?
    var needToAimReachAction = false
    
    //glasses put on / off
    var isGlassesPutOn = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/bottle.scn")!
        //add camera
        scene.rootNode.addChildNode(addCamera())
        // create and add a light to the scene
        scene.rootNode.addChildNode(addLight())
        // create and add an ambient light to the scene
        scene.rootNode.addChildNode(addAmbientLight())
        
        
        
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
    
        
        // animate the 3d object
        //  ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        // let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        //scnView.addGestureRecognizer(tapGesture)
        
        // get first position on empty bottle node
        emptyBottleNodeFirstPosition = bottleEmptyNode?.position
        pupilsNodeFirstPosition = pupilsNode?.position
        startBottleAction()
        startPupilMovements()
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
                print("currentScaleY: \(currentScaleY), z: \(scaleZ)")
            }
            
            if self.needToAimReachAction {
                
                self.richedAimAction {
                    DispatchQueue.main.async {
                        self.putOnGlasses()
                        self.waterChangeAction(scaleAnimation: scaleAnimation, timeDurtionAnimation: timeDurationAnimation, needRainAction: false)
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
                    } else {
                        self.putOffGlasses()
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
            //water action
            self.waterNode?.runAction(scaleAnimation, completionHandler: {
                
                //complition block after animation (action)
                //start walking
                self.startBottleAction()
                print("Scale animation compleated")
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
    
    
    
    func rainAction(withDuration: Double) {
        
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
