//
//  GameScene.swift
//  DrawingGame
//
//  Created by Jesse Spiro on 2/13/16.
//  Copyright (c) 2016 Jesse Spiro. All rights reserved.
//

import SpriteKit
import Foundation
import AVFoundation



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
    static let UP = 1
    static let DOWN = 0


    var currentLevel: Int = 0
    var touchSpot: SKSpriteNode!
    var hexArray: NSMutableArray = []
    var hexNumber: Int = 0
    var state: Int!
    var text: SKSpriteNode!
    var wrongStep: Int = 0
    var hand: SKSpriteNode!
    var wiper: SKSpriteNode!
    var eyeLeft: SKSpriteNode!
    var eyeRight: SKSpriteNode!
    
    var tilePosArrayA: NSMutableArray = []
    var tilePosArrayB: NSMutableArray = []
    var tilePosArrayC: NSMutableArray = []
    var tilePosArrayD: NSMutableArray = []
    var tilePosArrayE: NSMutableArray = []
    var totalTileArray: NSMutableArray = []
    
    var currentColumn: Int!
    var currentRow: Int!
    var lastColumn: Int!
    
    var handPos: CGPoint = CGPointZero
    var randomSequence: NSMutableArray = []
    var lastRandNum: Int!
    
    override func didMoveToView(view: SKView) {
        
        // guess what this is for ;)
        var bkgMusicPlayer = AVAudioPlayer()
        var initialTouchSoundPlayer = AVAudioPlayer()
        
        // load up the background music file and start playing
        let pathToBkgMusic = NSBundle.mainBundle().pathForResource("Crystal", ofType:"mp3")
        if let pathToBkgMusic = pathToBkgMusic {
            let bkgMusicURL = NSURL(fileURLWithPath: pathToBkgMusic)
            do {
                try bkgMusicPlayer = AVAudioPlayer(contentsOfURL: bkgMusicURL)
                bkgMusicPlayer.play()
                bkgMusicPlayer.volume = 1
            } catch {
                print("Error loading bkg music")
            }
        }
        // first player touch makes a nice little sound
        let pathToInitialTouchSound = NSBundle.mainBundle().pathForResource("wow", ofType: "mp3")
        if let pathToInitialTouchSound = pathToInitialTouchSound {
            let initTouchURL = NSURL(fileURLWithPath: pathToInitialTouchSound)
            do {
                try initialTouchSoundPlayer = AVAudioPlayer(contentsOfURL: initTouchURL)
                initialTouchSoundPlayer.play()
                initialTouchSoundPlayer.volume = 1
            } catch {
                print("Error loading touch sound")
            }
        }

        
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

        for i in 0...4{
            let aTile = childNodeWithName("tileA\(i)") as SKNode!
            self.tilePosArrayA.addObject(aTile)
        }
        
        for i in 0...5{
            let aTile = childNodeWithName("tileB\(i)") as SKNode!
            self.tilePosArrayB.addObject(aTile)
        }
        
        for i in 0...6{
            let aTile = childNodeWithName("tileC\(i)") as SKNode!
            self.tilePosArrayC.addObject(aTile)
        }
        for i in 0...5{
            let aTile = childNodeWithName("tileD\(i)") as SKNode!
            self.tilePosArrayD.addObject(aTile)
        }
        for i in 0...4{
            let aTile = childNodeWithName("tileE\(i)") as SKNode!
            self.tilePosArrayE.addObject(aTile)
        }

        totalTileArray = [tilePosArrayA,tilePosArrayB,tilePosArrayC,tilePosArrayD,tilePosArrayE]

        
        hand = childNodeWithName("hand") as! SKSpriteNode
        hand.runAction(SKAction.repeatActionForever(SKAction(named: "handWait")!),withKey: "handWait" )
        handPos = hand.position
        hand.runAction(SKAction.fadeAlphaTo(0.7, duration: 0.1))
      // hand.color = SKColor.blueColor()
     //   hand.colorBlendFactor = 0.2
        
        eyeLeft = childNodeWithName("eyeLeft") as! SKSpriteNode
        eyeRight = childNodeWithName("eyeRight") as! SKSpriteNode

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
        runAction(SKAction.sequence([SKAction.waitForDuration(1.5),SKAction.runBlock({self.handMove(0)})]))
        eyeRight.runAction(SKAction(named: "lookUp")!)
        eyeLeft.runAction(SKAction(named: "lookUp")!)
    }
    
    func generateSequence() {
        randomSequence = []
        let randomTile = generateRandomTile()
        randomSequence.addObject(randomTile)
        var sameTile = false
      //  var eventCount = 0

        for _ in 0...currentLevel {
 
            let nextTile = tileStep()
            for n in 0...(randomSequence.count - 1){
                
                if nextTile == randomSequence.objectAtIndex(n) as! NSObject{
                    sameTile = true
                }
 
            }
            
            if sameTile == true {
                continue
            }else{
               randomSequence.addObject(nextTile)
            }
            
        }
        
//This is where I get errors every time
//while true loop sends each tile through testTile() to check against existing array
        
 /*
        while true {
            let nextTile = tileStep()
            if testTile(nextTile) == false{
                randomSequence.addObject(nextTile)
                eventCount += 1
            }
            if eventCount == currentLevel{
                break
            }
        }
*/
    }
    
    
 /*
    func testTile(tile: NSObject) -> Bool{
        var sameTile = false
        for n in 0...(randomSequence.count - 1){
            if tile == randomSequence.objectAtIndex(n) as! NSObject{
                sameTile = true
            }
            
        }
        
        return sameTile
        
    }
*/
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
        
        lastColumn = currentColumn
        
        
        let randNum = Int(arc4random_uniform(3))
        if randNum < 1 && currentColumn > 0 {
            currentColumn = currentColumn - 1
        }
            
        else if randNum > 1 && currentColumn < (totalTileArray.count - 1) {
            currentColumn = currentColumn + 1
        }
        //else currentColumn stays the same
        
        let randRow = Int(arc4random_uniform(2))
        

        if randRow == 0 && currentRow > 0 {
            //account for staggered columns
            if totalTileArray.objectAtIndex(currentColumn).count <= totalTileArray.objectAtIndex(lastColumn).count{
                currentRow = currentRow - 1
            }
        }
        else if randRow == 1 && currentRow < (totalTileArray.objectAtIndex(currentColumn).count - 1){
            //account for staggered columns
            if totalTileArray.objectAtIndex(currentColumn).count >= totalTileArray.objectAtIndex(lastColumn).count{
                currentRow = currentRow + 1
            }
            
        }

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
                        //aTile.physicsBody?.affectedByGravity = true
                        if wrongStep < 1{
                            wrongStep += 1
                            

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
                //aTile.lock()
                if state == GameState.watching{
                    aTile.lockDown()
                }
                if state == GameState.drawing{
                    aTile.lockUp()
                }
            }
        }

    }
    
    func changeState(){
        
        enumerateChildNodesWithName("//tileNode") {node, _ in
           let aTile = node as! TileNode
            aTile.lock()

        }
        
        

    //watching
        if state == GameState.drawing{
            userInteractionEnabled = false
            state = GameState.watching
            if currentLevel < 6{
                currentLevel += 1
            }
            else{
                currentLevel = 0
            }
            print("level \(currentLevel)")
            
           // wiper.runAction(SKAction.rotateByAngle(3.1415, duration: 1.5))
            let  changeAction = SKAction.setTexture(SKTexture(imageNamed: "Text Comp_00000"))
            text.runAction(SKAction.sequence([SKAction.fadeAlphaTo(0.0, duration: 0.5), changeAction, SKAction.fadeAlphaTo(1.0, duration: 0.5)]))

            hexArray = []
            hexNumber = 0
            
            enumerateChildNodesWithName("//tileNode") {node, _ in
                let aTile = node as! TileNode
                aTile.fadeDown()
                
            }
 
            eyeRight.runAction(SKAction(named: "lookUp")!)
            eyeLeft.runAction(SKAction(named: "lookUp")!)

            generateSequence()
            runAction(SKAction.sequence([SKAction.waitForDuration(1.5),SKAction.runBlock({self.handMove(0)})]))
            
         }
            
    //drawing
        else if state == GameState.watching{
            state = GameState.drawing
            userInteractionEnabled = true
          //  wiper.runAction(SKAction.rotateByAngle(3.1415, duration: 1.5))
            let  changeAction = SKAction.setTexture(SKTexture(imageNamed: "Text Comp_00001"))
            text.runAction(SKAction.sequence([SKAction.fadeAlphaTo(0.0, duration: 0.5), changeAction, SKAction.fadeAlphaTo(1.0, duration: 0.5)]))
            
            enumerateChildNodesWithName("//tileNode") {node, _ in
                let aTile = node as! TileNode
                aTile.fadeUp()
                
            }
 
            eyeRight.runAction(SKAction(named: "lookDown")!)
            eyeLeft.runAction(SKAction(named: "lookDown")!)


        }
        
 

    }
    
    func winGame(){
        for i in 0...(hexArray.count - 1){
            let aTile = hexArray.objectAtIndex(i) as! TileNode
            aTile.lightUp()
            
        }
        
        let  changeAction = SKAction.setTexture(SKTexture(imageNamed: "Text Comp_00002"))
        text.runAction(changeAction)
        wrongStep = 0
    }
    
    func loseGame(){
        
        enumerateChildNodesWithName("//tileNode") {node, _ in
            let aTile = node as! TileNode
            aTile.changeSomething(false)
        }
 
        let  changeAction = SKAction.setTexture(SKTexture(imageNamed: "Text Comp_00003"))
        text.runAction(changeAction)
        wrongStep = 0
    }
    
    override func update(currentTime: CFTimeInterval) {
        if state == GameState.watching{
            touchSpot.position = hand.position
        }
        
    }
    
    func handTouchSpot(){
        touchSpot.physicsBody!.contactTestBitMask = PhysicsCategory.Hex
    }
    
    func handUntouchSpot(){
        touchSpot.physicsBody!.contactTestBitMask = PhysicsCategory.None
    }
    

    
    func handMove(place: Int){
        let wait = SKAction.waitForDuration(0.4)
        if place == 0 {
            hand.removeActionForKey("handWait")
            let touchAction = SKAction.group([SKAction(named: "handTouch")!,SKAction.fadeAlphaTo(1.0, duration: 0.6),SKAction.moveTo(randomSequence.objectAtIndex(0).position, duration: 1.0)])
            let firstMove = SKAction.sequence([touchAction,SKAction.runBlock(handTouchSpot),SKAction.runBlock(handPoint),wait,SKAction.runBlock{(self.handMoveCount(place))}])
            hand.runAction(firstMove)
        }
        else if place < (randomSequence.count - 1){
            let move = SKAction.moveTo(randomSequence.objectAtIndex(place).position, duration: 1.0)
            hand.runAction(SKAction.sequence([move, wait, SKAction.runBlock{(self.handMoveCount(place))}]))
            
        }
        else if place == (randomSequence.count - 1){
            let move = SKAction.moveTo(randomSequence.objectAtIndex(place).position, duration: 1.0)
            let untouch = SKAction.group([SKAction.runBlock(handStopPointing), SKAction(named: "handReturn")!,SKAction.fadeAlphaTo(0.5, duration: 0.6), SKAction.moveTo(handPos, duration: 1.0), SKAction.runBlock(changeState)])
            hand.runAction(SKAction.sequence([move, wait, untouch]))
        }

        

        
    }
    
    func handMoveCount(place: Int){
        let nextPlace = place + 1
        self.handMove(nextPlace)
    }
    
    func handWaitAgain(){
        hand.runAction(SKAction.repeatActionForever(SKAction(named: "handWait")!),withKey: "handWait" )
    }
    
    func handPoint(){
        hand.runAction(SKAction.repeatActionForever(SKAction(named: "point")!),withKey: "point" )    }
    
    func handStopPointing(){
        hand.removeActionForKey("point")
    }
 }
