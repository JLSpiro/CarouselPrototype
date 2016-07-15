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
    var brass: SKSpriteNode!
    var red: SKSpriteNode!
    var wheel: SKSpriteNode!
    
    var caught: Bool!
    
    override func didMoveToView(view: SKView) {
        
        rider = childNodeWithName("//RiderNode") as! Rider
        rider.setUp()
        
        rider.zPosition = 3
        
        brass = childNodeWithName("brass") as! SKSpriteNode
        
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
                brass.runAction(SKAction.sequence([SKAction.scaleBy(0.3, duration: 0.5), SKAction.waitForDuration(1.0), SKAction.scaleBy(0.01, duration: 1), SKAction.removeFromParent()]))
            }

        }
        if caught == true {
            brass.position = torsoPos
            
        }
        
    }
}
