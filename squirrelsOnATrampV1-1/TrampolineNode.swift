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
    
    override init(texture: SKTexture!, color: SKColor, size: CGSize) {
    
        let texture = SKTexture(imageNamed: "trampoline")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        self.name = "trampoliney"
        self.xScale = 1.75
        self.yScale = 0.75
        self.zPosition = 1
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}