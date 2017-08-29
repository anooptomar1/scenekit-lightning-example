//
//  LightningBoltNode.swift
//  SpriteKitLigtning-Swift
//
//  Created by Andrey Gordeev on 28/10/14.
//  Copyright (c) 2014 Andrey Gordeev. All rights reserved.
//

import Foundation
import SceneKit



class LightningBoltNode: SCNNode {
    
    var lifetime = 0.15
    var lineDrawDelay = 0.02
    var displaceCoefficient = 0.25
    var lineRangeCoefficient = 1.8
    var pathArray = [SCNVector3]()
    
    init(startPoint: SCNVector3, endPoint: SCNVector3, lifetime: Double, lineDrawDelay: Double, displaceCoefficient: Double, lineRangeCoefficient: Double) {
        super.init()
        self.lifetime = lifetime
        self.lineDrawDelay = lineDrawDelay
        self.displaceCoefficient = displaceCoefficient
        self.lineRangeCoefficient = lineRangeCoefficient
        self.drawBolt(startPoint: startPoint, endPoint: endPoint)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    // MARK: Drawing bolt
    
    func drawBolt(startPoint: SCNVector3, endPoint: SCNVector3) {
        // Dynamically calculating displace
        let xRange = endPoint.x - startPoint.x
        let yRange = endPoint.y - startPoint.y
        let hypot = hypotf(fabsf(Float(xRange)), fabsf(Float(yRange)))
        // hypot/displace = 4/1
        let displace = hypot*Float(self.displaceCoefficient)
        
        pathArray.append(startPoint)
        self.createBolt(x1: startPoint.x, y1: startPoint.y, z1: startPoint.z, x2: endPoint.x, y2: endPoint.y, z2: endPoint.z, displace: Double(displace))
        
        for i in (0..<pathArray.count - 1) {
            self.addLineToBolt(startPoint: pathArray[i], endPoint: pathArray[i+1], delay: Double(i)*self.lineDrawDelay)
        }
        
//        let waitDuration = Double(pathArray.count - 1)*self.lineDrawDelay + self.lifetime
//        let disappear = SKAction.sequence([SKAction.waitForDuration(waitDuration), SKAction.fadeOutWithDuration(0.25), SKAction.removeFromParent()])
//        self.runAction(disappear)
    }
    
    func addLineToBolt(startPoint: SCNVector3, endPoint: SCNVector3, delay: Double) {
        let line = LightningLineNode(from: startPoint, to: endPoint)
        self.addChildNode(line)
    }
    
    func createBolt(x1: Float, y1: Float, z1: Float, x2: Float, y2: Float, z2: Float, displace: Double) {
        if displace < self.lineRangeCoefficient {
            let point = SCNVector3.init(x2, y2, z2)
            self.pathArray.append(point)
        }
        else {
            var mid_x = Double(x2+x1)*0.5;
            var mid_y = Double(y2+y1)*0.5;
            var mid_z = Double(z2 + z1) * 0.5;
            mid_x += (Double(arc4random_uniform(100))*0.01-0.5)*displace;
            mid_y += (Double(arc4random_uniform(100))*0.01-0.5)*displace;
            mid_z += (Double(arc4random_uniform(100))*0.01-0.5)*displace;
            let halfDisplace = displace*0.5
            self.createBolt(x1: x1, y1: y1, z1: z1, x2: Float(mid_x), y2: Float(mid_y), z2: Float(mid_z), displace: halfDisplace)
            self.createBolt(x1: Float(mid_x), y1: Float(mid_y), z1: Float(mid_z), x2: x2, y2: y2, z2: z2, displace: halfDisplace)
        }
    }

}

