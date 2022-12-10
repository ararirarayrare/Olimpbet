//
//  SKButton.swift
//  Olimpbet
//
//  Created by mac on 07.11.2022.
//

import SpriteKit

class SKButton: SKSpriteNode {
    
    var isEnabled: Bool = true {
        didSet {
            isUserInteractionEnabled = isEnabled
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
    
    init(texture: SKTexture) {
        super.init(texture: texture, color: .clear, size: CGSize(width: 64, height: 64))
        
        isUserInteractionEnabled = isEnabled
        zPosition = 999
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        alpha = 0.7
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        alpha = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

final class TouchButton: SKButton {
    
    private var action: (() -> Void)?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        action?()
    }
    
    func addAction(_ action: @escaping () -> Void) {
        self.action = action
    }
}

final class LongPressButton: SKButton {
    
    private var beginHandler: (() -> Void)?
    private var endHandler: (() -> Void)?
    
    private var displayLink: CADisplayLink?
    
    func addAction(_ beginHandler: @escaping () -> Void, endHandler: (() -> Void)? = nil) {
        self.beginHandler = beginHandler
        self.endHandler = endHandler
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        displayLink = CADisplayLink(target: self, selector: #selector(listener))
        displayLink?.add(to: .current, forMode: .common)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        displayLink?.invalidate()
        endHandler?()
    }
    
    @objc
    private func listener() {
        beginHandler?()
    }
}
