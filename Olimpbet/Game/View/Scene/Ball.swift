//
//  Ball.swift
//  Olimpbet
//
//  Created by mac on 07.11.2022.
//

import SpriteKit

class Ball: SKSpriteNode {
    
    var previousPosition: CGPoint = .zero
    
    init() {
        let texture = SKTexture(imageNamed: "ball")
        let size = CGSize(width: 40, height: 40)
        super.init(texture: texture, color: .clear, size: size)
        
        zPosition = 8
        
        setupPhysics()
    }
    
    func setupPhysics() {
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.isDynamic = true
        physicsBody?.affectedByGravity = true
        physicsBody?.allowsRotation = true
        
        physicsBody?.mass = 0.01
        physicsBody?.restitution = 0.7
        physicsBody?.angularDamping = 0.05
        physicsBody?.linearDamping = 0.05
        
        physicsBody?.categoryBitMask = .ballBitMask
        physicsBody?.contactTestBitMask = .playerBitMask
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
