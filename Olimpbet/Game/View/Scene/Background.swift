//
//  Background.swift
//  Olimpbet
//
//  Created by mac on 08.11.2022.
//

import SpriteKit

class Background: SKSpriteNode {
    
    private lazy var ground: SKSpriteNode = {
        let ground = SKSpriteNode()
        ground.texture = SKTexture(imageNamed: "game-ground")
        ground.size = CGSize(width: size.width, height: 80)
        ground.position.y = (ground.size.height - size.height) / 2
        ground.zPosition = 2
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ground.size.width,
                                                               height: ground.size.height - 30))
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.allowsRotation = false
        ground.physicsBody?.isDynamic = false
        
        
        return ground
    }()
    
    init(size: CGSize) {
        let texture = SKTexture(imageNamed: "game-bg")
        super.init(texture: texture, color: .clear, size: size)
        
        zPosition = 1
        
        addChild(ground)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
