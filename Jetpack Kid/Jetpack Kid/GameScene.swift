//
//  GameScene.swift
//  Jetpack Kid
//
//  Created by Jesse Spiro on 5/10/16.
//  Copyright (c) 2016 Jesse Spiro. All rights reserved.
//

import SpriteKit
import Foundation

struct PhysicsCategory {
    static let None:  UInt32 = 0
    static let Hero:   UInt32 = 0b1 // 1
    static let Wall: UInt32 = 0b10 // 2
    static let Ground: UInt32 = 0b100 // 4
    static let Target:  UInt32 = 0b1000 // 8
    static let Bullet: UInt32 = 0b10000 // 16
    static let FuelTank: UInt32 = 0b100000 // 32
    static let Robot:  UInt32 = 0b1000000 // 64
  //  static let KeyHole: UInt32 = 0b10000000 //128
    
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var cameraNode: SKCameraNode!
    let keeper = SharedKeeper.sharedInstance
    var joyStick: Joystick!
    var trigger: Trigger!
    var fuelGauge: FuelGauge!
    var hero:Hero!
    var prevDirection: Int!
    
    var joyStickPos: CGPoint!
    

    
    override func didMoveToView(view: SKView) {
        userInteractionEnabled = true
        
        physicsWorld.contactDelegate = self
        view.showsPhysics = true
        
        cameraNode = childNodeWithName("CameraNode") as! SKCameraNode
        
        camera = cameraNode
        
        joyStick = childNodeWithName("//joyNode") as! Joystick
        joyStick.setUp()
        
        
        trigger = childNodeWithName("//triggerNode") as! Trigger
        trigger.setUp()
        
        fuelGauge = childNodeWithName("//fuelGaugeNode") as! FuelGauge
        fuelGauge.setUp()
        
        hero = childNodeWithName("//heroNode") as! Hero
        hero.setUp()
  
        
        enumerateChildNodesWithName("//fuelTankNode") {node, _ in
            let aTank = node as! FuelTank
            aTank.setUp()
            
        }
        enumerateChildNodesWithName("//bigBotNode") {node, _ in
            let aBot = node as! BigBot
            aBot.setUp()
            
        }


 }
    
 
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        for touch in touches {
            if trigger.isTouchingTrigger(touch) == true {
                shoot()
            }
        }

     }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
     //   print("\(joyStick.jetVector.dy)")
        cameraNode.position = convertPoint(hero.heroPos, fromNode: hero)
        fuelGauge.setLevel()
          
        enumerateChildNodesWithName("bullet") {node, _ in
            let aBullet = node as! Bullet
            let aRing = GlowRing()
            aRing.setUp()
            aRing.position = aBullet.position
            self.addChild(aRing)
            
            
        }
        
        prevDirection = hero._direction
        if hero._currentState == state.flying{
            if joyStick.jetVector.dx < 0 {
                hero._direction = 0
            }else if joyStick.jetVector.dx > 0{
                hero._direction = 1
            }else if joyStick.jetVector.dx == 0 {
                   hero._direction = prevDirection
            }
        }

        
        if joyStick.jetVector.dy > 60.0 {
            if keeper.fuelLevel > 0 {
                fuelGauge.burn(joyStick.jetVector.dy)
                let rand:CGFloat = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
                hero._jetFire.alpha = 0.5 + rand

                if hero._currentState == state.stopped {
                    hero.changeState(state.lifting)
                    
                }
                if hero._currentState == state.lifting || hero._currentState == state.flying{
                    hero.physicsBody?.applyForce(joyStick.jetVector * 10)
                }
             }
            
            if keeper.fuelLevel <= 0 {
                hero._jetFire.alpha = 0.0
            }
            
            
        }
        if joyStick.jetVector.dy <= 60 {
            hero._jetFire.alpha = 0.0
            if abs(joyStick.jetVector.dx) > 5 {
                if hero._currentState == state.stopped{
                    hero.changeState(state.walking)
                    if joyStick.jetVector.dx < 0 {
                        hero._direction = 0
                    }else if joyStick.jetVector.dx > 0{
                        hero._direction = 1
                    }else if joyStick.jetVector.dx == 0 {
                        hero._direction = prevDirection
                    }

                    //force for walking is applied in Hero class
                }
            }
            
        }
        
        
    }

    
    func shoot(){
        
 
        if hero._currentState == state.flying {
            hero.shootFlying()
        }
        
      //  let bullet:SKSpriteNode = SKSpriteNode(imageNamed: "laser")
        let bullet:Bullet = Bullet()
        bullet.setUp(hero._direction)
        bullet.setScale(0.7)
        bullet.blendMode = SKBlendMode.Screen
        
        if hero._direction == 0 {
            bullet.position = convertPoint(hero.shootLPos, fromNode: hero)
        }
        if hero._direction == 1 {
            bullet.position = convertPoint(hero.shootRPos, fromNode: hero)
        }

        
       // bullet.position = convertPoint(hero.heroPos, fromNode: hero)
        
        bullet.zPosition = 2
        addChild(bullet)
        
        if hero._direction == 0{
            
            bullet.physicsBody?.applyForce(CGVector(dx: -50000, dy: 0))
        }
        if hero._direction == 1{
            bullet.physicsBody?.applyForce(CGVector(dx: 50000, dy: 0))
        }


        
        
    }

    
    func didBeginContact(contact: SKPhysicsContact) {

        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == PhysicsCategory.Hero | PhysicsCategory.Target  {
           
        }
        
        if collision == PhysicsCategory.Hero | PhysicsCategory.Wall  {
 

        }

        
        if collision == PhysicsCategory.Hero | PhysicsCategory.Ground  {
            if hero._currentState != state.landing{
                hero.changeState(state.landing)

            }
            hero.grounded = true
            let hit = contact.collisionImpulse
            hero._landingForce = hit
        }
        
        if collision == PhysicsCategory.Hero | PhysicsCategory.FuelTank {
            let aTank = (contact.bodyA.categoryBitMask == PhysicsCategory.FuelTank) ?
                contact.bodyA.node :
                contact.bodyB.node
            let thisTank = aTank as! FuelTank
            thisTank.turnOn()
             
        }
        
        if collision == PhysicsCategory.Bullet | PhysicsCategory.Wall {
            let aBullet = (contact.bodyA.categoryBitMask == PhysicsCategory.Bullet) ?
                contact.bodyA.node :
                contact.bodyB.node
            aBullet?.removeFromParent()
        }
        

    }
    
    
    func didEndContact(contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == PhysicsCategory.Hero | PhysicsCategory.Ground  {
            hero.grounded = false
            
        }
/*
        if collision == PhysicsCategory.Hero | PhysicsCategory.FuelTank {
            let aTank = (contact.bodyA.categoryBitMask == PhysicsCategory.FuelTank) ?
                contact.bodyA.node :
                contact.bodyB.node
            let thisTank = aTank as! FuelTank
            if refueling == true {
                refueling = false
                thisTank.turnOff()
            }
            
        }
*/
        
 
    }
    
    
    

}

