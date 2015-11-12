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
    class func squirrel(location: CGPoint) -> VillainSquirrelFlying {
        let sprite = VillainSquirrelFlying(imageNamed:"villainSquirrelFlyingV1.png")
        
        sprite.name = "villainFlying"
        sprite.xScale = 0.4
        sprite.yScale = 0.4
        sprite.position = location
        sprite.zPosition = 1
        
        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "villainSquirrelFlyingV1.png"), size: sprite.size)
        if let physics = sprite.physicsBody {
            
            physics.categoryBitMask = 0x1 << 1
            physics.contactTestBitMask = 0x1 << 0
            physics.collisionBitMask = 0x1 << 0

            
            physics.affectedByGravity = false
            physics.allowsRotation = false
            physics.dynamic = true;
            
            //physics.mass = 100
            
            physics.friction = 0
            physics.restitution = 1.05
            
        }
        return sprite
    }
}
