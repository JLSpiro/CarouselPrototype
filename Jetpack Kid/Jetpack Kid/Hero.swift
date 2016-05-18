//
//  Hero.swift
//  JetPackKid
//
//  Created by Jesse Spiro on 5/17/16.
//  Copyright © 2016 Jesse Spiro. All rights reserved.
//

import Foundation
import SpriteKit

struct state {
    static let stopped = 0
    static let lifting = 1
    static let flying = 2
    static let landing = 3
    static let walking = 4
    static let shocking = 5
    static let dead = 6
    static let collapse = 7
}


class Hero: SKSpriteNode {
    var _hero:SKSpriteNode!
    var _jet:SKSpriteNode!
    
    var _direction:Int!
    var _currentState:Int!
    var _spinFrame:Int!
    
    
    var timer = NSTimer()
    var spinFrames:[SKTexture] = []


 
    
    func setUp(){

        _hero = childNodeWithName("heroSprite") as! SKSpriteNode
        
        _direction = 0
        _currentState = state.flying
        _spinFrame = 0
  
        physicsBody = SKPhysicsBody(rectangleOfSize: _hero.size)
        physicsBody?.affectedByGravity = true
        physicsBody?.allowsRotation = false
        physicsBody?.mass = 0.08
        physicsBody?.friction = 1.0
        physicsBody?.dynamic = true
        physicsBody?.pinned = false
        physicsBody?.restitution = 0.0
        physicsBody?.categoryBitMask = PhysicsCategory.Hero
        physicsBody?.collisionBitMask = PhysicsCategory.Ground
        physicsBody?.contactTestBitMask = PhysicsCategory.Target
        
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.04, target: self, selector: #selector(step), userInfo: nil, repeats: true)
        
        //set up animations
        
        
        for i in 0...19 {
            spinFrames.append(SKTexture(imageNamed: "Spin\(i)"))
        }

     
 
    }
    
    func changeState(newState:Int){
        _currentState = newState
    }
    

    
    func step(){
        if _currentState == state.flying {
            if _direction == 0 && _spinFrame > 0 {
                _spinFrame = _spinFrame - 1
            }
            if _direction == 1 && _spinFrame < 19 {
                _spinFrame = _spinFrame + 1
            }
            _hero.texture = spinFrames[_spinFrame]
            
        }
    }
    
    

    
    














}
