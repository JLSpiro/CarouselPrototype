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
  //  static let Trigger: UInt32 = 0b10000 // 16
  //  static let Door:UInt32 = 0b100000 // 32
  //  static let Exit:  UInt32 = 0b1000000 // 64
  //  static let KeyHole: UInt32 = 0b10000000 //128
    
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var joyStick: Joystick!
    var hero:Hero!
    var prevDirection: Int!
    
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        joyStick = childNodeWithName("//joyNode") as! Joystick
        joyStick.setUp()
        
        hero = childNodeWithName("//heroNode") as! Hero
        hero.setUp()
        
        view.showsPhysics = true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
     }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if joyStick.jetVector.dy > 30.0 {
         //   hero.physicsBody?.applyForce(joyStick.jetVector)
        
        }
        
        hero.physicsBody?.applyForce(joyStick.jetVector * 10)
        
        prevDirection = hero._direction
        if joyStick.jetVector.dx < 0 {
            hero._direction = 0
        }else if joyStick.jetVector.dx > 0{
            hero._direction = 1
        }else if joyStick.jetVector.dx == 0 {
            hero._direction = prevDirection
        }
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {

        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == PhysicsCategory.Hero | PhysicsCategory.Target  {
           
        }
        
        if collision == PhysicsCategory.Hero | PhysicsCategory.Wall  {
            let hitWall = contact.collisionImpulse
            print("hit wall \(hitWall)")

        }

        
        if collision == PhysicsCategory.Hero | PhysicsCategory.Ground  {
             hero.changeState(state.landing)
            let hit = contact.collisionImpulse
            hero._landingForce = hit
            print("hit ground\(hit)")
        }
    }
    
 
    
    func didEndContact(contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == PhysicsCategory.Hero | PhysicsCategory.Ground  {
            hero.changeState(state.flying)
            
        }

    }
    
    
    

}

