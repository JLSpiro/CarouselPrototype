//
//  GlowRing.swift
//  JetPackKid
//
//  Created by Jesse Spiro on 5/26/16.
//  Copyright © 2016 Jesse Spiro. All rights reserved.
//

import Foundation
import SpriteKit





class GlowRing: SKSpriteNode{
    
    var _ring: SKSpriteNode!
    var timer = NSTimer()
    var grow:CGFloat!
    
    func setUp(){
        
        
        _ring = SKSpriteNode(imageNamed: "glowRing")
        addChild(_ring)
        
        _ring.setScale(0.7)
        _ring.blendMode = SKBlendMode.Screen
        _ring.alpha = 0.7
        grow = 0.7
        
       timer = NSTimer.scheduledTimerWithTimeInterval(0.04, target: self, selector: #selector(fadeOut), userInfo: nil, repeats: true)
    }
    
    
    func fadeOut(){
        grow  = grow * 1.02
        _ring.setScale(grow)
        _ring.alpha = _ring.alpha - 0.08
        if _ring.alpha <= 0 {
            self.removeFromParent()
        }
    }
 }
