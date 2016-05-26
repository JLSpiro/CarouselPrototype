//
//  Trigger.swift
//  JetPackKid
//
//  Created by Jesse Spiro on 5/23/16.
//  Copyright © 2016 Jesse Spiro. All rights reserved.
//

import Foundation
import SpriteKit


class Trigger: SKSpriteNode {
    
    var trigger: SKSpriteNode!
    var _triggerRadius: CGFloat!
    var _triggerRadiusSquared: CGFloat!
    var _isTouchingTrigger: Bool!

    
    func setUp(){
        trigger = childNodeWithName("trigger") as! SKSpriteNode
        _isTouchingTrigger = false
        _triggerRadius = trigger.size.width * 0.4;
        _triggerRadiusSquared = pow(_triggerRadius,2);
   //     userInteractionEnabled = true
        
 
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            if  isTouchingTrigger(touch) == true {
                
            //   print("BANG")
                
  
            }
            
        }
        
    }
    

    
    func distanceFromTriggerSquared(p: CGPoint) -> CGFloat {
        // remember a squared + b squared = c squared?
        let p2 = trigger.position
        return pow(p2.x - p.x, 2) + pow(p2.y - p.y, 2)
        
    }
    
    
    func isTouchingTrigger(touch: UITouch) -> Bool{
        let c2: CGFloat = distanceFromTriggerSquared(touch.locationInNode(self))
        return (c2 < pow(_triggerRadius,2))
        
    }

    
}