//
//  MenuScene.swift
//  squirrelsOnATrampV1-1
//
//  Created by Markus Notti on 5/25/15.
//  Copyright (c) 2015 Markus Notti. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit
import SpriteKit


class PlayScene: SKScene, SKPhysicsContactDelegate, UIGestureRecognizerDelegate{

    let motionManager: CMMotionManager = CMMotionManager()
    
    var contentCreated = false
    let heroCategory : UInt32 = 0x1 << 0
    let villainCategory : UInt32 = 0x1 << 1
    var score = 0
    
    var bgImage = SKSpriteNode(imageNamed: "squirrelsOnATrampBackgroundV2.jpg")
    var scoreLabel = SKLabelNode(fontNamed:"Chalkduster")
    var redMarker = SKSpriteNode(imageNamed:"redMarkGimp.png")
    
    //my janky ass checks
    var addedMarker = false
    var gameOver = false
    

    
    override func didMoveToView(view: SKView) {
        
        contentCreated = false
        score = 0
        
        var swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.view!.addGestureRecognizer(swipeUp)
        
        var swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view!.addGestureRecognizer(swipeDown)
        
        
        physicsWorld.contactDelegate = self

        if (!contentCreated) {
            createContent()
            contentCreated = true
        }
        
        if motionManager.accelerometerAvailable == true {
            self.motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue()) {
                (data, error) in
                
                if (data!.acceleration.y != 0) {
                    
                    self.motionManager.accelerometerActive == true
                    if(!self.gameOver){
                    //self.handle_tilt(CGFloat(data!.acceleration.y))
                        self.childNodeWithName("hero")?.physicsBody?.applyForce(CGVectorMake(CGFloat((data?.acceleration.y)!) * 50, 0))
                    }
                }
                    
                
            }
            
        }
        
        //  spawns flying squirrels
                /*self.runAction(SKAction.repeatActionForever(
                    SKAction.sequence([
                        SKAction.runBlock(addVillainSquirrelFlying),
                        SKAction.waitForDuration(13)
                        ])
                    ), withKey: "spawn_flying_squirrels")*/
        
      //  spawns jumping squirrels
                self.runAction(SKAction.repeatActionForever(
                    SKAction.sequence([
                        SKAction.runBlock(addVillainSquirrelJumping),
                        SKAction.waitForDuration(7)
                        ])
                    ), withKey: "spawn_villain_squirrels")
//
        
        
  }
        
    
    func createContent() {
        
        //makes background
        bgImage.position = (CGPointMake(size.width/2, size.height/2))
        bgImage.size = size
        bgImage.zPosition = 0
        self.addChild(bgImage)
        
        //makes score label
        self.scoreLabel.text = "Score: " + String(score)
        self.scoreLabel.fontSize = 30;
        self.scoreLabel.name = "scoreLabel"
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        self.scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        self.scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        self.scoreLabel.position = CGPoint(x: 10 , y:screenSize.height - 15)
        self.scoreLabel.zPosition = 1
        
        self.addChild(self.scoreLabel)
        
        
        
        let main_squirrel = MainSquirrel.squirrel(CGPoint(x: size.width/2, y: size.height/1.6))
        main_squirrel.name = "hero"
        main_squirrel.zPosition = 1
        self.addChild(main_squirrel)
        
        
        
        let trampoline = TrampolineNode.trampolineMake(CGPoint(x: size.width/2, y: size.height/6))
        trampoline.size.width = size.width - 0.1*size.width
        trampoline.zPosition = 1
        self.addChild(trampoline)
        
        let trampoline_line = TrampolineLineNode.trampolineLineMake(CGPoint(x: size.width/2, y: size.height/6))
        trampoline_line.size.width = size.width - 0.1*size.width
        trampoline_line.zPosition = 1
        self.addChild(trampoline_line)
        
        backgroundColor = SKColor.blueColor()
    }
    
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addVillainSquirrelFlying() {
        let actualY = random(size.height/2, max: size.height/1.3)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        let villain_squirrel_flying = VillainSquirrelFlying.squirrel(CGPoint(x: size.width + 200 , y: actualY))
        villain_squirrel_flying.zPosition = 1
        
        // Add the monster to the scene
        addChild(villain_squirrel_flying)
        
        // Determine speed of the monster
        let actualDuration = random(CGFloat(7), max: CGFloat(11))
        
        // Create the actions
        let actionMove = SKAction.moveTo(CGPoint(x: -villain_squirrel_flying.size.width/2,y: actualY), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        villain_squirrel_flying.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    func addVillainSquirrelJumping() {
        
        // Create sprite
        // Determine where to spawn the monster along the Y axis
        
        let actualY = random(size.height*2, max: size.height*3)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        let villain_squirrel_type1 = VillainSquirrel.squirrel(CGPoint(x: size.width - size.width/5 , y: actualY))
        villain_squirrel_type1.zPosition = 1
        // Add the monster to the scene
        addChild(villain_squirrel_type1)
        

        
    }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Up:
                childNodeWithName("hero")?.physicsBody?.applyForce(CGVectorMake(0, 500))
            case UISwipeGestureRecognizerDirection.Down:
                childNodeWithName("hero")?.physicsBody?.velocity = CGVectorMake(0,0)
            default:
                break
            }
        }
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        if (childNodeWithName("hero") != nil){
        var xPos = childNodeWithName("hero")?.position.x
        var yPos = childNodeWithName("hero")?.position.y
        
        
        if(xPos > size.width
            || xPos < 0
            || yPos < 0){
            self.gameOver = true
            self.game_over()
        }
        else if(yPos > size.height){

            self.redMarker.name = "redMarker"
            if(!self.addedMarker){
                self.redMarker.position = CGPointMake(xPos!, size.height)
                self.redMarker.xScale = 0.5
                self.redMarker.yScale = 0.5
                self.addChild(self.redMarker)
                self.addedMarker = true
            }
        }
        else{
            if(self.addedMarker == true){
                self.redMarker.removeFromParent()
                self.addedMarker = false
            }
        }

        score++
        self.scoreLabel.text = "Score: " + String(score)
        }
        
    }
    
    
    /*func handle_tilt(acceleration_data: CGFloat){
        
        if (!gameOver){
        childNodeWithName("hero")?.physicsBody?.applyForce(CGVectorMake(acceleration_data * 50, 0))
        }
    }*/
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        //Assign the two physics bodies so that the one with the lower category is always stored in firstBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else {
            
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        //contact between ball and cup
        if firstBody.categoryBitMask == heroCategory && secondBody.categoryBitMask == villainCategory {
            self.gameOver = true
            self.game_over()
        }
    }
    
    func game_over()
    {
        self.removeActionForKey("spawn_flying_squirrels")
        self.removeActionForKey("spawn_flying_squirrels")
        
        self.motionManager.stopAccelerometerUpdates()
        if let recognizers = self.view?.gestureRecognizers {
            for recognizer in recognizers {
                self.view!.removeGestureRecognizer(recognizer)
            }
        }
        
        
        //saves the score or doesn't (if it doesn't make the high score
        saveScore(score)
        
        
        let scene = GameScene(size: self.size)
        scene.scaleMode = .AspectFill
        

        view?.presentScene(scene)
        
        }
    
    func saveScore(score: Int){
        
        //Check if score is higher than NSUserDefaults stored value and change NSUserDefaults stored value if it's true
        if score > NSUserDefaults.standardUserDefaults().integerForKey("squirrelTrampHighScore1")
        {
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "squirrelTrampHighScore1")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    
    }
    
}