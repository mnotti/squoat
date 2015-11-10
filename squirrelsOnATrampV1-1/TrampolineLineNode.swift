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
    class func trampolineLineMake(location: CGPoint) -> TrampolineLineNode {
        let sprite = TrampolineLineNode(imageNamed:"trampolineLineV1.png")
        
        sprite.name = "trampolineLiney"
        sprite.xScale = 1.75
        sprite.yScale = 0.75
        sprite.position = location
        
        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "trampolineLineV1.png"), size: sprite.size)
        if let physics = sprite.physicsBody {
            physics.affectedByGravity = false
            physics.allowsRotation = false
            physics.dynamic = false
            physics.friction = 0
            physics.restitution = 1.05
            
            // physics.linearDamping = 0.75
            //physics.angularDamping = 0.75
        }
        return sprite
    }
}