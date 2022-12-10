//
//  Score.swift
//  Olimpbet
//
//  Created by mac on 08.11.2022.
//

import SpriteKit

class Score: SKSpriteNode {
    
    private lazy var nameLabel = createPlayerLabel(text: "You", fontSize: 24)
    
    var myScore: Int = 0 {
        didSet {
            scoreLabel.text = String(describing: myScore)
            animate(label: scoreLabel)
        }
    }
    private lazy var scoreLabel = createScoreLabel()

    private var connectedPlayersScore: [String : (Int, SKLabelNode)] = [:]
    
    var playersScore: [String: Int] {
        var playersScore = [String: Int]()
        connectedPlayersScore.forEach { key, value in
            playersScore.updateValue(value.0, forKey: key)
        }
        playersScore.updateValue(myScore, forKey: "You")
        return playersScore
    }
    
    init() {
        let texture = SKTexture(imageNamed: "score-bg")
        let size = CGSize(width: 100, height: 100)
        super.init(texture: texture, color: .clear, size: size)
        
        zPosition = 999
        
        addChild(nameLabel)
        nameLabel.position = CGPoint(x: /* -size.width / 2 + 32 */ 0,
                                       y: size.height / 2 - 40)

        addChild(scoreLabel)
        scoreLabel.position = CGPoint(x: nameLabel.position.x,
                                      y: -size.height / 2 + 32)

    }
    
    func addConnectedPlayers(_ connectedPlayers: [String]?) {
        guard let connectedPlayers = connectedPlayers else {
            return
        }
        
        if connectedPlayers.count == 1 {
            size.width = 250
            nameLabel.position.x = -size.width / 4
            scoreLabel.position.x = nameLabel.position.x
        } else if connectedPlayers.count == 2 {
            size.width = 400
            nameLabel.position.x = -size.width / 3
            scoreLabel.position.x = nameLabel.position.x
        }

        connectedPlayers.compactMap { $0 }
            .enumerated()
            .forEach { index, playerName in
                
                var positionX: CGFloat {
                    if connectedPlayers.count > 1 {
                        return (index == 0) ? 0 : size.width / 3
                    } else {
                        return size.width / 4
                    }
                }
                
                let playerLabel = createPlayerLabel(text: playerName, fontSize: 18)
                playerLabel.position = CGPoint(x: positionX,
                                               y: self.nameLabel.position.y)
                addChild(playerLabel)
                
                let scoreLabel = createScoreLabel()
                scoreLabel.position = CGPoint(x: positionX,
                                              y: self.scoreLabel.position.y)
                addChild(scoreLabel)
                
                connectedPlayersScore.updateValue((0, scoreLabel), forKey: playerName)

            }
    }
    
    func updateScore(_ score: Int, for playerName: String) {
        guard let scoreLabel = connectedPlayersScore[playerName]?.1 else {
            return
        }
        scoreLabel.text = String(describing: score)
        animate(label: scoreLabel)
        
        connectedPlayersScore.updateValue((score, scoreLabel), forKey: playerName)
    }
    
    private func createPlayerLabel(text: String, fontSize: CGFloat) -> SKLabelNode {
        let label = SKLabelNode()
        label.text = text
        label.fontName = "Copperplate Bold"
        label.fontSize = fontSize
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.fontColor = .white
        return label
    }
    
    private func createScoreLabel() -> SKLabelNode {
        let label = SKLabelNode()
        label.text = "0"
//        label.fontName = "Arial Rounded MT Bold"
        label.fontName = "Copperplate Bold"
        label.fontSize = 34
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.fontColor = UIColor(red: 248/255, green: 108/255, blue: 71/255, alpha: 1.0)
        return label
    }
    
    private func animate(label: SKLabelNode?) {
        let scale = SKAction.scale(by: 1.3, duration: 0.1)
        let scaleReversed = scale.reversed()
        
        label?.run(.sequence([scale, scaleReversed]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
