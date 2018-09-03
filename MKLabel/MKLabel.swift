//
//  MKLabel.swift
//  MKLabel
//
//  Created by Sargis on 9/3/18.
//  Copyright © 2018 Sargis. All rights reserved.
//

import UIKit

@IBDesignable
class MKLabel: UIView {
    
    // MARK: - Properties
    
    var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        return gradientLayer
    }()
    
    var textAttributes: [NSAttributedStringKey: AnyObject] {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        return [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize),
            NSAttributedStringKey.paragraphStyle: style
        ]
    }
    
    // MARK: - IBInspectable Properties
    
    @IBInspectable var textColor: UIColor = UIColor.orange {
        didSet(value) {
            set(textColor: value, animColor: animationColor)
        }
    }
    
    @IBInspectable var animationColor: UIColor = UIColor.yellow {
        didSet(value) {
            set(textColor: textColor, animColor: value)
        }
    }
    
    @IBInspectable var text: String! {
        didSet {
            updateText()
        }
    }
    
    @IBInspectable var duration: Float = 5.0
    @IBInspectable var fontSize: CGFloat = 17.0
    
    @IBInspectable var animationWidth: Float = -0.15
    
    // MARK: - Overriden Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = CGRect(x: -bounds.origin.x, y: bounds.origin.y, width: 2*bounds.size.width, height: bounds.height)
        updateText()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [animationWidth, animationWidth / 2, 0]
        gradientAnimation.toValue = [1, 1.5, 2]
        gradientAnimation.duration = CFTimeInterval(duration)
        gradientAnimation.repeatCount = Float.infinity
        
        setupGradient()
        
        layer.addSublayer(gradientLayer)
        gradientLayer.add(gradientAnimation, forKey: nil)
    }
    
    // MARK: - Private Methods
    
    fileprivate func setupGradient() {
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        set(textColor: textColor, animColor: animationColor)
        
        let locations:[NSNumber] = [
            0.5
        ]
        gradientLayer.locations = locations
    }
    
    fileprivate func updateText() {
        setNeedsDisplay()
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        let te: NSString = text as NSString
        te.draw(in: bounds, withAttributes: textAttributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let mask = CALayer()
        mask.backgroundColor = UIColor.clear.cgColor
        mask.frame = bounds.offsetBy(dx: 0, dy: 0)
        mask.contents = image?.cgImage
        
        gradientLayer.mask = mask
    }
    
    private func set(textColor: UIColor, animColor: UIColor) {
        let colors = [
            textColor.cgColor,
            animColor.cgColor,
            textColor.cgColor
        ]
        gradientLayer.colors = colors
    }

}
