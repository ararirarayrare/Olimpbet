//
//  Player.swift
//  Olimpbet
//
//  Created by mac on 07.11.2022.
//

import SpriteKit

class Player: SKSpriteNode {
    
    var jumped: Bool {
        guard let dy = physicsBody?.velocity.dy else {
            return false
        }
        return !(-2...2).contains(dy)
    }
    
    var threwFrom3Pointer: Bool = false
    
    private(set) var isFlipping: Bool = false
    
    private(set) var isAnimating: Bool = false
    
    private var previousPosition: CGPoint = .zero
    private(set) var moveSpeed: CGFloat = .zero
    private(set) var forceMultiplier: CGFloat = 0.03
    
    private var ball: Ball?
    
    var hasBall: Bool {
        return (ball != nil)
    }
    
    private var textures: [SKTexture] = {
        var textures = [SKTexture]()
        for i in 0...5 {
            textures.append(SKTexture(imageNamed: "player-\(i)"))
        }
        return textures
    }()
    
    init() {
        let size = CGSize(width: 120, height: 120)
        super.init(texture: textures.first, color: .clear, size: size)
        
        zPosition = 7
        
        setupPhysics()
    }
    
    private func setupPhysics() {
        physicsBody = SKPhysicsBody(circleOfRadius: 40,
                                    center: CGPoint(x: 0, y: 12))
        physicsBody?.isDynamic = true
        physicsBody?.affectedByGravity = true
        physicsBody?.allowsRotation = false
        
        physicsBody?.mass = 1
        physicsBody?.restitution = 0
        
        physicsBody?.categoryBitMask = .playerBitMask
        physicsBody?.contactTestBitMask = .ballBitMask
    }
    
    func contains(_ node: SKSpriteNode) -> Bool {
        let nodesUpperBoundX = node.position.x + node.size.width / 2
        let nodesLowerBoundX = node.position.x - node.size.width / 2
        
        let nodesUpperBoundY = node.position.y + node.size.height / 2
        let nodesLowerBoundY = node.position.y - node.size.height / 2
        
        
        let upperBoundX = position.x + size.width / 2
        let lowerBoundX = position.x - size.width / 2
        
        let upperBoundY = position.y + size.height / 2
        let lowerBoundY = position.y - size.height / 2
        
        let containsX = (nodesUpperBoundX > lowerBoundX) && (nodesLowerBoundX < upperBoundX)
        let containsY = (nodesUpperBoundY > lowerBoundY) && (nodesLowerBoundY < upperBoundY)
        
        return containsX && containsY
    }
    
    func updateSpeed() {
        let positionChange = CGVector(dx: position.x - previousPosition.x,
                                      dy: position.y - previousPosition.y)

        previousPosition = position

        moveSpeed = sqrt(pow(positionChange.dx, 2) + pow(positionChange.dy, 2))
    }
    
    func moveBy(dx: CGFloat) {
        position.x += dx
        
        guard !self.isAnimating, !self.jumped, !self.isFlipping else {
            return
        }
        
        let animationAction = SKAction.animate(with: (dx > 0) ? textures : textures.reversed(),
                                               timePerFrame: 0.07)
        run(.repeatForever(animationAction), withKey: "move-animation")
        self.isAnimating = true
    }
    
    func stop() {
        self.isAnimating = false
        texture = textures.first
        removeAction(forKey: "move-animation")
    }
    
    func flip(back: Bool) {
        guard !isFlipping else {
            return
        }
        self.stop()
        
        self.forceMultiplier = 0.1
        self.isFlipping = true
        run(.rotate(byAngle: (back ? 2 : -2) * .pi, duration: 0.35)) { [weak self] in
            self?.forceMultiplier = 0.03
            self?.isFlipping = false
        }
    }
    
    func jump() {
        guard !jumped else {
            return
        }
        self.stop()
        
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 700))
    }
    
    func pickUp(ball: Ball) {
        ball.physicsBody = nil
        
        ball.move(toParent: self)
        ball.position = CGPoint(x: 28, y: -12)
        self.ball = ball
    }
    
    func throwBall() {
        guard hasBall, let scene = scene else {
            return
        }
        ball?.setupPhysics()
        
        
        
        let vector = CGVector(dx: CGFloat.random(in: 4.2...5.8),
                              dy: CGFloat.random(in: 5.3...7.2))
        
        ball?.move(toParent: scene)
        ball?.physicsBody?.applyImpulse(vector)
        ball = nil
        
        threwFrom3Pointer = (position.x < 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
