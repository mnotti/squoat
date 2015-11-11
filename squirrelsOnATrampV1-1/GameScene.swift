//
//  GameScene.swift
//  squirrelsOnATrampV1-1
//
//  Created by Markus Notti on 5/25/15.
//  Copyright (c) 2015 Markus Notti. All rights reserved.
//

import SpriteKit
import CoreMotion
import UIKit




class GameScene: SKScene {
    
    let playButton = SKSpriteNode(imageNamed: "play_button1.png")
    
    override func didMoveToView(view: SKView){
        create_content()
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)
            if(self.nodeAtPoint(location) == self.playButton){
                let scene = PlayScene(size: self.size)
                scene.scaleMode = .AspectFill
                view!.presentScene(scene)
            }
        }
    }
    
    func create_content(){
        let bgImage = SKSpriteNode(imageNamed: "squirrelsOnATrampBackgroundV2.jpg")
        
        bgImage.position = (CGPointMake(size.width/2, size.height/2))
        bgImage.size = size
        bgImage.zPosition = 0
        self.addChild(bgImage)
        
        playButton.position = CGPointMake(size.width/2, size.height/3)
        playButton.xScale = 0.5
        playButton.yScale = 0.5
        playButton.zPosition = 1
        self.addChild(playButton)
        
        
        let highScoreLabelLabel = SKLabelNode(fontNamed: "Chalkduster")
        highScoreLabelLabel.text = "Your Best..."
        highScoreLabelLabel.fontSize = 30;
        highScoreLabelLabel.position = CGPointMake(size.width/2, size.height/1.333)
        highScoreLabelLabel.name = "highScoreLabelLabel"
        highScoreLabelLabel.zPosition = 1
        self.addChild(highScoreLabelLabel)
        
        let highScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        highScoreLabel.text = String(NSUserDefaults.standardUserDefaults().integerForKey("squirrelTrampHighScore1"))
        
        highScoreLabel.fontSize = 30;
        highScoreLabel.position = CGPointMake(size.width/2, size.height/2)
        highScoreLabel.name = "highScoreLabel"
        highScoreLabel.zPosition = 1
        self.addChild(highScoreLabel)

        
    }
}

