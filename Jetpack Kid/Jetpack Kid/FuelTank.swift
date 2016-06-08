//
//  FuelTank.swift
//  JetPackKid
//
//  Created by Jesse Spiro on 6/3/16.
//  Copyright © 2016 Jesse Spiro. All rights reserved.
//

import Foundation
import SpriteKit



class FuelTank:SKSpriteNode{
    
    var fuelTank:SKSpriteNode!
    var refuelZone:SKSpriteNode!
    var turnOnFrames:[SKTexture] = []
    var turnOffFrames:[SKTexture] = []
    var refueling:Bool!
    let keeper = SharedKeeper.sharedInstance
    var timer = NSTimer()
    
    
    func setUp(){
        refueling = false
        fuelTank = childNodeWithName("fuelTank") as! SKSpriteNode
        refuelZone = childNodeWithName("refuelZone") as! SKSpriteNode
        
        for i in 0...3 {
            turnOnFrames.append(SKTexture(imageNamed: "fuelTank\(i)"))
        }

        turnOffFrames = turnOnFrames.reverse()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.04, target: self, selector: #selector(refuel), userInfo: nil, repeats: true)

        physicsBody = SKPhysicsBody(edgeLoopFromRect: refuelZone.frame)
        physicsBody?.allowsRotation = false
        physicsBody?.pinned = true
        physicsBody?.dynamic = false
        physicsBody?.contactTestBitMask = PhysicsCategory.Hero
        physicsBody?.collisionBitMask = PhysicsCategory.None
        physicsBody?.categoryBitMask = PhysicsCategory.FuelTank

    }
    
    func turnOn(){
        if refueling == false {
            refueling = true
            let turnOnAction = SKAction.animateWithTextures(turnOnFrames, timePerFrame: 0.05)
            let turnOffAction = SKAction.animateWithTextures(turnOffFrames, timePerFrame: 0.05)
            fuelTank.runAction(SKAction.sequence([turnOnAction,SKAction.waitForDuration(0.5),turnOffAction]))
        }
 
    }
    

    
    func refuel() {
        if keeper.fuelLevel < 100 && refueling == true {
            keeper.fuelLevel = keeper.fuelLevel + 1

        }
        if keeper.fuelLevel >= 100 {
            refueling = false
        }
        
    }
    
    
}