//
//  Bullet.swift
//  JetPackKid
//
//  Created by Jesse Spiro on 5/24/16.
//  Copyright © 2016 Jesse Spiro. All rights reserved.
//

import Foundation
import SpriteKit





class Bullet: SKSpriteNode{
    
    var _bullet: SKSpriteNode!
    var detectionMade: Bool!
    
    func setUp(direction:Int){
        self.name = "bullet"
        detectionMade = false
        _bullet = SKSpriteNode(imageNamed: "laser")
        addChild(_bullet)
        
        _bullet.setScale(0.7)
        _bullet.blendMode = SKBlendMode.Screen
        if direction == 0 {
            _bullet.xScale = -0.7
        }
        
        physicsBody = SKPhysicsBody(rectangleOfSize: _bullet.size)
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.mass = 0.2

        physicsBody?.dynamic = true
        physicsBody?.pinned = false
        physicsBody?.restitution = 0.0
        physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        physicsBody?.collisionBitMask = PhysicsCategory.Wall | PhysicsCategory.Robot
        
        
    }
    
    func removeBullet(){
        self.removeFromParent()
    }
    
    

    

}

