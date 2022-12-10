//
//  LoaderViewController.swift
//  Olimpbet
//
//  Created by mac on 15.11.2022.
//

import UIKit

class LoaderViewController: BaseVC, CAAnimationDelegate {
    
    private lazy var ball: UIImageView = {
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width: 72, height: 72)
        imageView.center = view.center
        imageView.frame.origin.y -= 32
        imageView.frame.origin.x -= 10
        imageView.image = UIImage(named: "ball")
        return imageView
    }()
    
    private let completion: () -> Void
    
    init(_ completion: @escaping () -> Void) {
        self.completion = completion
        super.init(coordinator: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgImageView = UIImageView(frame: view.bounds)
        bgImageView.image = UIImage(named: "loader")
        bgImageView.contentMode = .scaleToFill
        
        view.addSubview(bgImageView)
        
        bgImageView.addSubview(ball)
        
        let duration = Double.random(in: 3...6)
        let angle = duration * .pi
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = angle
        rotation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        rotation.duration = duration
        rotation.isCumulative = true
        rotation.delegate = self
        ball.layer.add(rotation, forKey: "rotationAnimation")
        ball.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        completion()
    }
    
}
