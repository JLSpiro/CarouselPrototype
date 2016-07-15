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
    var hearts: Hearts!
    var hero:Hero!
    var prevDirection: Int!
    var joyStickPos: CGPoint!
    var bulletsToRemove: NSMutableArray!
    

    
    override func didMoveToView(view: SKView) {
        userInteractionEnabled = true
        
        physicsWorld.contactDelegate = self
       // view.showsPhysics = true
        
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
  
        keeper.hitPoints = 4
        
        hearts = childNodeWithName("//heartsNode") as! Hearts
        hearts.setUp()
        hearts.setLives()
        
        bulletsToRemove = []
        
        enumerateChildNodesWithName("//fuelTankNode") {node, _ in
            let aTank = node as! FuelTank
            aTank.setUp()
            
        }
        enumerateChildNodesWithName("//bigBotNode") {node, _ in
            let aBot = node as! BigBot
            aBot.setUp()
        }
        
        enumerateChildNodesWithName("//wallNode") {node, _ in
            let aWall = node as! Wall
            aWall.setUp()
            
        }


    }
 
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        for touch in touches {
            if trigger.isTouchingTrigger(touch) == true {
                print("shoot")
                shoot()
            }
        }

     }
   
    override func update(currentTime: CFTimeInterval) {
        cameraNode.position = convertPoint(hero.heroPos, fromNode: hero)
        fuelGauge.setLevel()
        
        
        
        
        /*
 
        enumerateChildNodesWithName("bullet") {node, _ in
            let aBullet = node as! Bullet
            let aRing = GlowRing()
            aRing.setUp()
            aRing.position = aBullet.position
            self.addChild(aRing)
            
        }
 */
        
        enumerateChildNodesWithName("//bigBotNode") {node, _ in
            let aBot = node as! BigBot
            let botPos:CGPoint = self.convertPoint(CGPointZero, fromNode: aBot)
            let heroPos:CGPoint = self.convertPoint(CGPointZero, fromNode: self.hero)
            if botPos.x < heroPos.x {
                aBot.turnHead(1)
            }
            if botPos.x > heroPos.x {
                aBot.turnHead(0)
            }
        
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
                
                hero.jetOn = true
                
                if hero._currentState == state.stopped {
                    hero.changeState(state.lifting)
                    
                }
                if hero._currentState == state.lifting || hero._currentState == state.flying{
                    hero.physicsBody?.applyForce(joyStick.jetVector * 10)
                }
             }
            
            if keeper.fuelLevel <= 0 {
                hero.jetOn = false
                hero._jetFire.alpha = 0.0
            }
            
            
        }
        if joyStick.jetVector.dy <= 60 {
            hero._jetFire.alpha = 0.0
            if hero.grounded == true {
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

            }else{
                hero._currentState = state.flying
            }
            

            
        }
        
        
    }

    
    func shoot(){
     
        print("func shoot")
 
        if hero._currentState == state.flying {
            hero.shootFlying()
        }
   
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

        bullet.zPosition = 2
        addChild(bullet)
        
        if hero._direction == 0{
            
            bullet.physicsBody?.applyForce(CGVector(dx: -20000, dy: 0))
        }
        if hero._direction == 1{
            bullet.physicsBody?.applyForce(CGVector(dx: 20000, dy: 0))
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

        if collision == PhysicsCategory.Bullet | PhysicsCategory.Robot {
            let aBullet = (contact.bodyA.categoryBitMask == PhysicsCategory.Bullet) ?
                contact.bodyA.node :
                contact.bodyB.node
            let thisBullet = aBullet as! Bullet
            explode(thisBullet.position)
            
            if thisBullet.detectionMade == false{
                thisBullet.detectionMade = true
                explode(thisBullet.position)
                removeBullet(thisBullet)
                
            }
         
        }
        

        if collision == PhysicsCategory.Bullet | PhysicsCategory.Wall {
            let aBullet = (contact.bodyA.categoryBitMask == PhysicsCategory.Bullet) ?
                contact.bodyA.node :
                contact.bodyB.node
            let thisBullet = aBullet as! Bullet
            
            if thisBullet.detectionMade == false{
                thisBullet.detectionMade = true
                explode(thisBullet.position)
                removeBullet(thisBullet)
                
            }
        }
        
        if collision == PhysicsCategory.Bullet | PhysicsCategory.Hero {
            let aBullet = (contact.bodyA.categoryBitMask == PhysicsCategory.Bullet) ?
                contact.bodyA.node :
                contact.bodyB.node
            let thisBullet = aBullet as! Bullet
            if thisBullet.detectionMade == false{
                thisBullet.detectionMade = true
                explode(thisBullet.position)
                removeBullet(thisBullet)
                
            }
            
        }
        
        
        
        
        if collision == PhysicsCategory.Bullet | PhysicsCategory.Target {
            let aBullet = (contact.bodyA.categoryBitMask == PhysicsCategory.Bullet) ?
                contact.bodyA.node :
                contact.bodyB.node
            let thisBullet = aBullet as! Bullet
            if thisBullet.detectionMade == false{
                thisBullet.detectionMade = true
                explode(thisBullet.position)
                // bulletsToRemove.addObject(thisBullet)
               removeBullet(thisBullet)
                
            }
            
            let aTarget = (contact.bodyA.categoryBitMask == PhysicsCategory.Target) ?
                contact.bodyA.node :
                contact.bodyB.node
            let aRobot = aTarget?.parent as! BigBot
            
            aRobot.blowUp()
            
            
        }

        
        if collision == PhysicsCategory.Robot | PhysicsCategory.Wall {
            let aRobot = (contact.bodyA.categoryBitMask == PhysicsCategory.Robot) ?
                contact.bodyA.node :
                contact.bodyB.node
            let thisRobot = aRobot as! BigBot
            thisRobot.reverse()
            
        }

        


    }
    
    
    func didEndContact(contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == PhysicsCategory.Hero | PhysicsCategory.Ground  {
            hero.grounded = false
            
        }
       
 
    }
    
    func explode(pos:CGPoint){
        let explosion:SKEmitterNode = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = pos
        addChild(explosion)
        let endAction = SKAction.sequence([SKAction.waitForDuration(0.5), SKAction.removeFromParent()])
        explosion.runAction(endAction)
  
    }
    
    func removeBullet(bullet:Bullet){
        bullet.removeFromParent()
    }
}

