//
//  SingletonKeeper.swift
//  JetPackKid
//
//  Created by Jesse Spiro on 6/3/16.
//  Copyright © 2016 Jesse Spiro. All rights reserved.
//

import Foundation
import SpriteKit

private let _sharedInstance = SharedKeeper()

class SharedKeeper {
    
    var fuelLevel:CGFloat!
    var hitPoints: Int!
    
    
    private init() {
    }
    
    class var sharedInstance: SharedKeeper {
        return _sharedInstance
    }
}