//
//  BigBot.swift
//  JetPackKid
//
//  Created by Jesse Spiro on 6/3/16.
//  Copyright © 2016 Jesse Spiro. All rights reserved.
//

import Foundation
import SpriteKit


class BigBot:SKSpriteNode{
    
    var head:SKSpriteNode!
    var body:SKSpriteNode!
    var physBody: SKSpriteNode!
    var walkFrames1: [SKTexture] = []
    var walkFrames2: [SKTexture] = []
    var timer = NSTimer()
    var _currentWalk:Int!
    
    func setUp(){
        head = childNodeWithName("head") as! SKSpriteNode
        body = childNodeWithName("body") as! SKSpriteNode
        physBody = childNodeWithName("physBody") as! SKSpriteNode
        _currentWalk = 1
        
        for i in 1...12 {
            walkFrames1.append(SKTexture(imageNamed: "bigBotBody\(i)"))
        }
        
        for i in 13...24 {
            walkFrames2.append(SKTexture(imageNamed: "bigBotBody\(i)"))
        }

        physicsBody = SKPhysicsBody(texture: physBody.texture!, size: physBody.size)
        physicsBody?.affectedByGravity = true
        physicsBody?.mass = 300.0
        physicsBody?.allowsRotation = false
        physicsBody?.pinned = false
        physicsBody?.dynamic = true
        physicsBody?.friction = 1.0
        physicsBody?.categoryBitMask = PhysicsCategory.Robot
        physicsBody?.collisionBitMask =  PhysicsCategory.Wall | PhysicsCategory.Ground | PhysicsCategory.Bullet
        physicsBody?.contactTestBitMask = PhysicsCategory.Hero
    

        timer = NSTimer.scheduledTimerWithTimeInterval(0.75, target: self, selector: #selector(stepForward), userInfo: nil, repeats: true)
 
    }
    

    func stepForward(){
        /*
        if _currentWalk == 1 {
            body.runAction(SKAction.animateWithTextures(walkFrames1, timePerFrame: 0.0625))
            _currentWalk = 2
        }
        if _currentWalk == 2 {
            body.runAction(SKAction.animateWithTextures(walkFrames2, timePerFrame: 0.0625))
            _currentWalk = 1
        }
 */
        physicsBody?.velocity = CGVector(dx: -300, dy: 0)
    }
    
    
    
    
    
    
    
}