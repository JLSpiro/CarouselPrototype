//
//  SharedKeeper.swift
//  MarbleKey
//
//  Created by Jesse Spiro on 5/6/16.
//  Copyright © 2016 Jesse Spiro. All rights reserved.
//

import Foundation


import Foundation


private let _sharedInstance = SharedKeeper()

class SharedKeeper {
    
    var roomNumber: Int = 1
    
    
    private init() {
    }
    
    class var sharedInstance: SharedKeeper {
        return _sharedInstance
    }
}
