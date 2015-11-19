//
//  GameViewController.swift
//  squirrelsOnATrampV1-1
//
//  Created by Markus Notti on 5/25/15.
//  Copyright (c) 2015 Markus Notti. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds


class GameViewController: UIViewController {

    @IBOutlet weak var bottomBannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

            self.bottomBannerView.adUnitID = "ca-app-pub-7629957216188544/8769132116"
            self.bottomBannerView.rootViewController = self
            let request: GADRequest = GADRequest()
            //request.testDevices = @[ @"7aaf52e9468a6036d42aa04237e1479c" ]
            self.bottomBannerView.loadRequest(request)
        
        
            let scene = MenuScene(size: view.bounds.size)
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
