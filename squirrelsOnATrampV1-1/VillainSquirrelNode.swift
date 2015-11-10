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
    class func squirrel(location: CGPoint) -> VillainSquirrel {
        let sprite = VillainSquirrel(imageNamed:"villainSquirrelV1.png")
        
        sprite.name = "villainType1"
        sprite.xScale = 0.4
        sprite.yScale = 0.4
        sprite.position = location
        
        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "villainSquirrelV1.png"), size: sprite.size)
        if let physics = sprite.physicsBody {
            
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
        return sprite
    }
}
