//
//  Camera.swift
//  Olimpbet
//
//  Created by mac on 08.11.2022.
//

import SpriteKit

class Camera: SKCameraNode {
        
    let moveLeftButton = LongPressButton(texture: SKTexture(imageNamed: "left-button"))
    
    let moveRightButton = LongPressButton(texture: SKTexture(imageNamed: "right-button"))
        
    let jumpButton = TouchButton(texture: SKTexture(imageNamed: "jump-button"))
    
    let ballButton = TouchButton(texture: SKTexture(imageNamed: "pick-up-button"))
    
    func setupWith(sceneSize size: CGSize, invertedControls: Bool) {
        if invertedControls {
            moveRightButton.position = CGPoint(x: size.width / 2 - 90,
                                               y: -size.height / 2 + 80)
            
            moveLeftButton.position = CGPoint(x: moveRightButton.position.x - 90,
                                              y: -size.height / 2 + 80)
            
            
            
            ballButton.position = CGPoint(x: -size.width / 2 + 90,
                                          y: moveLeftButton.position.y)
            
            
            jumpButton.position = CGPoint(x: ballButton.position.x + 90,
                                          y: ballButton.position.y)
        } else {
            moveLeftButton.position = CGPoint(x: -size.width / 2 + 90,
                                              y: -size.height / 2 + 80)
            
            
            moveRightButton.position = CGPoint(x: moveLeftButton.position.x + 90,
                                               y: moveLeftButton.position.y)
            
            
            ballButton.position = CGPoint(x: size.width / 2 - 90,
                                          y: moveLeftButton.position.y)
            
            
            jumpButton.position = CGPoint(x: ballButton.position.x - 90,
                                          y: ballButton.position.y)
        }
        
        addChild(jumpButton)
        addChild(moveLeftButton)
        addChild(moveRightButton)
        addChild(ballButton)
    }
    
}
