//
//  main_squirrel.swift
//  squirrels_on_a_trampV1.0
//
//  Created by Markus Notti on 5/25/15.
//  Copyright (c) 2015 Markus Notti. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class MainSquirrel: SKSpriteNode {
    var redMarker = SKSpriteNode()
    var redMarkerVisible: Bool
    
    override init(texture: SKTexture!, color: SKColor, size: CGSize) {
        
        self.redMarker = SKSpriteNode(imageNamed:"redMarkGimp.png")
        self.redMarker.zPosition = 2
        self.redMarker.xScale = 0.25
        self.redMarker.yScale = 0.25
        self.redMarkerVisible = false
        
        let texture = SKTexture(imageNamed: "squirrelV1.png")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        self.name = "hero"
        self.xScale = 0.2
        self.yScale = 0.2
        self.zPosition = 3
        self.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "squirrelV1.png"), size: self.size)
        if let physics = self.physicsBody {
            
            physics.categoryBitMask = 0x1 << 0
            physics.contactTestBitMask = 0x1 << 1
            
            
            physics.affectedByGravity = true
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
