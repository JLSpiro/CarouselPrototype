//
//  BallNode.swift
//  MarbleKey
//
//  Created by Jesse Spiro on 5/4/16.
//  Copyright © 2016 Jesse Spiro. All rights reserved.
//

import Foundation
import SpriteKit


class BallNode: SKSpriteNode {
    var ballSprite: SKSpriteNode!
    
    
    func setUp() {
        ballSprite = childNodeWithName("ball") as! SKSpriteNode
    }
    
 
}
