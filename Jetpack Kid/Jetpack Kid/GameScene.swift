//
//  GameScene.swift
//  Jetpack Kid
//
//  Created by Jesse Spiro on 5/10/16.
//  Copyright (c) 2016 Jesse Spiro. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var joyStick: Joystick!
    var hero:SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        joyStick = childNodeWithName("//joyNode") as! Joystick
        joyStick.setUp()
        
        hero = childNodeWithName("hero") as! SKSpriteNode
       // hero = SKSpriteNode(imageNamed: "Bend2Left0")
    
        physicsWorld.contactDelegate = self
        view.showsPhysics = true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
     }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        hero.physicsBody?.applyForce(joyStick.jetVector)
        print("\(joyStick.jetVector)")
    }
}

