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
    case openPourWaterIntoGlass, pourWaterIntoBottle
}

class GameViewController: UIViewController {
    
    
    var currentWaterLevel: Float? = nil {
        didSet {
            guard currentWaterLevel != nil else {
                return
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
    
    var bottleEmptyNode: SCNNode? = nil
    var waterNode: SCNNode? = nil
    var menuViewController: MenuViewController?
    
    
    
    
    
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
        waterNode = scene.rootNode.childNode(withName: "water", recursively: true)!
        
        
        
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
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
        
        let waterLevel = currentWaterLevel ?? 1
        let timeDurationAnimation = 1.0
        //current scale
        var startScaleY = waterNode?.scale.y ?? 0
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
        
        //apply action
        waterNode?.runAction(scaleAnimation, completionHandler: {
            //complition block after animation (action)
            print("Scale animation compleated")
            if self.menuViewController != nil {
                //open PourWaterMenu if menuViewController is not nil (we set menuViewController from MenuViewController when we pour water and user isn`t single
                DispatchQueue.main.async {
                    switch self.typeAnimationComplitionFromMenuViewController {
                    case .openPourWaterIntoGlass:
                        self.menuViewController?.showPourWaterMenu()
                        
                    case .pourWaterIntoBottle:
                        self.menuViewController?.pourWaterIntoBottle(with: self.menuViewController?.accessController)
                    }
                    self.menuViewController = nil
                }
            }
        })
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
