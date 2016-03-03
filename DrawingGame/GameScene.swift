//
//  GameScene.swift
//  DrawingGame
//
//  Created by Jesse Spiro on 2/13/16.
//  Copyright (c) 2016 Jesse Spiro. All rights reserved.
//

import SpriteKit
import Foundation

struct PhysicsCategory {
    static let None:  UInt32 = 0
    static let Spot:   UInt32 = 0b1 // 1
    static let Hex: UInt32 = 0b10 // 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    var currentLevel: Int = 0
    var touchSpot: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        
        physicsWorld.contactDelegate = self
       // view.showsPhysics = true

        enumerateChildNodesWithName("hex") {node, _ in
            let aHex = node as! HexNode
            aHex.setUp()
            
        }
        
        
        touchSpot = childNodeWithName("touchSpot") as! SKSpriteNode
        let touchSpotTexture = (touchSpot.texture)
        touchSpot.physicsBody = SKPhysicsBody(texture: touchSpotTexture!, size: touchSpotTexture!.size())
        touchSpot.physicsBody?.affectedByGravity = false
        touchSpot.physicsBody!.categoryBitMask = PhysicsCategory.Spot
        touchSpot.physicsBody!.contactTestBitMask = PhysicsCategory.None
        touchSpot.physicsBody!.collisionBitMask = PhysicsCategory.None
        

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchSpot.physicsBody!.contactTestBitMask = PhysicsCategory.Hex
        spotLocation(touches)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        spotLocation(touches)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchSpot.physicsBody!.contactTestBitMask = PhysicsCategory.None

    }
    
     func spotLocation(touches: Set<UITouch>) {
        if let touch = touches.first as UITouch! {
            touchSpot.position = touch.locationInNode(self)
        }

        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == PhysicsCategory.Spot | PhysicsCategory.Hex  {
            let thisHex = (contact.bodyA.categoryBitMask == PhysicsCategory.Hex) ?
                contact.bodyA.node :
                contact.bodyB.node
            if let aHex = thisHex as? HexNode {
                aHex.changeSomething()
            }

            
        }

    }
    
    func didEndContact(contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == PhysicsCategory.Spot | PhysicsCategory.Hex  {
            let thisHex = (contact.bodyA.categoryBitMask == PhysicsCategory.Hex) ?
                contact.bodyA.node :
                contact.bodyB.node
            if let aHex = thisHex as? HexNode {
                aHex.unChangeSomething()
            }
            
        }

    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
