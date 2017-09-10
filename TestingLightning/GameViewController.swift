//
//  GameViewController.swift
//  TestingLightning
//
//  Created by Ryan Pfister on 8/28/17.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    // Time between bolts (in seconds)
    let timeBetweenBolts = 0.15
    
    // Bolt lifetime (in seconds)
    let boltLifetime = 0.1
    
    // Line draw delay (in seconds). Set as 0 if you want whole bolt to draw instantly
//    let lineDrawDelay = 0.00175
    let lineDrawDelay = 0.0001
    
    // 0.0 - the bolt will be a straight line. >1.0 - the bolt will look unnatural
    let displaceCoefficient = 0.15
    
    
    // Make bigger if you want bigger line length and vice versa
    let lineRangeCoefficient = 0.5

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
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
        scnView.autoenablesDefaultLighting = true
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        let camera = scene.rootNode.childNode(withName: "camera", recursively: true)!
        scnView.pointOfView = camera
        
        let sphere1 = scene.rootNode.childNode(withName: "sphere1", recursively: true)!
        let sphere2 = scene.rootNode.childNode(withName: "sphere2", recursively: true)!
        
//        let twoPointsNode1 = LightningLineNode(from: sphere1.position, to: sphere2.position, radius: 0.02, color: .cyan)
//        scene.rootNode.addChildNode(twoPointsNode1)
        
        let bolt = LightningBoltNode(startPoint: sphere2.position, endPoint: sphere1.position, lifetime: self.boltLifetime, lineDrawDelay: self.lineDrawDelay, displaceCoefficient: self.displaceCoefficient, lineRangeCoefficient: self.lineRangeCoefficient)

        scene.rootNode.addChildNode(bolt)

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
