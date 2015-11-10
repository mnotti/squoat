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
    class func squirrel(location: CGPoint) -> MainSquirrel {
        let sprite = MainSquirrel(imageNamed:"squirrelV1.png")
        
        sprite.name = "squirrely"
        sprite.xScale = 0.4
        sprite.yScale = 0.4
        sprite.position = location
        
        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "squirrelV1.png"), size: sprite.size)
        if let physics = sprite.physicsBody {
            
            physics.categoryBitMask = 0x1 << 0
            physics.contactTestBitMask = 0x1 << 1


            physics.affectedByGravity = true
            physics.allowsRotation = false
            physics.dynamic = true;
            
            physics.friction = 0
            physics.restitution = 1.05
     
        }
        return sprite
    }
}
