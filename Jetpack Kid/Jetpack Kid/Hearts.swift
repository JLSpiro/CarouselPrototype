//
//  Hearts.swift
//  JetPackKid
//
//  Created by Jesse Spiro on 6/7/16.
//  Copyright © 2016 Jesse Spiro. All rights reserved.
//

import Foundation
import SpriteKit


class Hearts: SKSpriteNode {
 
    let keeper = SharedKeeper.sharedInstance
    var _heart1: SKSpriteNode!
    var _heart2: SKSpriteNode!
    var _heart3: SKSpriteNode!
    var _heart4: SKSpriteNode!
    var heartsArray: NSArray!
    
    func setUp(){
        userInteractionEnabled = false
        _heart1 = childNodeWithName("//heart1") as! SKSpriteNode
        _heart2 = childNodeWithName("//heart2") as! SKSpriteNode
        _heart3 = childNodeWithName("//heart3") as! SKSpriteNode
        _heart4 = childNodeWithName("//heart4") as! SKSpriteNode
        
        heartsArray = [_heart1,_heart2,_heart3,_heart4]
        
    }

    func setLives(){
        
       for i in 0...3 {
            let aHeart = heartsArray[i] as! SKSpriteNode
            if keeper.hitPoints < i + 1 {
                aHeart.texture = SKTexture(imageNamed: "GlassHeartEmpty")
                
            }else{
                aHeart.texture = SKTexture(imageNamed: "GlassHeartFull")
            }
        }
    
    }
    
    
    
    
}