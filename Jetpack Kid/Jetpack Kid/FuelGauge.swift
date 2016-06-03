//
//  FuelGauge.swift
//  JetPackKid
//
//  Created by Jesse Spiro on 6/2/16.
//  Copyright © 2016 Jesse Spiro. All rights reserved.
//

import Foundation
import SpriteKit


class FuelGauge: SKSpriteNode {
    
    let keeper = SharedKeeper.sharedInstance
    var _level: SKSpriteNode!
    
    func setUp(){
        userInteractionEnabled = false
        _level = childNodeWithName("//fuelLevel") as! SKSpriteNode
        _level.runAction(SKAction.colorizeWithColor(UIColor.greenColor(), colorBlendFactor: 1.0, duration: 0.1))
        keeper.fuelLevel = 100.0
        _level.blendMode = SKBlendMode.Screen
        
    }
    
    func setLevel(){
        _level.yScale = keeper.fuelLevel * 0.01
        colorLevel()
 
    }
    func burn(rate:CGFloat){
       // print("\(_level.yScale)")
        if keeper.fuelLevel > 0 {
            keeper.fuelLevel = keeper.fuelLevel - rate *  0.0005
            _level.yScale = keeper.fuelLevel * 0.01
        }
        
        colorLevel()
        
    }
    
    func colorLevel(){
        if keeper.fuelLevel >= 60.0 {
            _level.color = UIColor.greenColor()
            
        }
        if keeper.fuelLevel < 60.0 && keeper.fuelLevel >= 20 {
            _level.color = UIColor.yellowColor()
        }
        if keeper.fuelLevel < 20.0 {
            _level.color = UIColor.redColor()
        }

    }
    

}