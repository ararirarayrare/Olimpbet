//
//  TimerLabel.swift
//  Olimpbet
//
//  Created by mac on 10.11.2022.
//

import SpriteKit
import Combine

class TimerNode: SKSpriteNode {
     
    @Published
    private(set) var secondsRemaining: Int {
        didSet {
            label.text = String(describing: secondsRemaining)
        }
    }
    
    private let titleLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.text = "Time left:"
        label.fontName = "Copperplate Bold"
        label.fontSize = 18
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        
        return label
    }()
    
    
    private let label: SKLabelNode = {
        let label = SKLabelNode()
        label.fontName = "Copperplate Bold"
        label.fontSize = 32
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        
        return label
    }()
    
    init(duration: Int) {
        self.secondsRemaining = duration
        
        let texture = SKTexture(imageNamed: "score-bg")
        super.init(texture: texture, color: .clear, size: CGSize(width: 120, height: 100))
        
        titleLabel.position = CGPoint(x: 0, y: size.height / 2 - 32)
        addChild(titleLabel)
        
        label.text = String(describing: secondsRemaining)
        label.position = CGPoint(x: 0, y: titleLabel.position.y - 36)
        addChild(label)
        
        
        zPosition = 999
    }
    
    func start() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            self?.secondsRemaining -= 1
            
            guard let secondsRemaining = self?.secondsRemaining else {
                return
            }
            
            if secondsRemaining < 10 {
                self?.animate()
            }
            
            if secondsRemaining == 0 {
                timer.invalidate()
            }
        }
    }
    
    private func animate() {
        let scale = SKAction.scale(by: 1.3, duration: 0.1)
        let scaleBack = scale.reversed()
        label.run(.sequence([scale, scaleBack]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
