//
//  HexNode.swift
//  DrawingGame
//
//  Created by Jesse Spiro on 2/13/16.
//  Copyright © 2016 Jesse Spiro. All rights reserved.
//

import Foundation
import SpriteKit

class HexNode: SKSpriteNode {
    
    let fingerTexture = SKSpriteNode(imageNamed: "fingerTexture")
    
    func setUp(){
        
        let hexBodyTexture = SKTexture(imageNamed: "hexBody")
        physicsBody = SKPhysicsBody(texture: hexBodyTexture, size: hexBodyTexture.size())
        physicsBody?.affectedByGravity = false
        physicsBody?.pinned = true
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = PhysicsCategory.Hex
        
        addChild(fingerTexture)
        fingerTexture.zPosition = 2
        fingerTexture.alpha = 0
        fingerTexture.blendMode = SKBlendMode.Add
        
    }
    
    func changeSomething(){
       // fingerTexture.runAction(SKAction.fadeAlphaTo(1.0, duration: 1.0))
        fingerTexture.runAction(SKAction.sequence([SKAction.fadeAlphaTo(1.0, duration: 1.0),SKAction.waitForDuration(1.0), SKAction.fadeAlphaTo(0.0, duration: 0.5)]))
    }
    func unChangeSomething(){
       // fingerTexture.runAction(SKAction.fadeAlphaTo(0.0, duration: 1.0))
      
        
    }



    
}
