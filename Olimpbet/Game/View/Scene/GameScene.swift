//
//  GameScene.swift
//  Olimpbet
//
//  Created by mac on 04.11.2022.
//

import SpriteKit
import Combine

final class GameView: SKView {
    
    var multiplayerManager: MultiplayerManager?
    
    private(set) var gameScene: GameScene?
    
    private let settings: Settings
    
    init(frame: CGRect, settings: Settings) {
        self.settings = settings
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadScene() {
        gameScene = GameScene()
        gameScene?.settings = settings
        gameScene?.multiplayerManager = multiplayerManager
        gameScene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        gameScene?.scaleMode = .resizeFill
        
//        showsPhysics = true
        isMultipleTouchEnabled = true
        
        presentScene(gameScene)
    }
    
}

final class GameScene: SKScene {
    
    private var cancellables = Set<AnyCancellable>()
    
    fileprivate var settings: Settings!
    
    fileprivate var multiplayerManager: MultiplayerManager? {
        didSet {
            multiplayerManager?.delegate = self
            let playerNames = multiplayerManager?.connectedPeers.map { $0.displayName }
            scoreNode.addConnectedPlayers(playerNames)
        }
    }
    
    private lazy var background = Background(size: self.size)
    
    let player = Player()
    private let ball = Ball()
    private let hoop = Hoop()
    private let cameraNode = Camera()
    private let scoreNode = Score()
    
    private let timer = TimerNode(duration: 100)

    private lazy var effectController = EffectController(scene: self)
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        setupPhysics()
        
        addChild(background)
        
        if let multiplayerManager = multiplayerManager {
            let spacing = 24.0
            let width = scoreNode.size.width + timer.size.width + spacing
            
            scoreNode.position = CGPoint(x: (scoreNode.size.width - width) / 2,
                                         y: (size.height - scoreNode.size.height) / 2)
            addChild(scoreNode)
            
            timer.position = CGPoint(x: (width - timer.size.width) / 2,
                                     y: scoreNode.position.y)
            addChild(timer)
            timer.start()
            
            timer.$secondsRemaining
                .receive(on: DispatchQueue.main)
                .sink { [weak self] secondsRemaining in
                    if secondsRemaining == 0, let playersScore = self?.scoreNode.playersScore {
                        
                        let sorted = playersScore.sorted { $0.value > $1.value }
                        var sortedScores = [String : Int]()
                        sorted.forEach { sortedScores.updateValue($0.value, forKey: $0.key) }
                        
                        
                        multiplayerManager.gameOver(playersScore: sortedScores)
//                        multiplayerManager.stopAdvertising()
                        
                        self?.player.stop()
                        self?.isPaused = true
                    }
                }
                .store(in: &cancellables)
        } else {
            scoreNode.position.y = (size.height - scoreNode.size.height) / 2
            addChild(scoreNode)
        }
        
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.setupWith(sceneSize: size, invertedControls: settings.invertedControls)
        cameraNode.moveLeftButton.addAction { [weak self] in
            self?.player.moveBy(dx: -4 * (self?.effectController.speedMultiplier ?? 1))
        } endHandler: { [weak self] in
            self?.player.stop()
        }
        cameraNode.moveRightButton.addAction { [weak self] in
            self?.player.moveBy(dx: 4 * (self?.effectController.speedMultiplier ?? 1))
        } endHandler: { [weak self] in
            self?.player.stop()
        }
        cameraNode.jumpButton.addAction { [weak self] in
            self?.player.jump()
        }
        cameraNode.ballButton.addAction { [weak self] in
            
            guard let player = self?.player,
                  let ball = self?.ball else {
                return
            }
            
            if player.hasBall {
                player.throwBall()
                self?.cameraNode.ballButton.texture = SKTexture(imageNamed: "pick-up-button")
            } else {
                player.pickUp(ball: ball)
                self?.cameraNode.ballButton.texture = SKTexture(imageNamed: "throw-button")
            }
            
        }
        
