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

class VillainSquirrel: SKSpriteNode {
    var brownMarker = SKSpriteNode()
    var brownMarkerVisible: Bool
    
    override init(texture: SKTexture!, color: SKColor, size: CGSize) {
        

        self.brownMarker = SKSpriteNode(imageNamed:"brownMarkerTrans.png")
        self.brownMarker.zPosition = 1
        self.brownMarker.xScale = 0.25
        self.brownMarker.yScale = 0.25

        self.brownMarkerVisible = false
        
        let texture = SKTexture(imageNamed: "villainSquirrelV1.png")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        self.name = "villainType1"
        self.xScale = 0.2
        self.yScale = 0.2
        self.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "villainSquirrelV1.png"), size: self.size)
        if let physics = self.physicsBody {
            
            physics.categoryBitMask = 0x1 << 1
            physics.contactTestBitMask = 0x1 << 0
            physics.collisionBitMask = 0x1 << 0
            
            physics.affectedByGravity = true
            physics.allowsRotation = false
            physics.dynamic = true;
            
            physics.velocity = CGVectorMake(-75,0)
            
            //physics.mass = 100
            
            physics.friction = 0
            physics.restitution = 1.05
        }


        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func activateMarker(){
        self.brownMarkerVisible = true
    }
    
    
    }
