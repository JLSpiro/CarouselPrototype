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


struct GameState {
    static let watching = 0
    static let drawing = 1
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    var currentLevel: Int = 0
    var touchSpot: SKSpriteNode!
    var hexArray: NSMutableArray = []
    var hexNumber: Int = 0
    var state: Int!
    var text: SKSpriteNode!
    var wrongStep: Int = 0
    
    override func didMoveToView(view: SKView) {
        
        state = GameState.watching
        hexNumber = 0
        physicsWorld.contactDelegate = self
        //view.showsPhysics = true
   

        text = childNodeWithName("text") as! SKSpriteNode
        text.runAction(SKAction.fadeAlphaTo(0.7, duration: 0.01))
        
        enumerateChildNodesWithName("//tile_body") {node, _ in
            let aTile = node as! TileNode
            aTile.setUp()
            
        }

        touchSpot = childNodeWithName("touchSpot") as! SKSpriteNode
        let touchSpotTexture = (touchSpot.texture)
        touchSpot.physicsBody = SKPhysicsBody(texture: touchSpotTexture!, size: touchSpotTexture!.size())
        touchSpot.physicsBody?.affectedByGravity = false
        touchSpot.physicsBody!.categoryBitMask = PhysicsCategory.Spot
        touchSpot.physicsBody!.contactTestBitMask = PhysicsCategory.None
        touchSpot.physicsBody!.collisionBitMask = PhysicsCategory.None
        touchSpot.hidden = true
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchSpot.physicsBody!.contactTestBitMask = PhysicsCategory.Hex
        spotLocation(touches)

    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        spotLocation(touches)
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        userInteractionEnabled = false
        
        touchSpot.physicsBody!.contactTestBitMask = PhysicsCategory.None
        runAction(SKAction.sequence([SKAction.waitForDuration(1.5),SKAction.runBlock(changeState)]))
 
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
            
            if let aTile = thisHex as? TileNode{
                if state == GameState.watching && !aTile.touched{
                    aTile.changeSomething(true)
                    hexArray.addObject(aTile)
                    print("hex count \(hexArray.count)")
                    
                    
                }

                if state == GameState.drawing && !aTile.touched{
                    if aTile == hexArray.objectAtIndex(hexNumber) as! TileNode{
                        aTile.changeSomething(true)
                        print("right tile")
                    
                        if hexNumber < (hexArray.count - 1){
                            hexNumber = hexNumber + 1
        
                        }
                        else if hexNumber == (hexArray.count - 1){
                            print("YOU WON !!!!!")
                            runAction(SKAction.sequence([SKAction.waitForDuration(0.7), SKAction.runBlock(winGame)]))
                        }
                        
                    }else{
                        aTile.changeSomething(false)
                        if wrongStep < 1{
                            wrongStep++
                            print("WRONG")
                            

                        }else{
                            print("You LOSE")
                            userInteractionEnabled = false
                            runAction(SKAction.sequence([SKAction.waitForDuration(0.7), SKAction.runBlock(loseGame)]))
                        }
                        
                    }
                    
                }
  
            }
   
        }

    }
    
    func didEndContact(contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == PhysicsCategory.Spot | PhysicsCategory.Hex  {
            let thisHex = (contact.bodyA.categoryBitMask == PhysicsCategory.Hex) ?
                contact.bodyA.node :
                contact.bodyB.node
            if let aTile = thisHex as? TileNode{
                aTile.unChangeSomething()
            }

        }

    }
    
    func changeState(){
        userInteractionEnabled = true
        enumerateChildNodesWithName("//tile_body") {node, _ in
            let aTile = node as! TileNode
            aTile.lock()
            
        }

        
        if state == GameState.drawing{
            state = GameState.watching
            text.texture = SKTexture(imageNamed: "Text Comp_00000")//watching
            hexArray = []
            hexNumber = 0
        }
        else if state == GameState.watching{
            state = GameState.drawing
            text.texture = SKTexture(imageNamed: "Text Comp_00001")//drawing
            
        }

    }
    
    func winGame(){
        for var i = 0; i < hexArray.count; ++i{
            let aTile = hexArray.objectAtIndex(i) as! TileNode
            aTile.lightUp()
            
        }
        
        
        text.texture = SKTexture(imageNamed: "Text Comp_00002")
        wrongStep = 0
    }
    
    func loseGame(){
        enumerateChildNodesWithName("//tile_body") {node, _ in
            let aTile = node as! TileNode
            aTile.changeSomething(false)
        }
        text.texture = SKTexture(imageNamed: "Text Comp_00003")//wrong
        wrongStep = 0
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
