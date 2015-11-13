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
import AVFoundation


class PlayScene: SKScene, SKPhysicsContactDelegate, UIGestureRecognizerDelegate{

    let motionManager: CMMotionManager = CMMotionManager()
    let heroCategory : UInt32 = 0x1 << 0
    let villainCategory : UInt32 = 0x1 << 1
    let trampolineCategory: UInt32 = 0x1 << 2
    
    //sound bits
    var boingMid : AVAudioPlayer!
    var boingLow : AVAudioPlayer!
    var bleh: AVAudioPlayer!
    //sound janky check
    
    
    var score = 0
    
    
    var bgImage = SKSpriteNode(imageNamed: "squirrelsOnATrampBackgroundV2.jpg")
    var scoreLabel = SKLabelNode(fontNamed:"Chalkduster")
    
    //my janky ass checks
    var gameOver = false
    // Time of last update(currentTime:) call
    var lastUpdateTime = NSTimeInterval(0)
    // Seconds elapsed since last action
    var timeSinceLastJumpingSquirrel = NSTimeInterval(0)
    var timeSinceLastFlyingSquirrel = NSTimeInterval(0)

    // Seconds before performing next action. Choose a default value
    var timeUntilNextJumpingSquirrel = NSTimeInterval(4)
    var timeUntilNextFlyingSquirrel = NSTimeInterval(5)
    

    
    override func didMoveToView(view: SKView) {
        
        score = 0
        setupAudio()
        
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
        self.addChild(main_squirrel)
        
        
        
        let trampoline: TrampolineNode = TrampolineNode()
        trampoline.position = CGPoint(x: size.width/2, y: size.height/6)
        trampoline.size.width = size.width - 0.1*size.width
        self.addChild(trampoline)
        
        let trampoline_line: TrampolineLineNode = TrampolineLineNode()
        trampoline_line.position = CGPoint(x: size.width/2, y: size.height/6)
        trampoline_line.size.width = size.width - 0.1*size.width
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
        let spawnY = random(size.height/2, max: size.height - 20)
        let spawnXRand = random(0, max: 1)

        var actionMove: SKAction
        // Determine speed of the squirrel
        let actualDuration = random(CGFloat(7), max: CGFloat(11))
        let actionMoveDone = SKAction.removeFromParent()

        var spawnX: CGFloat
        if (spawnXRand < 0.5){
            spawnX = -100
            actionMove = SKAction.moveTo(CGPoint(x: self.size.width + 100,y: spawnY), duration: NSTimeInterval(actualDuration))

        }
        else{
            spawnX = size.width + 100
            actionMove = SKAction.moveTo(CGPoint(x: -100,y: spawnY), duration: NSTimeInterval(actualDuration))
        }
        
        let villain_squirrel_flying: VillainSquirrelFlying = VillainSquirrelFlying()
        villain_squirrel_flying.position.x = spawnX
        villain_squirrel_flying.position.y = spawnY
        
        addChild(villain_squirrel_flying)
        villain_squirrel_flying.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    func addVillainSquirrelJumping() {
        
        let spawnY = random(size.height*2, max: size.height*3)
        let spawnX = random(10, max: size.width - 10)
        let randomDir = random(1, max: 10)
        let randomSpeed = random(50, max: 200)
        
        let villain_squirrel_type1: VillainSquirrel = VillainSquirrel()
        villain_squirrel_type1.position.x = spawnX
        villain_squirrel_type1.position.y = spawnY
        
        
        if (randomDir < 5){
            villain_squirrel_type1.physicsBody?.velocity = CGVectorMake(randomSpeed,0)
        }
        else{
            villain_squirrel_type1.physicsBody?.velocity = CGVectorMake(-randomSpeed,0)
        }

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
        if let node = childNodeWithName("hero"){
            
            
            let heroNode = node as! MainSquirrel
            let xPos = heroNode.position.x
            let yPos = heroNode.position.y
        
        
            if(xPos > size.width
                || xPos < 0
                || yPos < 0){
                    if(!self.gameOver){
                        self.gameOver = true
                        self.game_over()
                    }
            }
            else if(yPos > size.height){
                if(!heroNode.redMarkerVisible){
                    heroNode.redMarkerVisible = true
                    heroNode.redMarker.position = CGPointMake(xPos, self.size.height - 20)
                    self.addChild(heroNode.redMarker)
                }
                else{
                    heroNode.redMarker.position = CGPointMake(xPos, size.height - 20)
                }
            }
            else{
                if(heroNode.redMarkerVisible){
                    heroNode.redMarker.removeFromParent()
                    heroNode.redMarkerVisible = false
                }
            }
                
            if (!self.gameOver){
                score++
                processUserMotionForUpdate(currentTime)
                processVillainNodes()
                handleVillainSpawning(currentTime)
                
                
            }
            self.scoreLabel.text = "Score: " + String(score)
        }
        
    }
    
    func processVillainNodes(){

        self.enumerateChildNodesWithName("villainType1") {
            node, stop in
            let realnode = node as! VillainSquirrel
            if (node.position.y > self.size.height){
                realnode.brownMarker.position = CGPointMake(realnode.position.x, self.size.height - 20 )
                if (!realnode.brownMarkerVisible){
                    self.addChild(realnode.brownMarker)
                    realnode.brownMarkerVisible = true
                }
            }
            else if (realnode.brownMarkerVisible){
                realnode.brownMarkerVisible = false
                realnode.brownMarker.removeFromParent()

            }
            if (realnode.position.x > self.size.width + 10 || realnode.position.x < -10){
                if (realnode.brownMarkerVisible){
                    realnode.brownMarkerVisible = false
                    realnode.brownMarker.removeFromParent()
                }
                realnode.removeFromParent()
            }
        }
    }
    
    func handleVillainSpawning(currentTime: CFTimeInterval){
        //when to perform next action
        //TODO: make intervals get shorter as the game goes on
        let delta = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        timeSinceLastJumpingSquirrel += delta
        timeSinceLastFlyingSquirrel += delta
        
        if timeSinceLastJumpingSquirrel >= timeUntilNextJumpingSquirrel {
            addVillainSquirrelJumping()
            // reset
            timeSinceLastJumpingSquirrel = NSTimeInterval(0)
            // Randomize seconds until next action
            timeUntilNextJumpingSquirrel = CDouble(random(1, max: 4))
            
        }
        if timeSinceLastFlyingSquirrel >= timeUntilNextFlyingSquirrel {
            addVillainSquirrelFlying()
            // reset
            timeSinceLastFlyingSquirrel = NSTimeInterval(0)
            // Randomize seconds until next action
            timeUntilNextFlyingSquirrel = CDouble(random(4, max: 10))
            
        }

    }
    
    func processUserMotionForUpdate(currentTime: CFTimeInterval) {
        
        let hero = self.childNodeWithName("hero")

        if let data = motionManager.accelerometerData {
            
            if (fabs(data.acceleration.y) > 0.05) {
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
        
        if (firstBody.categoryBitMask == heroCategory && secondBody.categoryBitMask == villainCategory){
            if(!gameOver){
                self.gameOver = true
                self.game_over()
            }
        }
        else if(firstBody.categoryBitMask == villainCategory || secondBody.categoryBitMask == trampolineCategory){
            let randSound = random(1, max: 3)
            if(randSound >= 1 && randSound < 2){
                print("should play low")
                self.boingLow?.play()
            }
            else{
                print("should play mid")
                self.boingMid?.play()
            }
        }
    }
    
    func game_over()
    {
        self.bleh?.play()
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
        if score > NSUserDefaults.standardUserDefaults().integerForKey("squirrelTrampHighScore1"){
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "squirrelTrampHighScore1")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    
    }
    
    func setupAudio(){
        let audioFilePath1 = NSBundle.mainBundle().pathForResource("boingMid", ofType: "m4a")
        let audioFilePath2 = NSBundle.mainBundle().pathForResource("boingLow", ofType: "m4a")
        let audioFilePath3 = NSBundle.mainBundle().pathForResource("bleh", ofType: "m4a")

        if audioFilePath1 != nil {
            
            let audioFileUrl = NSURL.fileURLWithPath(audioFilePath1!)
            
            self.boingMid = try!AVAudioPlayer(contentsOfURL: audioFileUrl)
            
        }
        else {
            print("audio file 1 is not found")
        }
        
        if audioFilePath2 != nil {
            
            let audioFileUrl = NSURL.fileURLWithPath(audioFilePath2!)
            
            self.boingLow = try!AVAudioPlayer(contentsOfURL: audioFileUrl)
            
        }
        else {
            print("audio file 2 is not found")
        }
        
        if audioFilePath3 != nil {
            
            let audioFileUrl = NSURL.fileURLWithPath(audioFilePath3!)
            
            self.bleh = try!AVAudioPlayer(contentsOfURL: audioFileUrl)
            
        }
        else {
            print("audio file 3 is not found")
        }


    }
    

    
}