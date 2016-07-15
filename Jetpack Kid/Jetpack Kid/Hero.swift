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
    var _jetFire:SKSpriteNode!
    var _physBody:SKSpriteNode!
    
    
    var _direction:Int!
    var grounded:Bool!
    var shooting:Bool!
    var shocking:Bool!
    var jetOn: Bool!
    var _landingForce: CGFloat!
    var _currentState:Int!
    var _lastState:Int!
    var _spinFrame:Int!
    var _bendFrame:Int!
    var _liftFrame:Int!
    var _walkFrame:Int!
    var _turnFrame:Int!
    var _currentWalk:Int!
    
    var heroPos:CGPoint!
    var shootLPos:CGPoint!
    var shootRPos:CGPoint!
   
    
    var timer = NSTimer()
    var spinFrames:[SKTexture] = []
    var jetFireSpinFrames:[SKTexture] = []
    var bendRightFrames:[SKTexture] = []
    var bend2RightFrames:[SKTexture] = []
    var bendLeftFrames:[SKTexture] = []
    var bend2LeftFrames:[SKTexture] = []
    var walkLeftAFrames:[SKTexture] = []
    var walkLeftBFrames:[SKTexture] = []
    var walkRightAFrames:[SKTexture] = []
    var walkRightBFrames:[SKTexture] = []
    var turnRightAFrames:[SKTexture] = []
    var turnRightBFrames:[SKTexture] = []
    var turnLeftAFrames:[SKTexture] = []
    var turnLeftBFrames:[SKTexture] = []
    var shockRightFrames:[SKTexture] = []
    var shockLeftFrames:[SKTexture] = []
    

 
    
    func setUp(){

        _hero = childNodeWithName("heroSprite") as! SKSpriteNode
        _jetFire = childNodeWithName("jetFireSprite") as! SKSpriteNode
        _physBody = childNodeWithName("physBody") as! SKSpriteNode
        
        heroPos = _hero.anchorPoint
        
        shootLPos = childNodeWithName("shootLPos")?.position
        shootRPos = childNodeWithName("shootRPos")?.position
        
        
        _direction = 0
        _currentState = state.flying
        
        _spinFrame = 0
        _bendFrame = 0
        _currentWalk = 0
        _walkFrame = 0
        _liftFrame = 26
        _turnFrame = 0
        grounded = false
        shooting = false
        jetOn = false
  
        //physicsBody = SKPhysicsBody(rectangleOfSize: _hero.size)
        physicsBody = SKPhysicsBody(texture: _physBody.texture!, size: _physBody.size)
        physicsBody?.affectedByGravity = true
        physicsBody?.allowsRotation = false
        physicsBody?.mass = 1.0
        
        physicsBody?.friction = 1.0
        physicsBody?.dynamic = true
        physicsBody?.pinned = false
        physicsBody?.restitution = 0.0
        physicsBody?.categoryBitMask = PhysicsCategory.Hero
        physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Wall | PhysicsCategory.Bullet | PhysicsCategory.Robot
    
        
        
        //set up animations
        
        for i in 0...19 {
            spinFrames.append(SKTexture(imageNamed: "Spin\(i)"))
        }
        
        for i in 0...19 {
            jetFireSpinFrames.append(SKTexture(imageNamed: "JetFireSpin\(i)"))
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
        
        for i in 0...16 {
            walkLeftAFrames.append(SKTexture(imageNamed: "WalkLeft\(i)"))
        }

        for i in 16...33 {
            walkLeftBFrames.append(SKTexture(imageNamed: "WalkLeft\(i)"))
        }
        
        for i in 0...16 {
            walkRightAFrames.append(SKTexture(imageNamed: "WalkRight\(i)"))
        }
        
        for i in 16...33 {
            walkRightBFrames.append(SKTexture(imageNamed: "WalkRight\(i)"))
        }
        
        for i in 0...19 {
            turnLeftAFrames.append(SKTexture(imageNamed: "TurnA\(i)"))

        }
        
        for i in 0...19 {
            turnLeftBFrames.append(SKTexture(imageNamed: "TurnB\(i)"))
            
        }
        
        

        turnRightAFrames = turnLeftAFrames.reverse()
        turnRightBFrames = turnLeftBFrames.reverse()

        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.04, target: self, selector: #selector(step), userInfo: nil, repeats: true)
        

    }
    
    func changeState(newState:Int){
        _lastState = _currentState
        _currentState = newState
    }
    
    func shootFlying(){
       
        if _spinFrame == 0 {
            shooting = true

            _hero.runAction(SKAction(named: "shootLeft")!, completion: {self.shooting = false})
        }
        if _spinFrame == 19 {
            shooting = true
            _hero.runAction(SKAction(named: "shootRight")!, completion: {self.shooting = false})
        }
        
 
    }
    
    func step(){
        
        _jetFire.texture = jetFireSpinFrames[_spinFrame]
        
        if _currentState == state.flying {
            
            if jetOn == true {
                let rand:CGFloat = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
                _jetFire.alpha = 0.5 + rand
                
            }

            
            if !shooting{
                if _direction == 1 && _spinFrame < 19 {
                    _spinFrame = _spinFrame + 1
                    _currentWalk = 2
                }
                
                if _direction == 0 && _spinFrame > 0 {
                    _spinFrame = _spinFrame - 1
                    _currentWalk = 0
                }
                
                _hero.texture = spinFrames[_spinFrame]
                
            }
            
        
            

            
        }
        
        if _currentState == state.lifting {
            if _direction == 0 {
                _hero.texture = bendLeftFrames[_liftFrame]//just bend in reverse
            }
            if _direction == 1 {
                _hero.texture = bendRightFrames[_liftFrame]
            }
            if _liftFrame > 19 {
                _liftFrame = _liftFrame - 1
            }
            if _liftFrame <= 19 {
                _liftFrame = 26
                changeState(state.flying)
            }
            
            if jetOn == true {
                let rand:CGFloat = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
                _jetFire.alpha = 0.5 + rand
                
            }

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
        
        if _currentState == state.walking {// changed in GameScene update
            //walk left
            if _direction == 0 {
                if _currentWalk == 0 {
                    if _walkFrame < 16 {
                        _walkFrame = _walkFrame + 1
                        _hero.texture = walkLeftBFrames[_walkFrame]
                        physicsBody?.velocity = CGVector(dx: -75, dy: 0)
                        if _walkFrame == 13 {
                            //play sound here
                        }
                    }else{
                        _currentWalk = 1
                        _spinFrame = 0
                        _walkFrame = 0
                        changeState(state.stopped)
                    }
                    
                }
                
                if _currentWalk == 1 {
                    if _walkFrame < 16 {
                        _walkFrame = _walkFrame + 1
                        _hero.texture = walkLeftAFrames[_walkFrame]
                        physicsBody?.velocity = CGVector(dx: -90, dy: 0)
                        if _walkFrame == 13 {
                            //play sound here
                        }
                    }else{
                        _currentWalk = 0
                        _walkFrame = 0
                        _spinFrame = 0
                        changeState(state.stopped)
                    }
                }
                if _currentWalk == 2 {
                    if _turnFrame < 19 {
                        _turnFrame = _turnFrame + 1
                        if _turnFrame == 2{
                            //play sound here
                        }
                        _hero.texture = turnLeftAFrames[_turnFrame]
                        
                        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    }else{
                        _currentWalk = 0
                        _turnFrame = 0
                        _spinFrame = 0
                        changeState(state.stopped)
                    }
                }
                if _currentWalk == 3 {
                    if _turnFrame < 19 {
                        _turnFrame = _turnFrame + 1
                        if _turnFrame == 2{
                            //play sound here
                        }
                        _hero.texture = turnLeftBFrames[_turnFrame]
                        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    }else{
                        _currentWalk = 1
                        _turnFrame = 0
                        _spinFrame = 0
                        changeState(state.stopped)
                    }
                }
                
            }
            
            //walk right
            if _direction == 1 {
                if _currentWalk == 2{
                    if _walkFrame < 16 {
                        _walkFrame = _walkFrame + 1
                        _hero.texture = walkRightBFrames[_walkFrame]
                        physicsBody?.velocity = CGVector(dx: 75, dy: 0)
                        if _walkFrame == 13 {
                            //play sound here
                        }
                    }else{
                        _currentWalk = 3
                        _walkFrame = 0
                        _spinFrame = 19
                        changeState(state.stopped)
                    }
                    
                }
                
                if _currentWalk == 3{
                    if _walkFrame < 16 {
                        _walkFrame = _walkFrame + 1
                        _hero.texture = walkRightAFrames[_walkFrame]
                        physicsBody?.velocity = CGVector(dx: 90, dy: 0)
                        if _walkFrame == 13 {
                            //play sound here
                        }
                    }else{
                        _currentWalk = 2
                        _walkFrame = 0
                        _spinFrame = 19
                        changeState(state.stopped)
                    }
                }
                if _currentWalk == 0 {
                    if _turnFrame < 19 {
                        _turnFrame = _turnFrame + 1
                        if _turnFrame == 2{
                            //play sound here
                        }
                        _hero.texture = turnRightAFrames[_turnFrame]
                        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    }else{
                        _currentWalk = 2
                        _turnFrame = 0
                        _spinFrame = 19
                        changeState(state.stopped)
                    }
                }
                if _currentWalk == 1 {
                    if _turnFrame < 19 {
                        _turnFrame = _turnFrame + 1
                        if _turnFrame == 2{
                            //play sound here
                        }
                        _hero.texture = turnRightBFrames[_turnFrame]
                        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    }else{
                        _currentWalk = 3
                        _turnFrame = 0
                        _spinFrame = 19
                        changeState(state.stopped)
                    }
                }

            }
        }
    }
    
    

    
    














}
