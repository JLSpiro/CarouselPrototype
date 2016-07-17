//
//  GameScene.swift
//  RingsDemo
//
//  Created by Jesse Spiro on 6/27/16.
//  Copyright (c) 2016 Jesse Spiro. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var rider: Rider!
    var red: SKSpriteNode!
    var wheel: SKSpriteNode!
    var ringArray: NSMutableArray!
    var ring0: SKSpriteNode!
    var ring1: SKSpriteNode!
    var ring2: SKSpriteNode!
    var ring3: SKSpriteNode!
    var ringPos0: CGPoint!
    var ringPos1: CGPoint!
    var ringPos2: CGPoint!
    var ringPos3: CGPoint!
    
    var currentRing: SKSpriteNode!

    var caught: Bool!
    
    override func didMoveToView(view: SKView) {
        
        rider = childNodeWithName("//RiderNode") as! Rider
        rider.setUp()
        
        rider.zPosition = 3
        
        ring0 = childNodeWithName("ring0") as! SKSpriteNode
        ring1 = childNodeWithName("ring1") as! SKSpriteNode
        ring2 = childNodeWithName("ring2") as! SKSpriteNode
        ring3 = childNodeWithName("ring3") as! SKSpriteNode
        
        ringPos0 = ring0.position
        ringPos1 = ring1.position
        ringPos2 = ring2.position
        ringPos3 = ring3.position
        
        
        ringArray = [ring0,ring1,ring2,ring3]
        currentRing = ringArray.objectAtIndex(0) as! SKSpriteNode
        
        wheel = childNodeWithName("wheel") as! SKSpriteNode
        
        red = childNodeWithName("red") as! SKSpriteNode
        red.hidden = true
    
        caught = false
        
 
     
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        rider.jump()
    }
    
    
    
    
    override func update(currentTime: CFTimeInterval) {
        let torso = childNodeWithName("//torso") as! SKSpriteNode
        let torsoPos = convertPoint(torso.position, fromNode: rider)
       // print("\(torsoPos.y)")
        
        if caught == false {
            if red.containsPoint(torsoPos){
                print ("got it!!")
                caught = true
                currentRing.runAction(SKAction.sequence([SKAction.scaleTo(0.0, duration: 0.5), SKAction.runBlock(dropRings), SKAction.waitForDuration(0.1), SKAction.runBlock(unCaught)]))
            }

        }
        if caught == true {
            currentRing.position = torsoPos
   
            
        }
        
    }
    
    func unCaught(){
        caught = false
        currentRing = ringArray.objectAtIndex(0) as! SKSpriteNode
        currentRing.position = ringPos3
        currentRing.runAction(SKAction.scaleTo(0.68, duration: 0.5))
        
        ringArray.removeObjectAtIndex(0)
        ringArray.addObject(currentRing)
        
        currentRing = ringArray.objectAtIndex(0) as! SKSpriteNode
     
        
    }
    
    func dropRings(){
        let secondRing: SKSpriteNode = ringArray.objectAtIndex(1) as! SKSpriteNode
        let thirdRing: SKSpriteNode = ringArray.objectAtIndex(2) as! SKSpriteNode
        let fourthRing: SKSpriteNode = ringArray.objectAtIndex(3) as! SKSpriteNode
        
        secondRing.runAction(SKAction.moveTo(ringPos0, duration: 0.5))
        thirdRing.runAction(SKAction.moveTo(ringPos1, duration: 0.5))
        fourthRing.runAction(SKAction.moveTo(ringPos2, duration: 0.5))

        
    }


}
