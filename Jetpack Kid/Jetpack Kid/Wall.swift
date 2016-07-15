//
//  Wall.swift
//  JetPackKid
//
//  Created by Jesse Spiro on 6/13/16.
//  Copyright © 2016 Jesse Spiro. All rights reserved.
//

import Foundation
import SpriteKit

class Wall:SKSpriteNode {
    
        var wall:SKSpriteNode!
    
    func setUp(){
        wall = childNodeWithName("wallSprite") as! SKSpriteNode
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: wall.frame)
        physicsBody?.allowsRotation = false
        physicsBody?.pinned = true
        physicsBody?.dynamic = false
        physicsBody?.collisionBitMask = PhysicsCategory.Bullet
        physicsBody?.categoryBitMask = PhysicsCategory.Wall
        physicsBody?.contactTestBitMask = PhysicsCategory.Bullet
        
        
    }

    
}