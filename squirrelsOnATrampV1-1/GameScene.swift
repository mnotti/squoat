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
    
    var bgImage = SKSpriteNode(imageNamed: "squirrelsOnATrampBackgroundV2.jpg")
    let playButton = SKSpriteNode(imageNamed: "play_button1.png")
    var highScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    var contentCreated = false
    
    override func didMoveToView(view: SKView)
    {
        if (!contentCreated){
            create_content()
            contentCreated = true
        }
        else
        {
            self.highScoreLabel.text = String(NSUserDefaults.standardUserDefaults().integerForKey("squirrelTrampHighScore1"))

        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)
            if(self.nodeAtPoint(location) == self.playButton){
                destroy_content()
                let scene = PlayScene(size: self.size)
                scene.scaleMode = .AspectFill
                view!.presentScene(scene)
            }
        }
    }
    
    func create_content(){
        
        bgImage.position = (CGPointMake(size.width/2, size.height/2))
        bgImage.size = size
        self.addChild(bgImage)
        
        playButton.position = CGPointMake(size.width/2, size.height/3)
        playButton.xScale = 0.5
        playButton.yScale = 0.5
        self.addChild(playButton)
        
        var highScoreLabelLabel = SKLabelNode(fontNamed: "Chalkduster")
        highScoreLabelLabel.text = "Your Best..."
        highScoreLabelLabel.fontSize = 30;
        highScoreLabelLabel.position = CGPointMake(size.width/2, size.height/1.333)
        highScoreLabelLabel.name = "highScoreLabelLabel"
        self.addChild(highScoreLabelLabel)
        
        self.highScoreLabel.text = String(NSUserDefaults.standardUserDefaults().integerForKey("squirrelTrampHighScore1"))
        self.highScoreLabel.fontSize = 30;
        self.highScoreLabel.position = CGPointMake(size.width/2, size.height/2)
        self.highScoreLabel.name = "highScoreLabel"
        self.addChild(highScoreLabel)

        
    }
    
    func destroy_content(){
        for child in self.children
        {
            removeChildrenInArray([child])
        }
        print("removed the children")
        contentCreated = false
        
    }
}

