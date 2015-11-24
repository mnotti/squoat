//
//  Trampoline_Line_Node.swift
//  squirrels_on_a_trampV1.0
//
//  Created by Markus Notti on 5/25/15.
//  Copyright (c) 2015 Markus Notti. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class TrampolineLineNode: SKSpriteNode {
    
    override init(texture: SKTexture!, color: SKColor, size: CGSize) {
        let texture = SKTexture(imageNamed: "trampolineLine")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        self.name = "trampolineliney"
        self.xScale = 1.75
        self.yScale = 0.75
        self.zPosition = 1
        
        self.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "trampolineLine"), size: self.size)
        if let physics = self.physicsBody {
            physics.categoryBitMask = 0x1 << 2
            physics.affectedByGravity = false
            physics.allowsRotation = false
            physics.dynamic = false
            physics.friction = 0
            physics.restitution = 1.05
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}