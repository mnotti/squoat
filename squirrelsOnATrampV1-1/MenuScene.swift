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
import Parse




class MenuScene: SKScene {
    
    let upArrow = SKSpriteNode(imageNamed: "arrowUp")
    let downArrow = SKSpriteNode(imageNamed: "arrowDown")
    let rightArrow = SKSpriteNode(imageNamed: "arrowRight")
    let leftArrow = SKSpriteNode(imageNamed: "arrowLeft")
    
    let tapMe = SKSpriteNode(imageNamed: "mainSquirrel")
    
    let instructionsArrow = SKSpriteNode(imageNamed: "redArrowLeft")
    let highScoreArrow = SKSpriteNode(imageNamed: "redArrowRight")
    
    let refreshArrow = SKSpriteNode(imageNamed: "refreshBlack")
    
    let highScoreSegue = SKLabelNode(fontNamed: "Chalkduster")
    let highScoreSegue2 = SKLabelNode(fontNamed: "Chalkduster")
    let instructionsSegue = SKLabelNode(fontNamed: "Chalkduster")

    
    var leftState = false
    var rightState = false
    var midState = true
    
    
    override func didMoveToView(view: SKView){

        create_content()
        
        //add swipes for menu screen nav
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)
            if((self.nodeAtPoint(location) == self.instructionsSegue || self.nodeAtPoint(location) == self.instructionsArrow) && midState){
                
                //move to instructions screen
                midState = false
                leftState = true
                
                for child in self.children {
                    if (child.name != "bg" && child.name != "highScoreArrow"){
                        child.position.x += size.width
                    }
                }
                
            }
            else if((self.nodeAtPoint(location) == self.highScoreArrow || self.nodeAtPoint(location) == self.highScoreSegue || self.nodeAtPoint(location) == self.highScoreSegue2) && midState){
                
                //move to high score screen
                midState = false
                rightState = true
                
                for child in self.children {
                    if (child.name != "bg" && child.name != "instructionsArrow"){
                        child.position.x -= size.width
                    }
                }
                
            }
            else if((self.nodeAtPoint(location) == self.highScoreArrow) && leftState){
                
                //move to mid screen from instructions
                midState = true
                leftState = false
                
                for child in self.children {
                    if (child.name != "bg" && child.name != "highScoreArrow"){
                        child.position.x -= size.width
                    }
                }
                
            }
            else if((self.nodeAtPoint(location) == self.instructionsArrow || self.nodeAtPoint(location) == self.instructionsSegue) && rightState){
                
                //move to mid screen from highscore
                midState = true
                rightState = false
                
                for child in self.children {
                    if (child.name != "bg" && child.name != "instructionsArrow"){
                        child.position.x += size.width
                    }
                }
                
            }
            else if(self.nodeAtPoint(location) == refreshArrow){
                print("scores refreshed?")
                let angle : Float = Float(-4*M_PI)
                let rotate = SKAction.rotateByAngle(CGFloat(angle), duration: 2)
                let refresh: SKSpriteNode = childNodeWithName("refreshArrow") as! SKSpriteNode
                refresh.runAction(rotate)
                refreshScores()
            }
            else if(self.nodeAtPoint(location) == tapMe){
                let scene = PlayScene(size: self.size)
                scene.scaleMode = .AspectFill
                view!.presentScene(scene)
            }
        }
    }

    
    
    func create_content(){
        
        let bgImage = SKSpriteNode(imageNamed: "background")
        bgImage.position = (CGPointMake(size.width/2, size.height/2))
        bgImage.size = size
        bgImage.zPosition = 0
        bgImage.name = "bg"
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
        
        instructionsArrow.position = CGPointMake(30, size.height/2)
        instructionsArrow.xScale = 0.4
        instructionsArrow.yScale = 0.4
        instructionsArrow.zPosition = 1
        instructionsArrow.name = "instructionsArrow"
        self.addChild(instructionsArrow)
        
        instructionsSegue.text = "Instructions"
        instructionsSegue.fontSize = 15;
        instructionsSegue.position = CGPointMake(115, size.height/2 - 5)
        instructionsSegue.name = "instructionsSegue"
        instructionsSegue.zPosition = 1
        self.addChild(instructionsSegue)
        
        highScoreArrow.position = CGPointMake(size.width - 30, size.height/2)
        highScoreArrow.xScale = 0.4
        highScoreArrow.yScale = 0.4
        highScoreArrow.zPosition = 1
        highScoreArrow.name = "highScoreArrow"
        self.addChild(highScoreArrow)
        
        highScoreSegue.text = "Global"
        highScoreSegue.fontSize = 15;
        highScoreSegue.position = CGPointMake(size.width - 110, size.height/2 + 5)
        highScoreSegue.name = "highScoreSegue"
        highScoreSegue.zPosition = 1
        self.addChild(highScoreSegue)
        
        highScoreSegue2.text = "High Scores"
        highScoreSegue2.fontSize = 15;
        highScoreSegue2.position = CGPointMake(size.width - 110, size.height/2 - 15)
        highScoreSegue2.name = "highScoreSegue2"
        highScoreSegue2.zPosition = 1
        self.addChild(highScoreSegue2)

        tapMe.position = CGPointMake(size.width/2, size.height/2)
        tapMe.name = "tap"
        tapMe.zPosition = 1
        tapMe.xScale = 0.35
        tapMe.yScale = 0.35
        self.addChild(tapMe)
        
        
        let tap = SKLabelNode(fontNamed: "Chalkduster")
        tap.text = "Tap Squirrel To Play!!!"
        tap.fontSize = 20;
        tap.position = CGPointMake(size.width/2, size.height/1.333 - 150)
        tap.name = "tap"
        tap.zPosition = 1
        self.addChild(tap)
 
        
        //everything that should go on the instructions screen
        /////////////
        leftArrow.position = CGPointMake(size.width/2 - 90 - size.width, size.height/1.333 - 45)
        leftArrow.xScale = 0.25
        leftArrow.yScale = 0.25
        leftArrow.zPosition = 1
        leftArrow.name = "leftArrow"
        self.addChild(leftArrow)
        
        let tilt = SKLabelNode(fontNamed: "Chalkduster")
        tilt.text = "Tilt left and right"
        tilt.fontSize = 15;
        tilt.position = CGPointMake(size.width/2 - size.width, size.height/1.333 - 50)
        tilt.name = "tilt"
        tilt.zPosition = 1
        self.addChild(tilt)
        
        rightArrow.position = CGPointMake(size.width/2 + 90 - size.width, size.height/1.333 - 45)
        rightArrow.xScale = 0.25
        rightArrow.yScale = 0.25
        rightArrow.zPosition = 1
        rightArrow.name = "rightArrow"
        self.addChild(rightArrow)
    
        upArrow.position = CGPointMake(size.width/2 - size.width, size.height/1.333 - 70)
        upArrow.xScale = 0.25
        upArrow.yScale = 0.25
        upArrow.zPosition = 1
        upArrow.name = "upArrow"
        self.addChild(upArrow)
        
        let swipe = SKLabelNode(fontNamed: "Chalkduster")
        swipe.text = "Swipe up and down"
        swipe.fontSize = 15;
        swipe.position = CGPointMake(size.width/2 - size.width, size.height/1.333 - 90)
        swipe.name = "swipe"
        swipe.zPosition = 1
        self.addChild(swipe)
        
        downArrow.position = CGPointMake(size.width/2 - size.width, size.height/1.333 - 105)
        downArrow.xScale = 0.25
        downArrow.yScale = 0.25
        downArrow.zPosition = 1
        downArrow.name = "downArrow"
        self.addChild(downArrow)
        
        let avoidTheSquirrels = SKLabelNode(fontNamed: "Chalkduster")
        avoidTheSquirrels.text = "And dodge the squirrels!"
        avoidTheSquirrels.fontSize = 15;
        avoidTheSquirrels.position = CGPointMake(size.width/2 - size.width, size.height/1.333 - 135)
        avoidTheSquirrels.name = "avoidTheSquirrels"
        avoidTheSquirrels.zPosition = 1
        self.addChild(avoidTheSquirrels)

        
        
        
        //everything on the high score screen
        refreshArrow.position = CGPointMake(size.width - 30 + size.width, size.height - 30)
        refreshArrow.xScale = 0.2
        refreshArrow.yScale = 0.2
        refreshArrow.zPosition = 1
        refreshArrow.name = "refreshArrow"
        self.addChild(refreshArrow)
        
        createHighScoreNodes(size.width)
        
    
        
        

    }
    func createHighScoreNodes(offset: CGFloat){
        
        let scoreBoardLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreBoardLabel.text = "Global Leaderboard"
        scoreBoardLabel.fontSize = 25
        scoreBoardLabel.position = CGPointMake(size.width/2 + offset, size.height - 40)
        scoreBoardLabel.name = "scoreNode"
        scoreBoardLabel.zPosition = 1
        self.addChild(scoreBoardLabel)
        
        let query = PFQuery(className: "Highscore")
        do{
            let highscores = try query.findObjects()
            let sortedScores = highscores.sort { $0["score"].compare($1["score"] as! Int) == .OrderedDescending }  // use `sorted` in Swift 1.2
            let n = min(highscores.count - 1,9)
            if(n >= 0){
                let topScoreNode = SKLabelNode(fontNamed: "Chalkduster")
                topScoreNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                topScoreNode.text = "1) " + String(sortedScores[0]["score"])
                topScoreNode.fontSize = 15
                topScoreNode.position = CGPointMake(size.width/3 + offset, size.height - 70)
                topScoreNode.name = "scoreNode"
                topScoreNode.zPosition = 1
                self.addChild(topScoreNode)
                
                let topScorerNode = SKLabelNode(fontNamed: "Chalkduster")
                topScorerNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                topScorerNode.text = String(sortedScores[0]["username"])
                topScorerNode.fontSize = 15
                topScorerNode.position = CGPointMake(size.width/2 + offset + 25, size.height - 70)
                topScorerNode.name = "scoreNode"
                topScorerNode.zPosition = 1
                self.addChild(topScorerNode)

                if (n >= 1){
                    let score2Node = SKLabelNode(fontNamed: "Chalkduster")
                    score2Node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                    score2Node.text = "2) " + String(sortedScores[1]["score"])
                    score2Node.fontSize = 15
                    score2Node.position = CGPointMake(size.width/3 + offset, size.height - 90)
                    score2Node.name = "scoreNode"
                    score2Node.zPosition = 1
                    self.addChild(score2Node)
                    
                    let scorer2Node = SKLabelNode(fontNamed: "Chalkduster")
                    scorer2Node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                    scorer2Node.text = String(sortedScores[1]["username"])
                    scorer2Node.fontSize = 15
                    scorer2Node.position = CGPointMake(size.width/2 + offset + 25, size.height - 90)
                    scorer2Node.name = "scoreNode"
                    scorer2Node.zPosition = 1
                    self.addChild(scorer2Node)
                    
                    if (n >= 2){
                        let score3Node = SKLabelNode(fontNamed: "Chalkduster")
                        score3Node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                        score3Node.text = "3) " + String(sortedScores[2]["score"])
                        score3Node.fontSize = 15
                        score3Node.position = CGPointMake(size.width/3 + offset, size.height - 110)
                        score3Node.name = "scoreNode"
                        score3Node.zPosition = 1
                        self.addChild(score3Node)
                        
                        let scorer3Node = SKLabelNode(fontNamed: "Chalkduster")
                        scorer3Node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                        scorer3Node.text = String(sortedScores[2]["username"])
                        scorer3Node.fontSize = 15
                        scorer3Node.position = CGPointMake(size.width/2 + offset + 25, size.height - 110)
                        scorer3Node.name = "scoreNode"
                        scorer3Node.zPosition = 1
                        self.addChild(scorer3Node)
                        
                        if (n >= 3){
                            let score4Node = SKLabelNode(fontNamed: "Chalkduster")
                            score4Node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                            score4Node.text = "4) " + String(sortedScores[3]["score"])
                            score4Node.fontSize = 15
                            score4Node.position = CGPointMake(size.width/3 + offset, size.height - 130)
                            score4Node.name = "scoreNode"
                            score4Node.zPosition = 1
                            self.addChild(score4Node)
                            
                            let scorer4Node = SKLabelNode(fontNamed: "Chalkduster")
                            scorer4Node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                            scorer4Node.text = String(sortedScores[3]["username"])
                            scorer4Node.fontSize = 15
                            scorer4Node.position = CGPointMake(size.width/2 + offset + 25, size.height - 130)
                            scorer4Node.name = "scoreNode"
                            scorer4Node.zPosition = 1
                            self.addChild(scorer4Node)
                            
                            if (n >= 4){
                                let score5Node = SKLabelNode(fontNamed: "Chalkduster")
                                score5Node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                                score5Node.text = "5) " + String(sortedScores[4]["score"])
                                score5Node.fontSize = 15
                                score5Node.position = CGPointMake(size.width/3 + offset, size.height - 150)
                                score5Node.name = "scoreNode"
                                score5Node.zPosition = 1
                                self.addChild(score5Node)
                                
                                let scorer5Node = SKLabelNode(fontNamed: "Chalkduster")
                                scorer5Node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                                scorer5Node.text = String(sortedScores[4]["username"])
                                scorer5Node.fontSize = 15
                                scorer5Node.position = CGPointMake(size.width/2 + offset + 25, size.height - 150)
                                scorer5Node.name = "scoreNode"
                                scorer5Node.zPosition = 1
                                self.addChild(scorer5Node)
                                
                                if (n >= 5){
                                    let score6Node = SKLabelNode(fontNamed: "Chalkduster")
                                    score6Node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                                    score6Node.text = "6) " + String(sortedScores[5]["score"])
                                    score6Node.fontSize = 15
                                    score6Node.position = CGPointMake(size.width/3 + offset, size.height - 170)
                                    score6Node.name = "scoreNode"
                                    score6Node.zPosition = 1
                                    self.addChild(score6Node)
                                    
                                    let scorer6Node = SKLabelNode(fontNamed: "Chalkduster")
                                    scorer6Node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                                    scorer6Node.text = String(sortedScores[5]["username"])
                                    scorer6Node.fontSize = 15
                                    scorer6Node.position = CGPointMake(size.width/2 + offset + 25, size.height - 170)
                                    scorer6Node.name = "scoreNode"
                                    scorer6Node.zPosition = 1
                                    self.addChild(scorer6Node)
                                    
                                    if (n >= 6){
                                        let score7Node = SKLabelNode(fontNamed: "Chalkduster")
                                        score7Node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                                        score7Node.text = "7) " + String(sortedScores[6]["score"])
                                        score7Node.fontSize = 15
                                        score7Node.position = CGPointMake(size.width/3 + offset, size.height - 190)
                                        score7Node.name = "scoreNode"
                                        score7Node.zPosition = 1
                                        self.addChild(score7Node)
                                        
                                        let scorer7Node = SKLabelNode(fontNamed: "Chalkduster")
                                        scorer7Node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                                        scorer7Node.text = String(sortedScores[6]["username"])
                                        scorer7Node.fontSize = 15
                                        scorer7Node.position = CGPointMake(size.width/2 + offset + 25, size.height - 190)
                                        scorer7Node.name = "scoreNode"
                                        scorer7Node.zPosition = 1
                                        self.addChild(scorer7Node)
                                        
                                        if (n >= 7){
                                            let score8Node = SKLabelNode(fontNamed: "Chalkduster")
                                            score8Node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                                            score8Node.text = "8) " + String(sortedScores[7]["score"])
                                            score8Node.fontSize = 15
                                            score8Node.position = CGPointMake(size.width/3 + offset, size.height - 210)
                                            score8Node.name = "scoreNode"
                                            score8Node.zPosition = 1
                                            self.addChild(score8Node)
                                            
                                            let scorer8Node = SKLabelNode(fontNamed: "Chalkduster")
                                            scorer8Node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                                            scorer8Node.text = String(sortedScores[7]["username"])
                                            scorer8Node.fontSize = 15
                                            scorer8Node.position = CGPointMake(size.width/2 + offset + 25, size.height - 210)
                                            scorer8Node.name = "scoreNode"
                                            scorer8Node.zPosition = 1
                                            self.addChild(scorer8Node)
                                            
                                            if (n >= 8){
                                                let score9Node = SKLabelNode(fontNamed: "Chalkduster")
                                                score9Node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                                                score9Node.text = "9) " + String(sortedScores[8]["score"])
                                                score9Node.fontSize = 15
                                                score9Node.position = CGPointMake(size.width/3 + offset, size.height - 230)
                                                score9Node.name = "scoreNode"
                                                score9Node.zPosition = 1
                                                self.addChild(score9Node)
                                                
                                                let scorer9Node = SKLabelNode(fontNamed: "Chalkduster")
                                                scorer9Node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                                                scorer9Node.text = String(sortedScores[8]["username"])
                                                scorer9Node.fontSize = 15
                                                scorer9Node.position = CGPointMake(size.width/2 + offset + 25, size.height - 230)
                                                scorer9Node.name = "scoreNode"
                                                scorer9Node.zPosition = 1
                                                self.addChild(scorer9Node)
                                                
                                                if (n >= 9){
                                                    let score10Node = SKLabelNode(fontNamed: "Chalkduster")
                                                    score10Node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                                                    score10Node.text = "10) " + String(sortedScores[9]["score"])
                                                    score10Node.fontSize = 15
                                                    score10Node.position = CGPointMake(size.width/3 + offset, size.height - 250)
                                                    score10Node.name = "scoreNode"
                                                    score10Node.zPosition = 1
                                                    self.addChild(score10Node)
                                                    
                                                    let scorer10Node = SKLabelNode(fontNamed: "Chalkduster")
                                                    scorer10Node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                                                    scorer10Node.text = String(sortedScores[9]["username"])
                                                    scorer10Node.fontSize = 15
                                                    scorer10Node.position = CGPointMake(size.width/2 + offset + 25, size.height - 250)
                                                    scorer10Node.name = "scoreNode"
                                                    scorer10Node.zPosition = 1
                                                    self.addChild(scorer10Node)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    

                }
            }
            
        }
        catch{
            print(error)
        }
    }
    
    func removeHighScoreNodes(){
        self.enumerateChildNodesWithName("scoreNode") {
            node, stop in
            node.removeFromParent()
        }
    }
    
    func refreshScores(){
        removeHighScoreNodes()
        createHighScoreNodes(0)
    }
}

