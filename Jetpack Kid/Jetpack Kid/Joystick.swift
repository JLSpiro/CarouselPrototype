//
//  Joystick.swift
//  Jetpack Kid
//
//  Created by Jesse Spiro on 5/10/16.
//  Copyright © 2016 Jesse Spiro. All rights reserved.
//

import Foundation
import SpriteKit

class Joystick: SKSpriteNode {
    
    var joyButton: SKSpriteNode!
    var joyPad: SKSpriteNode!
    var touchPos: CGPoint!
    var jetDelta: CGVector!
    var _joybtnDistSquared: CGFloat!
    var _joybtnAngle: CGFloat!
    var _joypadRadius: CGFloat!
    var _joypadRadiusSquared: CGFloat!
    var _isMovingJoybtn: Bool!
    var jetVector: CGVector! = CGVector(dx: 0, dy: 0)
    

    
    func setUp(){
        joyButton = childNodeWithName("joyButton") as! SKSpriteNode
        joyPad = childNodeWithName("joyPad") as! SKSpriteNode
        _isMovingJoybtn = false
        _joypadRadius = joyPad.size.width * 0.4;
        _joypadRadiusSquared = pow(_joypadRadius,2);
        userInteractionEnabled = true
        

    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            if !_isMovingJoybtn && isTouchingJoybtn(touch) == true {
                touchPos = joyPad.position // initially move the joystick button to touch point
                moveJoybtn(touch)
                _isMovingJoybtn = true
            }
           
        }

    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            if _isMovingJoybtn == true{
                moveJoybtn(touch)
            }

        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        stop()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        stop()
    }
    
    func distanceFromJoypadSquared(p: CGPoint) -> CGFloat {
        // remember a squared + b squared = c squared?
        let p2 = joyPad.position
        return pow(p2.x - p.x, 2) + pow(p2.y - p.y, 2)
        
    }
    
    
    func isTouchingJoybtn(touch: UITouch) -> Bool{
        let c2: CGFloat = distanceFromJoypadSquared(touch.locationInNode(self))
        return (c2 < pow(_joypadRadius,2))
        
    }
    
    func moveJoybtn(touch: UITouch){
        // get previous touch point and determine offset ???
        let prev: CGPoint = (_isMovingJoybtn != nil) ? touch.previousLocationInView(touch.view) : joyButton.position
        let offset: CGPoint = CGPoint(x: touch.locationInView(touch.view).x - prev.x, y: touch.locationInView(touch.view).y - prev.y)
        
        if offset.x != 0 || offset.y != 0 {
            // get new purported joybtn position and delta to joypad center ?????
            touchPos = CGPoint(x: touchPos.x + offset.x, y: touchPos.y - offset.y)
            let delta:CGVector = CGVector(dx: touchPos.x - joyPad.position.x, dy: touchPos.y - joyPad.position.y)
            var newPos: CGPoint = touchPos
            
            
            
            // get its angle and distance
            _joybtnAngle = delta.angle
            _joybtnDistSquared = distanceFromJoypadSquared(newPos)
         
            // clamp it inside joypad
            
            if _joybtnDistSquared > _joypadRadiusSquared {
                
                let v: CGVector = CGVector.init(angle: _joybtnAngle)
                let v2: CGVector = CGVector(dx: v.dy * _joypadRadius, dy: v.dx * _joypadRadius)
                newPos = CGPoint(x: (v2.dy + joyPad.position.x), y: (v2.dx + joyPad.position.y))
                
               
                _joybtnDistSquared = _joypadRadiusSquared
                
            }
            
            // set it to the new position
            joyButton.position = newPos
            if delta.dy > 0{  // if joystick up
                jetVector = CGVector(dx: newPos.x * 2.5, dy: newPos.y * 3)
            }
            
        }
 
        
     }
    
    func stop(){
        _isMovingJoybtn = false
        jetVector = CGVector(dx: 0, dy: 0)
        joyButton.runAction(SKAction.moveTo(joyPad.position, duration: 0.1))
    }
    
 

}

