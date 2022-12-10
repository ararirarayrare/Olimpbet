//
//  ScoresStackView.swift
//  Olimpbet
//
//  Created by mac on 11.11.2022.
//

import UIKit

class ScoresStackView: UIStackView {
    
    private(set) var shapeLayer: CAShapeLayer?
    
    init(playersScore: [String : Int]) {
        super.init(frame: .zero)
        
        axis = .vertical
        spacing = 1
        distribution = .fillEqually
        backgroundColor = .black
        
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        playersScore.sorted(by: { $0.value > $1.value }).forEach {
            let view = createScoreView(name: $0.key, score: $0.value)
            addArrangedSubview(view)
            view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard shapeLayer == nil, bounds.height > 0 else {
            return
        }
        
        addShape()
    }
    
    private func createScoreView(name: String, score: Int) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Copperplate Bold", size: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true

        let nameString = NSAttributedString(string: "  " + name + "  -  ")
        
        let scoreString = NSAttributedString(
            string: String(describing: score) + " points",
            attributes: [
                .font : UIFont(name: "Copperplate Bold", size: 20) ?? .boldSystemFont(ofSize: 18)
            ]
        )
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(nameString)
        attributedString.append(scoreString)
        
        label.attributedText = attributedString
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
    
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: bounds,
                                       cornerRadius: layer.cornerRadius).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = spacing
        layer.addSublayer(shapeLayer)
        
        self.shapeLayer = shapeLayer
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
