//
//  GameViewController.swift
//  DrawingGame
//
//  Created by Jesse Spiro on 2/13/16.
//  Copyright (c) 2016 Jesse Spiro. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController {
    
    // guess what this is for ;)
    var bkgMusicPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // load up the background music file and start playing
        let pathToBkgMusic = NSBundle.mainBundle().pathForResource("Crystal", ofType:"mp3")
        if let pathToBkgMusic = pathToBkgMusic {
            let bkgMusicURL = NSURL(fileURLWithPath: pathToBkgMusic)
            do {
                try bkgMusicPlayer = AVAudioPlayer(contentsOfURL: bkgMusicURL)
                bkgMusicPlayer.play()
                bkgMusicPlayer.volume = 1
            } catch {
                print("Error loading bkg music")
            }
            
            
        }

        if let scene = GameScene(fileNamed: "GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
