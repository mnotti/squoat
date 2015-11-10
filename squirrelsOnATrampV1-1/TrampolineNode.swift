//
//  Trampoline_Node.swift
//  squirrels_on_a_trampV1.0
//
//  Created by Markus Notti on 5/25/15.
//  Copyright (c) 2015 Markus Notti. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class TrampolineNode: SKSpriteNode {
    class func trampolineMake(location: CGPoint) -> TrampolineNode {
        let sprite = TrampolineNode(imageNamed:"trampolineV1.png")
        
        sprite.name = "trampoliney"
        sprite.xScale = 1.75
        sprite.yScale = 0.75
        sprite.position = location
        
//        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "trampolineV1.png"), size: sprite.size)
//        if let physics = sprite.physicsBody {
//            physics.affectedByGravity = false
//            physics.allowsRotation = false
//            physics.dynamic = false
//            physics.friction = 0
//            physics.restitution = 1.05
        
           // physics.linearDamping = 0.75
            //physics.angularDamping = 0.75
        return sprite
    }
}