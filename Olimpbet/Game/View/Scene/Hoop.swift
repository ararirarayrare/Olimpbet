//
//  Hoop.swift
//  Olimpbet
//
//  Created by mac on 08.11.2022.
//

import SpriteKit

class Hoop: SKSpriteNode {
    
    var ringPosition: CGPoint {
        return CGPoint(x: position.x - 25.5,
                       y: position.y + 64)
    }
    
    init() {
        let texture = SKTexture(imageNamed: "hoop")
        let size = CGSize(width: 140, height: 300)
        super.init(texture: texture, color: .clear, size: size)
        
        zPosition = 10
        
        setupPhysics()

    }
    
    private func setupPhysics() {
        
        func configurePhysicsBody(ofNode node: SKSpriteNode) {
            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
            node.physicsBody?.isDynamic = false
            node.physicsBody?.affectedByGravity = false
            node.physicsBody?.allowsRotation = false
            
            node.physicsBody?.linearDamping = 0.3
            node.physicsBody?.angularDamping = 0.3
            node.physicsBody?.friction = 0.2
        }
        
        let pillar = SKSpriteNode()
        pillar.size = CGSize(width: size.width * 0.157,
                             height: size.height * 0.685)
        
        pillar.position = CGPoint(x: (size.width - pillar.size.width) / 2,
                                  y: (pillar.size.height - size.height) / 2)
        
        configurePhysicsBody(ofNode: pillar)
        pillar.physicsBody?.categoryBitMask = .pillarBitMask
        pillar.physicsBody?.contactTestBitMask = .ballBitMask
        addChild(pillar)
        
        let backboard = SKSpriteNode()
        backboard.size = CGSize(width: size.width * 0.086,
                                height: size.height * 0.35)
        backboard.position = CGPoint(x: 18,
                                     y: (size.height - backboard.size.height) / 2)
        
        configurePhysicsBody(ofNode: backboard)
        backboard.physicsBody?.angularDamping = 5
        backboard.physicsBody?.linearDamping = 5
        addChild(backboard)
        
        let ring = SKSpriteNode()
        ring.size = CGSize(width: 8, height: 10)
        ring.position = CGPoint(x: -size.width / 2 + 4,
                                y: self.ringPosition.y)
        
        configurePhysicsBody(ofNode: ring)
        addChild(ring)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
