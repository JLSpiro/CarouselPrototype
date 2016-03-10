//
//  TileNode.swift
//  DrawingGame
//
//  Created by Jesse Spiro on 3/4/16.
//  Copyright © 2016 Jesse Spiro. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation


class TileNode: SKSpriteNode {
    
    var fingerTexture = SKSpriteNode(imageNamed: "fingerTexture")
    var edgeTexture = SKSpriteNode(imageNamed: "hexEdge")

    var touched = false
    
    
     func setUp(){
        touched = false
        let hexBodyTexture = SKTexture(imageNamed: "hexBody")
        physicsBody = SKPhysicsBody(texture: hexBodyTexture, size: hexBodyTexture.size())
        physicsBody?.affectedByGravity = false
        physicsBody?.pinned = true
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = PhysicsCategory.Hex
        physicsBody?.collisionBitMask = PhysicsCategory.None
        
        fingerTexture = childNodeWithName("fingerPrint") as! SKSpriteNode

        fingerTexture.zPosition = 2
        fingerTexture.alpha = 0
        fingerTexture.blendMode = SKBlendMode.Screen
        fingerTexture.name = "fingerTexture"
     
        edgeTexture = childNodeWithName("edge") as! SKSpriteNode
        edgeTexture.alpha = 0
        edgeTexture.zPosition = 2
        edgeTexture.blendMode = SKBlendMode.Add
        edgeTexture.name = "edge"
        
        let changeColorAction = SKAction.colorizeWithColor(SKColor.greenColor(), colorBlendFactor: 1.0, duration: 0.5)
        edgeTexture.runAction(changeColorAction)

    
    

    }
    
    func changeSomething(){
        if (!touched){
            
            touched = true
            
            let lockDownAction = SKAction.sequence([SKAction.scaleTo(0.95, duration: 1.0), SKAction.scaleTo(1.0, duration: 1.0)])
            //let edgeUpAction = SKAction.runAction(SKAction.fadeAlphaTo(0.5, duration: 0.5), onChildWithName: "edge")
            fingerTexture.runAction(SKAction.sequence([SKAction.fadeAlphaTo(1.0, duration: 1.0),SKAction.waitForDuration(1.5)]))
            let groupAction = SKAction.group([lockDownAction,SKAction.rotateByAngle(1.0472, duration: 2.0)])
 
            runAction(groupAction)
        }
    }
    
    
    func unChangeSomething(){
    
        
    }
    
    func lock(){
        touched = true
        let flipAction1 = SKAction.scaleXTo(0.0, y: 1.0, duration: 0.75)
        flipAction1.timingMode = SKActionTimingMode.EaseInEaseOut
        let flipAction2 = SKAction.scaleXTo(1.0, y: 1.0, duration: 0.75)
        flipAction2.timingMode = SKActionTimingMode.EaseInEaseOut
        
        
        let fingerAction = SKAction.runAction(SKAction.fadeAlphaTo(0.0, duration: 0.5), onChildWithName: "fingerTexture")
      //  let edgeDownAction = SKAction.runAction(SKAction.fadeAlphaTo(0.0, duration: 0.2), onChildWithName: "edge")
        
        
        runAction(SKAction.sequence([SKAction.waitForDuration(2.0), fingerAction, flipAction1, flipAction2, SKAction.runBlock(self.reset)]))
     
    }
    
    func reset(){
        touched = false
        
    }
    
    
    
    
}
