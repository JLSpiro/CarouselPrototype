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
    var _landingForce: CGFloat!
    var _currentState:Int!
    var _lastState:Int!
    var _spinFrame:Int!
    var _bendFrame:Int!
   
    
    var timer = NSTimer()
    var spinFrames:[SKTexture] = []
    var bendRightFrames:[SKTexture] = []
    var bend2RightFrames:[SKTexture] = []
    var bendLeftFrames:[SKTexture] = []
    var bend2LeftFrames:[SKTexture] = []


 
    
    func setUp(){

        _hero = childNodeWithName("heroSprite") as! SKSpriteNode
        
        _direction = 0
        _currentState = state.flying
        _spinFrame = 0
        _bendFrame = 0
  
        physicsBody = SKPhysicsBody(rectangleOfSize: _hero.size)
        physicsBody?.affectedByGravity = true
        physicsBody?.allowsRotation = false
        physicsBody?.mass = 0.5
        
        physicsBody?.friction = 1.0
        physicsBody?.dynamic = true
        physicsBody?.pinned = false
        physicsBody?.restitution = 0.0
        physicsBody?.categoryBitMask = PhysicsCategory.Hero
        physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Wall
        physicsBody?.contactTestBitMask = PhysicsCategory.Target
        
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.04, target: self, selector: #selector(step), userInfo: nil, repeats: true)
        
        //set up animations
        
        for i in 0...19 {
            spinFrames.append(SKTexture(imageNamed: "Spin\(i)"))
        }
        
        for i in 0...19 {
            bendRightFrames.append(SKTexture(imageNamed: "BendRight\(i)"))
        }
        
        for i in 8...16 {
            bendRightFrames.append(SKTexture(imageNamed: "WalkRight\(i)"))
        }
        
        for i in 0...19 {
            bend2RightFrames.append(SKTexture(imageNamed: "Bend2Right\(i)"))
        }
        
        for i in 8...16 {
            bend2RightFrames.append(SKTexture(imageNamed: "WalkRight\(i)"))
        }
        
        for i in 0...19 {
            bendLeftFrames.append(SKTexture(imageNamed: "BendLeft\(i)"))
        }
        
        for i in 8...16 {
            bendLeftFrames.append(SKTexture(imageNamed: "WalkLeft\(i)"))
        }
        
        for i in 0...19 {
            bend2LeftFrames.append(SKTexture(imageNamed: "Bend2Left\(i)"))
        }
        
        for i in 8...16 {
            bend2LeftFrames.append(SKTexture(imageNamed: "WalkLeft\(i)"))
        }



     
 
    }
    
    func changeState(newState:Int){
        _lastState = _currentState
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
        
        if _currentState == state.landing {
            if _landingForce < 50.0 && _bendFrame < 19 {
                _bendFrame = 19 // skip bend and start walk
            }
            
            if  _bendFrame < 26 {
                _bendFrame = _bendFrame + 1
            }
            
            if _direction == 0 {
                if _landingForce < 300.0 {
                    _hero.texture = bend2LeftFrames[_bendFrame]
                }
                if _landingForce >= 300.0 {
                    _hero.texture = bendLeftFrames[_bendFrame]
                }
            }
            
            if _direction == 1 {
                if _landingForce < 300.0 {
                    _hero.texture = bend2RightFrames[_bendFrame]
                }
                if _landingForce >= 300.0 {
                    _hero.texture = bendRightFrames[_bendFrame]
                }
            }
            if _bendFrame == 26 {
                changeState(state.stopped)
                _bendFrame = 0
            }
        }
    }
    
    

    
    














}
