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
    var walkFrames: [SKTexture] = []
    var timer = NSTimer()

    
    func setUp(){
        head = childNodeWithName("head") as! SKSpriteNode
        body = childNodeWithName("body") as! SKSpriteNode
        
        for i in 1...24 {
            walkFrames.append(SKTexture(imageNamed: "bigBotBody\(i)"))
        }
        
        physicsBody = SKPhysicsBody(texture: body.texture!, size: body.size)
        physicsBody?.affectedByGravity = true
        physicsBody?.mass = 1.0
        physicsBody?.allowsRotation = false
        physicsBody?.pinned = false
        physicsBody?.dynamic = true
        physicsBody?.contactTestBitMask = PhysicsCategory.Hero
        physicsBody?.categoryBitMask = PhysicsCategory.Robot

        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(step), userInfo: nil, repeats: true)

 
    }
    
    func step(){
        body.runAction(SKAction.animateWithTextures(walkFrames, timePerFrame: 0.03))
        physicsBody?.velocity = CGVector(dx: -90, dy: 0)
    }
    
    
    
    
    
}