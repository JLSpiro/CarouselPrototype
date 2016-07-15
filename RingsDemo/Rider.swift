//
//  Rider.swift
//  RingsDemo
//
//  Created by Jesse Spiro on 7/12/16.
//  Copyright © 2016 Jesse Spiro. All rights reserved.
//

import Foundation
import SpriteKit

class Rider: SKSpriteNode {
    
    var head: SKSpriteNode!
    var torso: SKSpriteNode!
    var upperarm: SKSpriteNode!
    var lowerarm: SKSpriteNode!
    var upperleg: SKSpriteNode!
    var lowerleg: SKSpriteNode!
    var horse: SKSpriteNode!
    var jumping: Bool!
    
    
    func setUp(){
        jumping = false
        head = childNodeWithName("//head") as! SKSpriteNode
        torso = childNodeWithName("//torso") as! SKSpriteNode
        upperarm = childNodeWithName("//upperarm") as! SKSpriteNode
        lowerarm = childNodeWithName("//lowerarm") as! SKSpriteNode
        upperleg = childNodeWithName("//upperleg") as! SKSpriteNode
        lowerleg = childNodeWithName("//lowerleg") as! SKSpriteNode
        horse = childNodeWithName("//horse") as! SKSpriteNode
        
    }
    
    func jump(){
        if jumping == false {
            
            jumping = true
            horse.runAction(SKAction.sequence([SKAction.waitForDuration(0.1), SKAction(named:"horseJump")!]))
            
            head.runAction(SKAction.sequence([SKAction.waitForDuration(0.0), SKAction(named:"headRotate")!]))
            
            torso.runAction(SKAction.sequence([SKAction.waitForDuration(0.3), SKAction(named:"torsoJump")!]))
            torso.runAction(SKAction.sequence([SKAction.waitForDuration(0.3), SKAction(named:"torsoRotate")!]))
            
            upperarm.runAction(SKAction.sequence([SKAction.waitForDuration(0.0), SKAction(named:"upperArmRotate")!]))
            upperarm.runAction(SKAction.sequence([SKAction.waitForDuration(0.2), SKAction(named:"upperArmMove")!]))
            
            upperleg.runAction(SKAction.sequence([SKAction.waitForDuration(0.0), SKAction(named:"upperLegRotate")!]))
            upperleg.runAction(SKAction.sequence([SKAction.waitForDuration(0.0), SKAction(named:"upperLegMove")!]))
            
            lowerarm.runAction(SKAction.sequence([SKAction.waitForDuration(0.0), SKAction(named:"lowerArmRotate")!]))
            
            lowerleg.runAction(SKAction.sequence([SKAction.waitForDuration(0.0), SKAction(named:"lowerLegRotate")!]))
            
            runAction(SKAction.sequence([SKAction.waitForDuration(2.25), SKAction.runBlock(resetJump)]))
        }
 
        
     }
    

    func resetJump(){
        jumping = false
    }

}
