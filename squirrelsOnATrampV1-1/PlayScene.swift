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
import Parse
import SystemConfiguration




class PlayScene: SKScene, SKPhysicsContactDelegate, UIGestureRecognizerDelegate{
    
    ////////////////////////////////////////////////
    //bitmask manipulation declaration and globals//
    ////////////////////////////////////////////////
    
    let motionManager: CMMotionManager = CMMotionManager()
    let heroCategory : UInt32 = 0x1 << 0
    let villainCategory : UInt32 = 0x1 << 1
    let trampolineCategory: UInt32 = 0x1 << 2
    let villainFlyingCategory: UInt32 = 0x1 << 3
    
    //////////////////////
    //audio bits globals//
    //////////////////////
    
    var bleh: AVAudioPlayer!
    
    ////////////////////////
    //general game globals//
    ////////////////////////
    
    var score = 0
    var gameOver = false
    var upSwipes = 0
    
    /////////////////
    //image globals//
    /////////////////
    
    var bgImage = SKSpriteNode(imageNamed: "background")
    var scoreLabel = SKLabelNode(fontNamed:"Chalkduster")
    let myTextField: UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: 200.00, height: 40.00));
    let button   = UIButton(type: UIButtonType.System) as UIButton
    let initialsLabel2 = SKLabelNode(fontNamed: "Chalkduster")



    
    ////////////////////////////////////
    //time management initialization////
    ////////////////////////////////////
    
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
    
    func addVillainSquirrelFlying() {
        
        let villain_squirrel_flying: VillainSquirrelFlying = VillainSquirrelFlying()
        let spawnY: CGFloat
        
        //1 in 4 chance, the flying squirrel will fly low to the trampoline
        let trampolineBuzz = random(1, max: 5)
        if (trampolineBuzz < 2){
            spawnY = size.height/3
        }
        else{
            spawnY = random(size.height/3, max: size.height - 20)
        }
        let spawnXRand = random(0, max: 1)

        var actionMove: SKAction
        
        // Determine speed of the squirrel
        let actualDuration = random(CGFloat(7), max: CGFloat(11))
        let actionMoveDone = SKAction.removeFromParent()

        var spawnX: CGFloat
        if (spawnXRand < 0.5){
            spawnX = -100
            villain_squirrel_flying.movingRight = true
            actionMove = SKAction.moveTo(CGPoint(x: self.size.width + 100,y: spawnY), duration: NSTimeInterval(actualDuration))

        }
        else{
            spawnX = size.width + 100
            villain_squirrel_flying.movingLeft = true
            actionMove = SKAction.moveTo(CGPoint(x: -100,y: spawnY), duration: NSTimeInterval(actualDuration))
        }
        
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
        
        //50-50 chance of falling to the left-right
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
                if (upSwipes == 0){
                    childNodeWithName("hero")?.physicsBody?.applyForce(CGVectorMake(0, 100))
                    upSwipes++
                }
            case UISwipeGestureRecognizerDirection.Down:
                childNodeWithName("hero")?.physicsBody?.velocity = CGVectorMake(0,-25)
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
                    heroNode.redMarker.position = CGPointMake(xPos, self.size.height - 20)
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
    
    //handles the deletion of villain squirrels and also the adding and removing of exclamation marks and
    //brown markers
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
        self.enumerateChildNodesWithName("villainFlying") {
            node, stop in
            let realnode = node as! VillainSquirrelFlying
            if (realnode.movingLeft){
                if (node.position.x > self.size.width + 5){
                    realnode.redExclamationPoint.position = CGPointMake(self.size.width - 20, realnode.position.y)
                    if (!realnode.redExclamationPointIsVisible){
                        self.addChild(realnode.redExclamationPoint)
                        realnode.redExclamationPointIsVisible = true
                    }
                }
                else if (realnode.redExclamationPointIsVisible){
                    realnode.redExclamationPointIsVisible = false
                    realnode.redExclamationPoint.removeFromParent()
                    
                }
                if (realnode.position.x < -10){
                    if (realnode.redExclamationPointIsVisible){
                        realnode.redExclamationPointIsVisible = false
                        realnode.redExclamationPoint.removeFromParent()
                    }
                    realnode.removeFromParent()
                }
            }
            else if(realnode.movingRight){
                if (node.position.x < 5){
                    realnode.redExclamationPoint.position = CGPointMake(20, realnode.position.y)
                    if (!realnode.redExclamationPointIsVisible){
                        self.addChild(realnode.redExclamationPoint)
                        realnode.redExclamationPointIsVisible = true
                    }
                }
                else if (realnode.redExclamationPointIsVisible){
                    realnode.redExclamationPointIsVisible = false
                    realnode.redExclamationPoint.removeFromParent()
                    
                }
                if (realnode.position.x > self.size.width + 10){
                    if (realnode.redExclamationPointIsVisible){
                        realnode.redExclamationPointIsVisible = false
                        realnode.redExclamationPoint.removeFromParent()
                    }
                    realnode.removeFromParent()
                }

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
                 hero?.physicsBody?.applyForce(CGVectorMake(CGFloat(data.acceleration.y) * 25, 0))//formally 100 (not 25)
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
        
        if (firstBody.categoryBitMask == heroCategory && secondBody.categoryBitMask == villainCategory
            || firstBody.categoryBitMask == heroCategory && secondBody.categoryBitMask == villainFlyingCategory){

            if(!gameOver){
                self.gameOver = true
                self.game_over()
            }
        }
        else if(firstBody.categoryBitMask == villainCategory && secondBody.categoryBitMask == trampolineCategory){
            let villainNode = firstBody.node as! VillainSquirrel
            villainNode.playSound()
        }
        
        if(firstBody.categoryBitMask == heroCategory && secondBody.categoryBitMask == trampolineCategory){
            upSwipes = 0
            print("hero hit tramp")
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
        //delays 1 second before exiting playScene
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.saveScore(self.score)
        })

        
        //saves the score or doesn't (if it doesn't make the high score)

    }
    
    func saveScore(score: Int){
        
        //Check if score is higher than NSUserDefaults stored value and change NSUserDefaults stored value if it's true
        if (score > NSUserDefaults.standardUserDefaults().integerForKey("squirrelTrampHighScore1")){
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "squirrelTrampHighScore1")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        //TODO: if score is good enough to be put on leaderboards
        if (connectedToNetwork()){
            checkIfGlobalHighScore(score)
        }
        else{
            print("is not connected")
            let scene = MenuScene(size: self.size)
            scene.scaleMode = .AspectFill
            self.view?.presentScene(scene)

        }
    }
    
    func checkIfGlobalHighScore(score: Int){
        var isHighScore = false
        let query = PFQuery(className: "Highscore")
        do{
            let highscores = try query.findObjects()
            let sortedScores = highscores.sort { $0["score"].compare($1["score"] as! Int) == .OrderedDescending }  // use `sorted` in Swift 1.2
            let n = min(highscores.count - 1,9)
            if (n >= 0){
                for i in 0...n{
                    if (score > sortedScores[i]["score"] as! Int){
                        isHighScore = true
                        saveGlobalHighScore(score)
                        break
                    }
                }
            }
            else{
                isHighScore = true
                saveGlobalHighScore(score)
                
            }

        }
        catch{
            print(error)
        }
        if (!isHighScore){
            print("is not high score")
            let scene = MenuScene(size: self.size)
            scene.scaleMode = .AspectFill
            self.view?.presentScene(scene)
        }
        

    }
    
    func saveGlobalHighScore(score: Int){
        
        let initialsLabel1 = SKLabelNode(fontNamed: "Chalkduster")
        initialsLabel1.text = "Congrats! You made the global top 10!"
        initialsLabel1.fontSize = 15;
        initialsLabel1.position = CGPointMake(size.width/2, size.height - 60)
        initialsLabel1.name = "initialsLabel"
        initialsLabel1.zPosition = 1
        self.addChild(initialsLabel1)
        
        initialsLabel2.text = "Enter Your Initials..."
        initialsLabel2.fontSize = 15;
        initialsLabel2.position = CGPointMake(size.width/2, size.height - 80)
        initialsLabel2.name = "initialsLabel2"
        initialsLabel2.zPosition = 1
        self.addChild(initialsLabel2)
        
        myTextField.tag = 100
        myTextField.backgroundColor = UIColor.whiteColor()
        myTextField.frame = CGRectMake(size.width/2 - 30, 90, 60, 50)
        myTextField.borderStyle = UITextBorderStyle.RoundedRect
        self.view!.addSubview(myTextField)
        
        button.tag = 200
        button.frame = CGRectMake(size.width/2 - 50, 150, 100, 50)
        button.backgroundColor = UIColor.greenColor()
        button.layer.cornerRadius = 5
        button.setTitle("Continue", forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view!.addSubview(button)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touched")
        myTextField.resignFirstResponder()
    }
    
    func buttonAction(sender:UIButton!)
    {
        let initials = self.myTextField.text
        if (initials!.characters.count > 3 || initials!.characters.count < 3){
            self.initialsLabel2.text = "Must Be 3 Chars!"
            self.initialsLabel2.fontColor = SKColor.redColor()
        }
        else{
            self.view!.viewWithTag(100)?.removeFromSuperview()
            self.view!.viewWithTag(200)?.removeFromSuperview()
            
            let scoreObject = PFObject(className: "Highscore")
            scoreObject["score"] = score
            scoreObject["username"] = initials
            scoreObject.saveInBackground()
            
            print("######1")
            let scene = MenuScene(size: self.size)
            scene.scaleMode = .AspectFill
            self.view?.presentScene(scene)
        }
    }


    
    func setupAudio(){

        
        if let audioFilePath3 = NSBundle.mainBundle().pathForResource("bleh", ofType: "m4a"){
            let audioFileUrl = NSURL.fileURLWithPath(audioFilePath3)
            self.bleh = try!AVAudioPlayer(contentsOfURL: audioFileUrl)
        }


    }

    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.Reachable)
        let needsConnection = flags.contains(.ConnectionRequired)
        return (isReachable && !needsConnection)
    }
    

    
}