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
    static let Wiper: UInt32 = 0b100 // 4
}


struct GameState {
    static let watching = 0
    static let drawing = 1
}

struct Direction {
    static let U: Int = 0
    static let UR: Int = 1
    static let DR: Int = 2
    static let D: Int = 3
    static let DL: Int = 4
    static let UL: Int = 5
}


class GameScene: SKScene, SKPhysicsContactDelegate {

    var currentLevel: Int = 0
    var touchSpot: SKSpriteNode!
    var hexArray: NSMutableArray = []
    var hexNumber: Int = 0
    var state: Int!
    var text: SKSpriteNode!
    var wrongStep: Int = 0
    var hand: SKSpriteNode!
    var wiper: SKSpriteNode!
    
    var tilePosArrayA: NSMutableArray = []
    var tilePosArrayB: NSMutableArray = []
    var tilePosArrayC: NSMutableArray = []
    var tilePosArrayD: NSMutableArray = []
    var tilePosArrayE: NSMutableArray = []
    var totalTileArray: NSMutableArray = []
    
    var currentColumn: Int!
    var currentRow: Int!
    
    var handPos: CGPoint = CGPointZero
    var randomSequence: NSMutableArray = []
    var lastRandNum: Int!
    
    override func didMoveToView(view: SKView) {
        
        state = GameState.watching
        hexNumber = 0
        physicsWorld.contactDelegate = self
        //view.showsPhysics = true
   
        
        text = childNodeWithName("text") as! SKSpriteNode
        text.runAction(SKAction.fadeAlphaTo(0.7, duration: 0.01))
        
        enumerateChildNodesWithName("//tileNode") {node, _ in
            let aTile = node as! TileNode
            aTile.setUp()
            
        }
        
        enumerateChildNodesWithName("tile") {node, _ in
            let aTile = node
            self.tilePosArrayA.addObject(aTile)
        }

        for var i = 0; i <= 4; i += 1{
            let aTile = childNodeWithName("tileA\(i)") as SKNode!
            self.tilePosArrayA.addObject(aTile)
        }
        
        for var i = 0; i <= 5; i += 1{
            let aTile = childNodeWithName("tileB\(i)") as SKNode!
            self.tilePosArrayB.addObject(aTile)
        }
        
        for var i = 0; i <= 6; i += 1{
            let aTile = childNodeWithName("tileC\(i)") as SKNode!
            self.tilePosArrayC.addObject(aTile)
        }
        for var i = 0; i <= 5; i += 1{
            let aTile = childNodeWithName("tileD\(i)") as SKNode!
            self.tilePosArrayD.addObject(aTile)
        }
        for var i = 0; i <= 4; i += 1{
            let aTile = childNodeWithName("tileE\(i)") as SKNode!
            self.tilePosArrayE.addObject(aTile)
        }

        totalTileArray = [tilePosArrayA,tilePosArrayB,tilePosArrayC,tilePosArrayD,tilePosArrayE]

        
        hand = childNodeWithName("hand") as! SKSpriteNode
        hand.runAction(SKAction.repeatActionForever(SKAction(named: "handWait")!),withKey: "handWait" )
        handPos = hand.position
        hand.runAction(SKAction.fadeAlphaTo(0.7, duration: 0.1))

        touchSpot = childNodeWithName("touchSpot") as! SKSpriteNode
        let touchSpotTexture = (touchSpot.texture)
        touchSpot.physicsBody = SKPhysicsBody(texture: touchSpotTexture!, size: touchSpotTexture!.size())
        touchSpot.physicsBody?.affectedByGravity = false
        touchSpot.physicsBody!.categoryBitMask = PhysicsCategory.Spot
        touchSpot.physicsBody!.contactTestBitMask = PhysicsCategory.None
        touchSpot.physicsBody!.collisionBitMask = PhysicsCategory.None
        touchSpot.hidden = true
        
        wiper = childNodeWithName("wiper") as! SKSpriteNode
        
        generateSequence()
        runAction(SKAction.sequence([SKAction.waitForDuration(1.5),SKAction.runBlock(handMove)]))
    }
    
    func generateSequence() {
        
        randomSequence = []
        let randomTile = generateRandomTile()
        randomSequence.addObject(randomTile)
        for var i = 0; i < 5; ++i {
            let nextTile = tileStep()
            randomSequence.addObject(nextTile)
        }
        
    }
    
    func generateRandomTile() -> SKNode{
        let randNum = Int(arc4random_uniform(4))
        let column: NSMutableArray = totalTileArray.objectAtIndex(randNum) as! NSMutableArray
        let columnCount = UInt32(column.count - 1)
        let randStep = Int(arc4random_uniform(columnCount))
        let tile = column.objectAtIndex(randStep)
        currentColumn = randNum
        currentRow = randStep
        
        return tile as! SKNode
    }
    
    func tileStep() -> SKNode{
        
        let randNum = Int(arc4random_uniform(3))
        if randNum < 1 && currentColumn > 0 {
            currentColumn = currentColumn - 1
        }
        else if randNum > 1 && currentColumn < (totalTileArray.count - 1) {
            currentColumn = currentColumn + 1
        }
        
        let randRow = Int(arc4random_uniform(2))
        
        if randRow == 0 && currentRow > 0 {
            currentRow = currentRow - 1
        }
        else if randRow == 1 && currentRow < (totalTileArray.objectAtIndex(currentColumn).count - 1){
            currentRow = currentRow + 1
        }
        
        print("\(totalTileArray.objectAtIndex(currentColumn).count - 1)")
        
        let theColumn = totalTileArray.objectAtIndex(currentColumn) as! NSMutableArray
        let tile =  theColumn.objectAtIndex(currentRow) as! SKNode
        return tile
        
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
                      
                }

