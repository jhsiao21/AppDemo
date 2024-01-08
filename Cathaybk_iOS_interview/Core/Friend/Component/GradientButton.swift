//
//  GradientButton.swift
//  Cathaybk_iOS_interview
//
//  Created by LoganMacMini on 2024/1/5.
//

import UIKit

class GradientButton: UIButton {
    
    let gradientLayer = CAGradientLayer()
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 6
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addShadow()
    }
    
    
    
    override func draw(_ rect: CGRect) {
        // Set the gradient frame
        gradientLayer.frame = rect
        
        // Set the colors
        gradientLayer.colors = [UIColor.frogGreen.cgColor, UIColor.booger.cgColor]
        // Gradient is linear from left to right
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        // Add gradient layer into the button
        layer.insertSublayer(gradientLayer, at: 0)
        
        // Round the button corners
        layer.cornerRadius = rect.height / 2
        
        clipsToBounds = true
    }
    
    func addShadow() {
        shadowLayer = CAShapeLayer()
        
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        shadowLayer.fillColor = UIColor.appleGreen40.cgColor
        
        shadowLayer.shadowColor = UIColor.appleGreen40.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 1
        
        layer.insertSublayer(shadowLayer, at: 0)
    }
}
