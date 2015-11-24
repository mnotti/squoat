//
//  Villain_Squirrel1_Node.swift
//  squirrels_on_a_trampV1.0
//
//  Created by Markus Notti on 5/25/15.
//  Copyright (c) 2015 Markus Notti. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import AVFoundation


class VillainSquirrel: SKSpriteNode {
    var brownMarker = SKSpriteNode()
    var brownMarkerVisible: Bool
    var boingMid: AVAudioPlayer!
    var boingLow: AVAudioPlayer!
    var soundPlayed: Bool
    
    override init(texture: SKTexture!, color: SKColor, size: CGSize) {
        self.brownMarker = SKSpriteNode(imageNamed:"brownMarker")
        self.brownMarker.zPosition = 2
        self.brownMarker.xScale = 0.25
        self.brownMarker.yScale = 0.25

        self.brownMarkerVisible = false
        self.soundPlayed = false
        
        let texture = SKTexture(imageNamed: "villainSquirrel")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        self.name = "villainType1"
        self.xScale = 0.2
        self.yScale = 0.2
        self.zPosition = 2
        self.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "villainSquirrel"), size: self.size)
        if let physics = self.physicsBody {
            
            physics.categoryBitMask = 0x1 << 1
            physics.contactTestBitMask = (0x1 << 0) | (0x1 << 2)
            physics.collisionBitMask = (0x1 << 0) | (0x1 << 2)
            
            physics.affectedByGravity = true
            physics.allowsRotation = false
            physics.dynamic = true;
            
            physics.friction = 0
            physics.restitution = 1.05
        }
        self.setupAudio()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func playSound(){
        if (!soundPlayed){
            let rand = arc4random_uniform(2)
            if (rand < 1){
                boingLow.play()
            }
            else{
                boingMid.play()
            }
            soundPlayed = true
            
            //allows sound to be played again after 1 second (avoids the muliple collision problem)
            let seconds = 1.0
            let delay = seconds * Double(NSEC_PER_SEC)
            let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                    self.soundPlayed = false
            })
        }
    }
    
    func setupAudio(){
        if let audioFilePath1 = NSBundle.mainBundle().pathForResource("boingMid", ofType: "m4a") {
            let audioFileUrl = NSURL.fileURLWithPath(audioFilePath1)
            self.boingMid = try!AVAudioPlayer(contentsOfURL: audioFileUrl)
        }
        if  let audioFilePath2 = NSBundle.mainBundle().pathForResource("boingLow", ofType: "m4a") {
            let audioFileUrl = NSURL.fileURLWithPath(audioFilePath2)
            self.boingLow = try!AVAudioPlayer(contentsOfURL: audioFileUrl)
        }
    }
}