        player.position = CGPoint(x: -40, y: -30)
        addChild(player)
        
        ball.position = CGPoint(x: 80, y: 0)
        addChild(ball)
        
        hoop.position = CGPoint(x: (size.width - hoop.size.width) / 2 - 24, y: 14)
        addChild(hoop)
    }
    
    override func update(_ currentTime: TimeInterval) {
        player.updateSpeed()
        
        if !player.hasBall {
            let dx = ball.position.x - player.position.x
            let dy = ball.position.y - player.position.y
            
            let distanceFromPlayerToBall = sqrt(pow(dx, 2) + pow(dy, 2))
            
            cameraNode.ballButton.isEnabled = distanceFromPlayerToBall < 100
        } else {
            cameraNode.ballButton.isEnabled = true
        }
        
        let containsX = ((hoop.ringPosition.x - 36)...(hoop.ringPosition.x + 36)).contains(ball.position.x)
        let ballLowerThanRing = ball.position.y < hoop.ringPosition.y
        let ballWasAboveTheRing = ball.previousPosition.y > hoop.ringPosition.y
        
        ball.previousPosition = ball.position
        
        if containsX, ballLowerThanRing, ballWasAboveTheRing {
            scoreNode.myScore += (player.threwFrom3Pointer ? 3 : 2) * effectController.scoreMultiplier
            
            if let name = multiplayerManager?.id.displayName {
                multiplayerManager?.send(.score(scoreNode.myScore, name))
            }
        }

        if let effectNode = effectController.effectNode, player.contains(effectNode.position) {
            effectController.apply(effectNode.type)
        }
        
    }

    private func setupPhysics() {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity.dy = -9
        
        let frame = CGRect(x: -size.width / 2,
                           y: -size.height / 2,
                           width: size.width,
                           height: size.height + 140)
                
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.isDynamic = false
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        var ball: SKNode? {
            if bodyA.categoryBitMask == .ballBitMask {
                return bodyA.node
            } else if bodyB.categoryBitMask == .ballBitMask {
                return bodyB.node
            } else {
                return nil
            }
        }
        
        var player: SKNode? {
            if bodyA.categoryBitMask == .playerBitMask {
                return bodyA.node
            } else if bodyB.categoryBitMask == .playerBitMask {
                return bodyB.node
            } else {
                return nil
            }
        }
        
        if let player = player as? Player, let ball = ball as? Ball {
            
            let vector = CGVector(
                dx: player.forceMultiplier * player.speed * (ball.position.x - player.position.x),
                dy: player.forceMultiplier * player.speed * (ball.position.y - player.position.y)
            )

            ball.physicsBody?.applyImpulse(vector)
        }
        
        let contactedPillar = (bodyA.categoryBitMask == .pillarBitMask && bodyB.categoryBitMask == .ballBitMask) || (bodyA.categoryBitMask == .ballBitMask && bodyB.categoryBitMask == .playerBitMask)
        
        if contactedPillar,
           self.ball.position.x > hoop.position.x,
           self.ball.position.y > hoop.ringPosition.y {
            
            self.ball.physicsBody = nil
            self.ball.position = CGPoint(x: 0, y: 100)
            self.ball.setupPhysics()
        }
    }
}

extension GameScene: MultiplayerGameDataDelegate {
    func didReceive(_ gameData: GameData) {
        switch gameData {
        case .score(let score, let name):
            scoreNode.updateScore(score, for: name)
        }
    }
}

//class ScoreSorter {
//    
//    func sort(_ playerScores: [String : Int]) -> [String : Int] {
//        var dictionary = [String : Int]()
//        
//        let sortedScores = playerScores.values.sorted()
//        
//        sortedScores.forEach { score in
//            guard let name = playerScores[score] else {
//                return
//            }
//        }
//        
//        return dictionary
//    }
//    
//}
