//
//  Bonus.swift
//  Olimpbet
//
//  Created by mac on 08.11.2022.
//

import SpriteKit
import Combine

enum EffectType: CaseIterable {
    case scoreDoubler, speed, lowGravity, wind, reverse
    
    var texture: SKTexture {
        switch self {
        case .scoreDoubler:
            return SKTexture(imageNamed: "score-doubler-effect")
        case .speed:
            return SKTexture(imageNamed: "speed-effect")
        case .lowGravity:
            return SKTexture(imageNamed: "low-gravity-effect")
        case .wind:
            return SKTexture(imageNamed: "wind-effect")
        case .reverse:
            return SKTexture(imageNamed: "reverse-effect")
        }
    }
    
    var appliedTexture: SKTexture {
        switch self {
        case .scoreDoubler:
            return SKTexture(imageNamed: "score-doubler")
        case .speed:
            return SKTexture(imageNamed: "speed")
        case .lowGravity:
            return SKTexture(imageNamed: "low-gravity")
        case .wind:
            return SKTexture(imageNamed: "wind")
        case .reverse:
            return SKTexture(imageNamed: "reverse")
        }
    }
    
    var duration: Double {
        switch self {
        case .scoreDoubler, .speed:
            return .random(in: 2...4)
        case .lowGravity:
            return .random(in: 2...5)
        case .wind:
            return .random(in: 4...8)
        case .reverse:
            return .random(in: 4...6)
        }
    }
}

class EffectController {
    
    var gravity: CGVector {
        switch appliedEffect {
        case .wind:
            return CGVector(dx: Bool.random() ? -1.5 : 1.5, dy: -7.5)
        case .lowGravity:
            return CGVector(dx: 0, dy: -6.5)
        default:
            return CGVector(dx: 0, dy: -9)
        }
    }
    
    var scoreMultiplier: Int {
        return (appliedEffect == .scoreDoubler) ? 2 : 1
    }
    
    var speedMultiplier: CGFloat {
        switch appliedEffect {
        case .speed:
            return 2.0
        case .reverse:
            return -1.0
        default:
            return 1.0
        }
    }
    
    private(set) var effectNode: EffectNode?
    
    private var spawnWorkItem: DispatchWorkItem?
    
    private var cleanWorkItem: DispatchWorkItem?
    
    enum State {
        case clear
        case spawned
        case applied
    }
    
    @Published
    private var state: State = .clear
    
    private var appliedEffect: EffectType? {
        didSet {
            scene?.physicsWorld.gravity = gravity
        }
    }
    
    private(set) weak var scene: GameScene?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(scene: GameScene?) {
        self.scene = scene
        
        $state.receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                
                switch state {
                case .clear:
                    guard let spawnWorkItem = self?.setupSpawnWorkItem() else {
                        return
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: 9...14),
                                                  execute: spawnWorkItem)
                case .spawned:
                    guard let cleanWorkItem = self?.setupCleanWorkItem() else {
                        return
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: 4...8),
                                                  execute: cleanWorkItem)
                case .applied:
                    self?.effectNode?.removeFromParent()
                    self?.effectNode = nil
                }
            }
            .store(in: &cancellables)
        
    }
    
    func apply(_ type: EffectType) {
        guard let scene = scene else {
            return
        }
        
        appliedEffect = type

        let position = CGPoint(x: 0, y: scene.player.size.height / 2 + 28)
        let appliedEffectNode = EffectNode(type: type,
                                           position: position)
        appliedEffectNode.isApplied = true
        
        scene.player.addChild(appliedEffectNode)
        
        cleanWorkItem?.cancel()
        
        appliedEffectNode.run(.fadeOut(withDuration: type.duration)) { [weak self] in
            let workItem = self?.setupCleanWorkItem()
            workItem?.perform()
        }
        
        state = .applied
    }
    
    private func setupCleanWorkItem() -> DispatchWorkItem {
        let workItem = DispatchWorkItem { [weak self] in
            self?.effectNode?.remove(animated: true)
            self?.effectNode = nil
            self?.appliedEffect = nil
            self?.state = .clear
        }
        self.cleanWorkItem = workItem
        return workItem
    }
    
    private func setupSpawnWorkItem() -> DispatchWorkItem {
        let workItem = DispatchWorkItem { [weak self] in
            guard let scene = self?.scene,
                  let type = EffectType.allCases.randomElement() else {
                return
            }
            
            let xRange: ClosedRange<CGFloat> = (-scene.size.width / 2 + 80)...(scene.size.width / 2 - 220)
            let yRange: ClosedRange<CGFloat> = -20...50
            
            
            
            let position = CGPoint(x: CGFloat.random(in: xRange),
                                   y: CGFloat.random(in: yRange))
            
            let effectNode = EffectNode(type: type, position: position)
            
            scene.addChild(effectNode)
            
            self?.effectNode = effectNode
            self?.state = .spawned
        }
        
        self.spawnWorkItem = workItem
        return workItem
    }
}

class EffectNode: SKSpriteNode {
    
    let type: EffectType
    
    var isApplied: Bool = false {
        didSet {
            texture = type.appliedTexture
        }
    }
    
    init(type: EffectType, position: CGPoint) {
        self.type = type
        let size = CGSize(width: 60, height: 60)
        super.init(texture: type.texture, color: .clear, size: size)
        
        self.position = position
        zPosition = 5
        name = "effect"
    }
    
    func remove(animated: Bool) {
        if animated {
            run(.fadeOut(withDuration: 0.3)) { [weak self] in
                self?.removeFromParent()
            }
        } else {
            removeFromParent()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
