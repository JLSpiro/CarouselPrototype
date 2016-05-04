//
//  GameScene.swift
//  MarbleKey
//
//  Created by Jesse Spiro on 4/20/16.
//  Copyright (c) 2016 Jesse Spiro. All rights reserved.
//

import CoreMotion
import SpriteKit
import Foundation

struct PhysicsCategory {
    static let None:  UInt32 = 0
    static let Ball:   UInt32 = 0b1 // 1
    static let Wall: UInt32 = 0b10 // 2
    static let Key: UInt32 = 0b100 // 4
    static let Target:  UInt32 = 0b1000 // 8
    static let Trigger: UInt32 = 0b10000 // 16
    static let Door:UInt32 = 0b100000 // 32
    static let Exit:  UInt32 = 0b1000000 // 64
    static let KeyHole: UInt32 = 0b10000000 //128
    
}



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var player: SKSpriteNode!
    var key: SKSpriteNode!
    var keyHole: SKSpriteNode!
    var spot: SKSpriteNode!
    var trigger: SKSpriteNode!
    var door: SKSpriteNode!
    var targetField: SKFieldNode!
    var spinJoint: SKPhysicsJointPin!
    var lastTouchPosition: CGPoint?
    var motionManager: CMMotionManager!
    var linked = false
    var currentRoom: Int = 1
    

    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
     //   view.showsPhysics = true
        trigger = childNodeWithName("trigger") as! SKSpriteNode
        createPlayer()
        createKey()
        
        spot = childNodeWithName("spot") as! SKSpriteNode
        keyHole = childNodeWithName("keyHole") as! SKSpriteNode
        door = childNodeWithName("door") as! SKSpriteNode
        
        targetField = childNodeWithName("targetField") as! SKFieldNode
        targetField.enabled = true
        
        spot.position = targetField.position
        
        linked = false
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        
    }
    
    func createPlayer(){
        
        player = childNodeWithName("player") as! SKSpriteNode
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 8.0
        player.physicsBody?.restitution = 0.5
        player.physicsBody?.friction = 0.2
        player.physicsBody?.mass = 8.0
        player.physicsBody?.categoryBitMask = PhysicsCategory.Ball
        player.physicsBody?.collisionBitMask = PhysicsCategory.Wall | PhysicsCategory.Door | PhysicsCategory.KeyHole
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Exit
        player.physicsBody?.fieldBitMask = PhysicsCategory.Target
        
     
    }
    
    func createKey(){
        
        key = childNodeWithName("key") as! SKSpriteNode
        key.physicsBody?.dynamic = true
        key.physicsBody?.pinned = true
        key.physicsBody?.allowsRotation = false
        key.physicsBody?.linearDamping = 10.0
        key.physicsBody?.restitution = 0.2
        key.physicsBody?.friction = 1.0
        key.physicsBody?.mass = 20.0
        key.physicsBody?.categoryBitMask = PhysicsCategory.Key
        key.physicsBody?.collisionBitMask = PhysicsCategory.Wall
        key.physicsBody?.contactTestBitMask = PhysicsCategory.Trigger
    
  
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        let location = touch.locationInNode(self)
        lastTouchPosition = location
        
     }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        let location = touch.locationInNode(self)
        lastTouchPosition = location

    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == PhysicsCategory.Key | PhysicsCategory.Trigger  {
            unLock()
        }
        
        if collision == PhysicsCategory.Ball | PhysicsCategory.Exit {
            if currentRoom == 1 {
                currentRoom = 2
            }else if currentRoom == 2 {
                currentRoom = 1
            }
            newGame(currentRoom)
        }
    }
    
    func unLock(){
        scene!.physicsWorld.removeJoint(spinJoint)
        key.physicsBody?.dynamic = false
        let unLockAction = SKAction.group([SKAction.moveTo(keyHole.position, duration: 0.1),SKAction.rotateToAngle(keyHole.zRotation, duration: 0.01)])
        key.runAction(SKAction.sequence([SKAction.waitForDuration(0.1),unLockAction]))
        let openAction = SKAction(named: "open")!
        door.runAction(SKAction.sequence([SKAction.waitForDuration(1.5),openAction]))
        
    }
    
    func linkUp(){
        player.physicsBody?.dynamic = false
        player.position = spot.position
        targetField.enabled = false
        spinJoint = SKPhysicsJointPin.jointWithBodyA(player.physicsBody!, bodyB: key.physicsBody!, anchor: player.position)
        scene!.physicsWorld.addJoint(spinJoint)
        key.physicsBody?.pinned = false
        key.physicsBody?.affectedByGravity = true
        key.physicsBody?.dynamic = true
        key.physicsBody?.allowsRotation = true
        player.physicsBody?.dynamic = true

    }
    
    func newGame(roomNum: Int) {
        let scene = GameScene(fileNamed: "Room\(roomNum)")!
        scene.scaleMode = .AspectFill
        view!.presentScene(scene)
    }
    
    class func room(roomNum: Int) -> GameScene? {
        let scene = GameScene(fileNamed: "Room\(roomNum)")!
        scene.currentRoom = roomNum
        scene.scaleMode = .AspectFill
        return scene
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        #if (arch(i386) || arch(x86_64))
            
        if let currentTouch = lastTouchPosition {
            let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        
        #else
            if let accelerometerData = motionManager.accelerometerData {
              physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -200, dy: accelerometerData.acceleration.x * 200)
            }
        #endif
        
        if spot.containsPoint(player.position) {
            if linked == false{
                linked = true
                linkUp()
            }
            
        }
        
        
     }
}