                if state == GameState.drawing && !aTile.touched{
                    if aTile == hexArray.objectAtIndex(hexNumber) as! TileNode{
                        aTile.changeSomething(true)
                    
                        if hexNumber < (hexArray.count - 1){
                            hexNumber = hexNumber + 1
        
                        }
                        else if hexNumber == (hexArray.count - 1){
                            userInteractionEnabled = false
                            runAction(SKAction.sequence([SKAction.waitForDuration(0.7), SKAction.runBlock(winGame)]))
                        }
                        
                    }else{
                        aTile.changeSomething(false)
                        if wrongStep < 1{
                            wrongStep++
                            

                        }else{
                            userInteractionEnabled = false
                            runAction(SKAction.sequence([SKAction.waitForDuration(0.7), SKAction.runBlock(loseGame)]))
                        }
                        
                    }
                    
                }
  
            }
   
        }
        if collision == PhysicsCategory.Wiper | PhysicsCategory.Hex {
            let thisHex = (contact.bodyA.categoryBitMask == PhysicsCategory.Hex) ?
                contact.bodyA.node :
                contact.bodyB.node
            if let aTile = thisHex as? TileNode{
                aTile.lock()
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
        
      // wiper.runAction(SKAction.rotateByAngle(6.28319, duration: 4.0))
     //   wiper.runAction(SKAction.rotateByAngle(3.1415, duration: 4.0))

        enumerateChildNodesWithName("//tileNode") {node, _ in
           let aTile = node as! TileNode
            aTile.lock()

        }

    //watching
        if state == GameState.drawing{
            userInteractionEnabled = false
            state = GameState.watching
            text.texture = SKTexture(imageNamed: "Text Comp_00000")//watching
            hexArray = []
            hexNumber = 0
            enumerateChildNodesWithName("//tileNode") {node, _ in
                let aTile = node as! TileNode
                aTile.fadeDown()
                
            }

            generateSequence()
            runAction(SKAction.sequence([SKAction.waitForDuration(1.5),SKAction.runBlock(handMove)]))
            
         }
            
    //drawing
        else if state == GameState.watching{
            state = GameState.drawing
          //  hand.runAction(SKAction.repeatActionForever(SKAction(named: "handWait")!),withKey: "handWait" )
            userInteractionEnabled = true
            text.texture = SKTexture(imageNamed: "Text Comp_00001")//drawing
            enumerateChildNodesWithName("//tileNode") {node, _ in
                let aTile = node as! TileNode
                aTile.fadeUp()
                
            }

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
        enumerateChildNodesWithName("//tileNode") {node, _ in
            let aTile = node as! TileNode
            aTile.changeSomething(false)
        }
        text.texture = SKTexture(imageNamed: "Text Comp_00003")//wrong
        wrongStep = 0
    }
    
    override func update(currentTime: CFTimeInterval) {
        if state == GameState.watching{
            touchSpot.position = hand.position
        }
        
        /* Called before each frame is rendered */
    }
    
    func handTouchSpot(){
        touchSpot.physicsBody!.contactTestBitMask = PhysicsCategory.Hex
    }
    
    func handUntouchSpot(){
        touchSpot.physicsBody!.contactTestBitMask = PhysicsCategory.None
    }
    
    func handLightTile(i: Int){
   //     let aTile = randomSequence.objectAtIndex(i) as! TileNode
     //   aTile.changeSomething(true)
    }
    
    func handMove(){
        
        print("handMove called")
        hand.removeActionForKey("handWait")
        let touchAction = SKAction.group([SKAction(named: "handTouch")!,SKAction.fadeAlphaTo(1.0, duration: 0.6),SKAction.moveTo(randomSequence.objectAtIndex(0).position, duration: 1.0)])
        let firstMove = SKAction.sequence([touchAction,SKAction.runBlock(handTouchSpot)])
        
        let secondMove = SKAction.moveTo(randomSequence.objectAtIndex(1).position, duration: 1.0)
        let thirdMove = SKAction.moveTo(randomSequence.objectAtIndex(2).position, duration: 1.0)
      //  let fourthMove = SKAction.sequence([SKAction.moveTo(randomSequence.objectAtIndex(3).position, duration: 1.0), SKAction.runBlock{(self.handLightTile(3))}])
        let untouch = SKAction.group([SKAction(named: "handReturn")!,SKAction.fadeAlphaTo(0.7, duration: 0.6), SKAction.moveTo(handPos, duration: 1.0), SKAction.runBlock(changeState)])
        let wait = SKAction.waitForDuration(0.4)
        let drawingAction = SKAction.sequence([firstMove,wait,secondMove,wait,thirdMove,wait, SKAction.runBlock(handUntouchSpot),untouch])

        drawingAction.timingMode = SKActionTimingMode.EaseInEaseOut
        hand.runAction(drawingAction)
    }
    
    
 }
