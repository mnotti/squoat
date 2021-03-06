//
//  Villain_Squirrel_Flying_Node.swift
//  squirrels_on_a_trampV1.0
//
//  Created by Markus Notti on 5/25/15.
//  Copyright (c) 2015 Markus Notti. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class VillainSquirrelFlying: SKSpriteNode {
    var redExclamationPoint = SKSpriteNode()
    
    var redExclamationPointIsVisible: Bool
    var movingRight: Bool
    var movingLeft: Bool
    
    override init(texture: SKTexture!, color: SKColor, size: CGSize) {
        self.redExclamationPoint = SKSpriteNode(imageNamed: "redExclamation")
        self.redExclamationPointIsVisible = false
        self.redExclamationPoint.zPosition = 2
        self.redExclamationPoint.xScale = 0.1
        self.redExclamationPoint.yScale = 0.1
        self.movingRight = false
        self.movingLeft = false
                
        let texture = SKTexture(imageNamed: "villainSquirrelFlying")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        self.name = "villainFlying"
        self.xScale = 0.2
        self.yScale = 0.2
        self.zPosition = 2
        self.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "villainSquirrelFlying"), size: self.size)
        if let physics = self.physicsBody {
            
            physics.categoryBitMask = 0x1 << 3
            physics.contactTestBitMask = (0x1 << 0)
            physics.collisionBitMask = (0x1 << 0)
            
            physics.affectedByGravity = false
            physics.allowsRotation = false
            physics.dynamic = true;
            
            physics.friction = 0
            physics.restitution = 1.05
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
