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
    var jetDelta: CGFloat!
    var _joybtnDistSquared: CGFloat!
    var _joybtnAngle: CGFloat!
    var _joypadRadius: CGFloat!
    var _joypadRadiusSquared: CGFloat!
    var _isMovingJoybtn: Bool!
    var jetVector: CGPoint!

    
    func setUp(){
        joyButton = childNodeWithName("joyButton") as! SKSpriteNode
        joyPad = childNodeWithName("joyPad") as! SKSpriteNode
        
        _joypadRadius = joyPad.size.width * 0.4;
        _joypadRadiusSquared = pow(_joypadRadius,2);

    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            if !_isMovingJoybtn && isTouchingJoybtn(touch) == true {
                touchPos = joyPad.position // initially move the joystick button to touch point
                
            }
           
        }

    }
    
    func distanceFromJoypadSquared(p: CGPoint) -> CGFloat {
        
        let p2 = joyPad.position
        return sqrt(pow(p2.x-p.x,2)+pow(p2.y-p.y,2))
    }
    
    
    func isTouchingJoybtn(touch: UITouch) -> Bool{
        let c2: CGFloat = distanceFromJoypadSquared(touch.locationInNode(self))
        return (c2 < pow(_joypadRadius,2))
    }
    
    func moveJoybtn(touch: UITouch){
        // get previous touch point and determine offset ???
        let prev: CGPoint = (_isMovingJoybtn != nil) ? touch.previousLocationInView(touch.view) : joyButton.position
        let offset: CGPoint = CGPoint(x: touch.locationInNode(self).x - prev.x, y: touch.locationInNode(self).y - prev.y)
        
        
        // get new purported joybtn position and delta to joypad center ?????
        touchPos = CGPoint(x: touchPos.x + offset.x, y: touchPos.y + offset.y)
        let delta:CGPoint = CGPoint(x: touchPos.x - joyPad.position.x, y: touchPos.y - joyPad.position.y)
        let newPos: CGPoint = touchPos
        jetVector = delta
        
         // get its angle and distance
        _joybtnAngle = atan2(delta.x, delta.y)
        _joybtnDistSquared = distanceFromJoypadSquared(newPos)
        
        // clamp it inside joypad
        
        if _joybtnDistSquared > _joypadRadiusSquared {
           
        }

        
       
        
        
        
     }
    
    -(void)moveJoybtn:(CCTouch*)touch
    {
    // get previous touch point and determine offset
    CGPoint prev = (_isMovingJoybtn ? [[CCDirector sharedDirector] convertToGL:[touch previousLocationInView:[touch view]]]: _joyButton.position);
    CGPoint offset = ccpSub(touch.locationInWorld, prev);
    
    
    if( offset.x || offset.y )
    {
    // get new purported joybtn position and delta to joypad center
    touchPos = ccpAdd(touchPos, offset);
    CGPoint delta = ccpSub(touchPos, _joyPad.position);
    CGPoint newPos = touchPos;
    jetDelta = delta;
    
    // get its angle and distance
    _joybtnAngle = ccpToAngle(delta);
    _joybtnDistSquared = [self distanceFromJoypadSquared:newPos];
    
    // clamp it inside the joypad
    if( _joybtnDistSquared > _joypadRadiusSquared )
    {
        newPos = ccpAdd(_joyPad.position,
        ccpMult(ccpForAngle(_joybtnAngle), _joypadRadius));
        _joybtnDistSquared = _joypadRadiusSquared;
    
    }
    if (newPos.y > _joyPad.position.y) {
    keeper.burnRate = _joybtnDistSquared/_joypadRadiusSquared;
    
    }
    
    // set it to the new position
    [_joyButton setPosition:newPos];
    
    }
    }

    

}

