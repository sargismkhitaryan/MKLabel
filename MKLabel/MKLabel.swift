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
    
    enum AnimationDirection: Int {
        case leftToRight
        case rightToLeft
    }
    
    // MARK: - Properties
    
    var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        return gradientLayer
    }()
    
    var textAttributes: [NSAttributedString.Key: AnyObject] {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        let font = UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        
        return [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.paragraphStyle: style
        ]
    }
    
    // MARK: - IBInspectable Properties
    
    @IBInspectable var textColor: UIColor = UIColor.orange {
        didSet(value) {
            set(textColor: value, animColor: animationColor)
        }
    }
    
    var animationDirection: AnimationDirection = .leftToRight
    
    @IBInspectable var directionAdapter: Int {
        get {
            return animationDirection.rawValue
        }
        set(value) {
            animationDirection = AnimationDirection(rawValue: value) ?? .leftToRight
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
    
    @IBInspectable var fontName: String = "Helvetica Neue" {
        didSet(value) {
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
        
        let lValue = [animationWidth, animationWidth / 2, 0]
        let rValue = [1, 1.5, 2]
        switch animationDirection {
        case .leftToRight:
            gradientAnimation.fromValue = lValue
            gradientAnimation.toValue = rValue
        case .rightToLeft:
            gradientAnimation.fromValue = rValue
            gradientAnimation.toValue = lValue
        }
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
