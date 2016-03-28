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
    
    var fingerTexture = SKSpriteNode(imageNamed: "HexFinger_00000")
    var edgeTexture = SKSpriteNode(imageNamed: "HexBody_00000")
    var tileBody = SKSpriteNode(imageNamed: "HexBody_00000")

    var touched = false
    
    
     func setUp(){
        touched = false
        let hexBodyTexture = SKTexture(imageNamed: "HexFinger_00006")
        physicsBody = SKPhysicsBody(texture: hexBodyTexture, size: hexBodyTexture.size())
        physicsBody?.affectedByGravity = false
        physicsBody?.pinned = true
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = PhysicsCategory.Hex
        physicsBody?.collisionBitMask = PhysicsCategory.None

        tileBody = childNodeWithName("tile_body") as! SKSpriteNode
        tileBody.runAction(SKAction.fadeAlphaTo(0.7, duration: 0.1))
        
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
        edgeTexture.runAction(SKAction.colorizeWithColor(UIColor.orangeColor(), colorBlendFactor: 1.0, duration: 0.1))
        
        fadeDown()

    }
    
    func changeSomething(correct: Bool){
        if (!touched){
            if correct {
                touched = true
                let lockDownAction = SKAction.sequence([SKAction.scaleTo(0.95, duration: 0.5), SKAction.scaleTo(1.0, duration: 0.5)])
                let blurAction = SKAction(named: "blur")!
                //
                fingerTexture.runAction(blurAction)
                fingerTexture.runAction(SKAction.sequence([SKAction.fadeAlphaTo(1.0, duration: 0.7),SKAction.waitForDuration(0.5),SKAction.fadeAlphaTo(0.0, duration: 2.0)]))
                
                tileBody.runAction(lockDownAction)
                tileBody.runAction(SKAction.colorizeWithColor(UIColor.orangeColor(), colorBlendFactor: 1.0, duration: 0.5))
                
            }else{
                //run other action
                touched = true
                tileBody.runAction(SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.3))
            }
            
        }
    }
    
    
    func unChangeSomething(){
    
        
    }
    
    func lock(){
        
        touched = true
 
        let edgeDownAction = SKAction.runAction(SKAction.fadeAlphaTo(0.0, duration: 0.5), onChildWithName: "edge")
        runAction(edgeDownAction)
        let colorAction = SKAction.colorizeWithColor(UIColor.orangeColor(), colorBlendFactor: 0.0, duration: 0.1)
        
        //runAction(SKAction.rotateByAngle(1.0472, duration: 1.0))
        tileBody.runAction(SKAction.group([SKAction(named: "flip")!,colorAction,  SKAction.runBlock(self.reset)]))
     
    }
    
    func lightUp(){
        let changeColorAction = SKAction.colorizeWithColor(SKColor.greenColor(), colorBlendFactor: 1.0, duration: 0.2)
        edgeTexture.runAction(changeColorAction)
        tileBody.runAction(changeColorAction)

        let edgeUpAction = SKAction.runAction(SKAction.fadeAlphaTo(0.5, duration: 0.5), onChildWithName: "edge")
        tileBody.runAction(edgeUpAction)
    }
    
    func fadeDown(){
        tileBody.runAction(SKAction.fadeAlphaTo(0.2, duration: 1.0))
    }
    
    func fadeUp(){
        tileBody.runAction(SKAction.fadeAlphaTo(0.7, duration: 1.0))
    }
    
    func reset(){
        touched = false
        
    }
    
    
    
    
}
