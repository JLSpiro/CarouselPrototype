//
//  BigBot.swift
//  JetPackKid
//
//  Created by Jesse Spiro on 6/3/16.
//  Copyright © 2016 Jesse Spiro. All rights reserved.
//

import Foundation
import SpriteKit


class BigBot:SKSpriteNode{
    
    var head:SKSpriteNode!
    var body:SKSpriteNode!
    var physBody: SKSpriteNode!
    var target: SKSpriteNode!
    var targJoint: SKPhysicsJointPin!

    var timer = NSTimer()
    var direction: Int!
    
    var headSpinAnim:[SKTexture] = []
    var headFrame:Int!
    
    func setUp(){
        head = childNodeWithName("head") as! SKSpriteNode
        body = childNodeWithName("body") as! SKSpriteNode
        physBody = childNodeWithName("physBody") as! SKSpriteNode
        target = childNodeWithName("target") as! SKSpriteNode
        physBody.hidden = true
     //   target.hidden = true
        direction = -1
        headFrame = 0
        

        physicsBody = SKPhysicsBody(texture: physBody.texture!, size: physBody.size)
        physicsBody?.affectedByGravity = true
        physicsBody?.mass = 300.0
        physicsBody?.allowsRotation = false
        physicsBody?.pinned = false
        physicsBody?.dynamic = true
        physicsBody?.friction = 1.0
        physicsBody?.categoryBitMask = PhysicsCategory.Robot
        physicsBody?.collisionBitMask =  PhysicsCategory.Wall | PhysicsCategory.Ground | PhysicsCategory.Bullet
        physicsBody?.contactTestBitMask = PhysicsCategory.Hero | PhysicsCategory.Bullet

   /*
        target.physicsBody = SKPhysicsBody(rectangleOfSize: target.size)
        target.physicsBody?.affectedByGravity = true
        target.physicsBody?.mass = 0
        target.physicsBody?.allowsRotation = true
        target.physicsBody?.pinned = false
        target.physicsBody?.dynamic = true
        target.physicsBody?.friction = 1.0
        target.physicsBody?.categoryBitMask = PhysicsCategory.Target
        target.physicsBody?.collisionBitMask =  PhysicsCategory.Bullet
        target.physicsBody?.contactTestBitMask = PhysicsCategory.Hero | PhysicsCategory.Bullet

        targJoint = SKPhysicsJointPin.jointWithBodyA(target.physicsBody!, bodyB: self.physicsBody!, anchor: target.position)
 
        parent!.scene!.physicsWorld.addJoint(targJoint)

     */   


        for i in 1...24 {
            headSpinAnim.append(SKTexture(imageNamed: "bigBotHead\(i)"))
        }
        

        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.75, target: self, selector: #selector(stepForward), userInfo: nil, repeats: true)
 
    }
    
    func reverse(){
        if direction == -1 {
            direction = 1
        }else if direction == 1 {
            direction = -1
        }
    }
    

    func stepForward(){
 
        physicsBody?.velocity = CGVector(dx: 220 * direction, dy: 0)
    }
    
    func turnHead(face:Int){
        
        if face == 1 && headFrame < 23 {
            headFrame = headFrame + 1
        }
        
        if face == 0 && headFrame > 0 {
            headFrame = headFrame - 1
        }
        
        head.texture = headSpinAnim[headFrame]

        
    }
    
    func blowUp(){
        print("blow up")
        timer.invalidate()
        let smoke:SKEmitterNode = SKEmitterNode(fileNamed: "Smoke")!
        smoke.position = target.position
        addChild(smoke)
        let endAction = SKAction.sequence([SKAction.waitForDuration(0.5), SKAction.removeFromParent()])
        smoke.runAction(endAction)

        
    }
    
    
    
    
    
    
    
    
}