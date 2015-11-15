//
//  MenuScene.swift
//  squirrelsOnATrampV1-1
//
//  Created by Markus Notti on 5/25/15.
//  Copyright (c) 2015 Markus Notti. All rights reserved.
//

import SpriteKit
import CoreMotion
import UIKit




class MenuScene: SKScene {
    
    let upArrow = SKSpriteNode(imageNamed: "arrowUp")
    let downArrow = SKSpriteNode(imageNamed: "arrowDown")
    let rightArrow = SKSpriteNode(imageNamed: "arrowRight")
    let leftArrow = SKSpriteNode(imageNamed: "arrowLeft")
    
    override func didMoveToView(view: SKView){
        create_content()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let scene = PlayScene(size: self.size)
        scene.scaleMode = .AspectFill
        view!.presentScene(scene)
    }
    
    func create_content(){
        let bgImage = SKSpriteNode(imageNamed: "background")
        
        bgImage.position = (CGPointMake(size.width/2, size.height/2))
        bgImage.size = size
        bgImage.zPosition = 0
        self.addChild(bgImage)
        
        let highScoreLabelLabel = SKLabelNode(fontNamed: "Chalkduster")
        highScoreLabelLabel.text = "Your Best..."
        highScoreLabelLabel.fontSize = 25;
        highScoreLabelLabel.position = CGPointMake(size.width/2, size.height/1.2)
        highScoreLabelLabel.name = "highScoreLabelLabel"
        highScoreLabelLabel.zPosition = 1
        self.addChild(highScoreLabelLabel)
        
        let highScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        highScoreLabel.text = String(NSUserDefaults.standardUserDefaults().integerForKey("squirrelTrampHighScore1"))
        
        highScoreLabel.fontSize = 25;
        highScoreLabel.position = CGPointMake(size.width/2, size.height/1.2 - 30)
        highScoreLabel.name = "highScoreLabel"
        highScoreLabel.zPosition = 1
        self.addChild(highScoreLabel)
 
        leftArrow.position = CGPointMake(size.width/2 - 90, size.height/1.333 - 45)
        leftArrow.xScale = 0.25
        leftArrow.yScale = 0.25
        leftArrow.zPosition = 1
        self.addChild(leftArrow)
        
        let tilt = SKLabelNode(fontNamed: "Chalkduster")
        tilt.text = "Tilt left and right"
        tilt.fontSize = 15;
        tilt.position = CGPointMake(size.width/2, size.height/1.333 - 50)
        tilt.name = "tilt"
        tilt.zPosition = 1
        self.addChild(tilt)
        
        rightArrow.position = CGPointMake(size.width/2 + 90, size.height/1.333 - 45)
        rightArrow.xScale = 0.25
        rightArrow.yScale = 0.25
        rightArrow.zPosition = 1
        self.addChild(rightArrow)
    
        upArrow.position = CGPointMake(size.width/2, size.height/1.333 - 70)
        upArrow.xScale = 0.25
        upArrow.yScale = 0.25
        upArrow.zPosition = 1
        self.addChild(upArrow)
        
        let swipe = SKLabelNode(fontNamed: "Chalkduster")
        swipe.text = "Swipe up and down"
        swipe.fontSize = 15;
        swipe.position = CGPointMake(size.width/2, size.height/1.333 - 90)
        swipe.name = "tilt"
        swipe.zPosition = 1
        self.addChild(swipe)
        
        downArrow.position = CGPointMake(size.width/2, size.height/1.333 - 105)
        downArrow.xScale = 0.25
        downArrow.yScale = 0.25
        downArrow.zPosition = 1
        self.addChild(downArrow)
        
        let tap = SKLabelNode(fontNamed: "Chalkduster")
        tap.text = "Tap anywhere to play!!!"
        tap.fontSize = 25;
        tap.position = CGPointMake(size.width/2, size.height/1.333 - 150)
        tap.name = "tilt"
        tap.zPosition = 1
        self.addChild(tap)

    }
}

