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
        
        score = 0
        self.addedMarker = false
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.view!.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view!.addGestureRecognizer(swipeDown)
        
        
        physicsWorld.contactDelegate = self

        createContent()
        
        let seconds = 1.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            //to delay
        })

        motionManager.startAccelerometerUpdates()
        
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
        
        let screenHeight = screenSize.height
        
        self.scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        self.scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        self.scoreLabel.position = CGPoint(x: 10 , y:screenHeight - 15)
        self.scoreLabel.zPosition = 1
        
        self.addChild(self.scoreLabel)
        
        
        
        let main_squirrel: MainSquirrel = MainSquirrel()
        main_squirrel.position.x = size.width/2
        main_squirrel.position.y = size.height/1.6
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
        
        let spawnY = random(size.height*2, max: size.height*3)
        let spawnX = random(10, max: size.width - 10)
        let randomDir = random(1, max: 10)
        
        // and along a random position along the Y axis as calculated above
        let villain_squirrel_type1: VillainSquirrel = VillainSquirrel()
        villain_squirrel_type1.zPosition = 1
        villain_squirrel_type1.position.x = spawnX
        villain_squirrel_type1.position.y = spawnY
        

        if (randomDir < 5){
            
            villain_squirrel_type1.physicsBody?.velocity = CGVectorMake(75,0)
        }

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
        let xPos = childNodeWithName("hero")?.position.x
        let yPos = childNodeWithName("hero")?.position.y
        
        
        if(xPos > size.width
            || xPos < 0
            || yPos < 0){
            self.gameOver = true
            self.game_over()
        }
        else if(yPos > size.height){
            print("ypos off screen")

            if(!self.addedMarker){
                self.redMarker.name = "redMarker"
                self.redMarker.position = CGPointMake(xPos!, size.height)
                self.redMarker.xScale = 0.5
                self.redMarker.yScale = 0.5
                self.redMarker.zPosition = 1
                
                self.addChild(self.redMarker)
                self.addedMarker = true
            }
            else{
                self.redMarker.position = CGPointMake(xPos!, size.height)
            }
        }
        else{
            if(self.addedMarker){
                self.redMarker.removeFromParent()
                self.addedMarker = false
            }
        }
            
        if (!self.gameOver){
            score++
            processUserMotionForUpdate(currentTime)
            processVillainNodes()

        }
        self.scoreLabel.text = "Score: " + String(score)
        }
        
    }
    
    func processVillainNodes(){

        self.enumerateChildNodesWithName("villainType1") {
            node, stop in
            let realnode = node as! VillainSquirrel
            if (node.position.y > self.size.height){
                realnode.brownMarker.position = CGPointMake(realnode.position.x, self.size.height - 40 )
                realnode.brownMarker.zPosition = 1
                if (!realnode.brownMarkerVisible){
                    self.addChild(realnode.brownMarker)
                    realnode.brownMarkerVisible = true
                }
            }
            else if (realnode.brownMarkerVisible){
                realnode.brownMarkerVisible = false
                realnode.brownMarker.removeFromParent()

            }
        }
    }
    
    func processUserMotionForUpdate(currentTime: CFTimeInterval) {
        
        let hero = self.childNodeWithName("hero")

        if let data = motionManager.accelerometerData {
            
            if (fabs(data.acceleration.y) > 0.2) {
                 hero?.physicsBody?.applyForce(CGVectorMake(CGFloat(data.acceleration.y) * 100, 0))
            }
        }
    }
    

    
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
        
        let seconds = 1.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            let scene = GameScene(size: self.size)
            scene.scaleMode = .AspectFill
            self.view?.presentScene(scene)
        })
        
        
        //saves the score or doesn't (if it doesn't make the high score
        saveScore(score)

        
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