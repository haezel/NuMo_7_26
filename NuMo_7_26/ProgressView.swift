//
//  ProgressView.swift
//  CustomProgressBar
//
//  Created by Sztanyi Szabolcs on 16/10/14.
//  Copyright (c) 2014 Sztanyi Szabolcs. All rights reserved.
//

import UIKit

@IBDesignable class ProgressView: UIView {

    private let progressLayer: CAShapeLayer = CAShapeLayer()
    
    
    private var progressLabel: UILabel
    private var progressLabel2: UILabel
    
    var percentComplete = 0.0
    var nutrientNameLabel = "Nutrient"
    
    var cellSize : CGFloat?
    
    required init(coder aDecoder: NSCoder) {
        progressLabel = UILabel()
        progressLabel2 = UILabel()
        super.init(coder: aDecoder)
        createProgressLayer()

        createLabel()
    }
    
    override init(frame: CGRect) {
        progressLabel = UILabel()
        progressLabel2 = UILabel()
        super.init(frame: frame)
        createProgressLayer()
 
        createLabel()
    }
    
    //------Start: expirementation with circles-------//
    

    
    
    
    
//    
//    @IBInspectable var scale: CGFloat = 0.90 { didSet { setNeedsDisplay() } }
//    @IBInspectable var lineWidth: CGFloat = 6.0 { didSet { setNeedsDisplay() } }
//    @IBInspectable var color: UIColor = UIColor.whiteColor() { didSet { setNeedsDisplay() } }
//    
//    var faceCenter: CGPoint {
//        return convertPoint(center, fromView: superview)
//    }
//    
//    var faceRadius: CGFloat {
//        
//        println("in faceradius...")
//        
//        let screenSize: CGRect = UIScreen.mainScreen().bounds
//        let screenWidth = screenSize.width
//        
//        println("screen width is  \(screenWidth)")
//        return min(bounds.size.width, bounds.size.height) / 2 * scale
//        //return screenWidth/4-20
//    }
//    
//    override func drawRect(rect: CGRect) {
//        
//        println("Face radius for \(nutrientNameLabel) is \(faceRadius))")
//        
//        //Drawing Face
//        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
//        facePath.lineWidth = lineWidth
//        color.set()
//        facePath.stroke()
//        
//    }
    
    var lineWidth: CGFloat = 4.5
    //var color: UIColor = UIColor.colorFromCode(0x3485BF)
    var scale: CGFloat = 0.9
    
    override func drawRect(rect: CGRect) {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width

        
        //var path = UIBezierPath(ovalInRect: rect)
        //SSSS
        //var path = UIBezierPath(arcCenter: convertPoint(center, fromView: superview), radius: screenWidth/4-20, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        var path = UIBezierPath(arcCenter: convertPoint(center, fromView: superview), radius: screenWidth/8-10, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
  
        path.lineWidth = lineWidth
        UIColor.colorFromCode(0x3485BF).setStroke()
        path.stroke()
    }
    
    
    
    
    
    
    //------END: expirementation with circles-------//
    
    
    
    func createLabel() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        
        println("orig thingy")
        println(CGRectGetWidth(frame))
        
        //SSSS
        //progressLabel = UILabel(frame: CGRectMake(0.0, 0.0, screenWidth/2, 60.0))
        progressLabel = UILabel(frame: CGRectMake(0.0, 0.0, screenWidth/4, 60.0))
        progressLabel.textColor = .whiteColor()
        progressLabel.textAlignment = .Center
        progressLabel.text = ""
        progressLabel.font = UIFont(name: "AvenirNextCondensed-Medium", size: 12.0)
        progressLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(progressLabel)
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: progressLabel, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: progressLabel, attribute: .CenterY, multiplier: 1.0, constant: 6.0))
        
        //SSSS
        //progressLabel2 = UILabel(frame: CGRectMake(0.0, 0.0, screenWidth/2, 40.0))
        progressLabel2 = UILabel(frame: CGRectMake(0.0, 0.0, screenWidth/4, 40.0))
        progressLabel2.textColor = UIColor.colorFromCode(0xffba00)
        progressLabel2.textAlignment = .Center
        //what to say while loading
        
        progressLabel2.hidden = true
        progressLabel2.font = UIFont(name: "AvenirNextCondensed-Bold", size: 16.0)
        progressLabel2.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(progressLabel2)
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: progressLabel2, attribute: .CenterX, multiplier: 1.0, constant: -4.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: progressLabel2, attribute: .CenterY, multiplier: 1.0, constant: -8.0))

        
    }
    
    //----------Methods To Make the Specific Nutrient Cell Details-----------//
    
    func setThePercentComplete(percent : Double)
    {
        self.percentComplete = percent
        //animateProgressView()
    }
    
    func setTheNutrientTitle(title : String)
    {
        self.nutrientNameLabel = title
        //animateProgressView()
    }
        
            
    private func createProgressLayer() {
        
        let startAngle = CGFloat(M_PI_2)

        let endAngle = CGFloat(M_PI * 2 + M_PI_2)
        
        var centerPoint = CGPointMake(CGRectGetWidth(frame)/2 , CGRectGetHeight(frame)/2)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width

    
        
      //SSSS
        //centerPoint = CGPointMake(screenWidth/4 , screenWidth/4)
        centerPoint = CGPointMake(screenWidth/8 , screenWidth/8)
        
        
        var gradientMaskLayer = gradientMask()
        
    //SSSS
        //progressLayer.path = UIBezierPath(arcCenter:centerPoint, radius: screenWidth/4-20, startAngle:startAngle, endAngle:endAngle, clockwise: true).CGPath
        progressLayer.path = UIBezierPath(arcCenter:centerPoint, radius: screenWidth/8-10, startAngle:startAngle, endAngle:endAngle, clockwise: true).CGPath
        
        
        progressLayer.backgroundColor = UIColor.clearColor().CGColor
        progressLayer.fillColor = nil
        
        progressLayer.strokeColor = UIColor.blackColor().CGColor
        progressLayer.lineWidth = 5.0
        progressLayer.strokeStart = 0.0
        progressLayer.strokeEnd = 0.0
        
        gradientMaskLayer.mask = progressLayer
        layer.addSublayer(gradientMaskLayer)
       
    }
    
    private func gradientMask() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds

        gradientLayer.locations = [0.0, 1.0]
        
        //let colorTop: AnyObject = UIColor(red: 255.0/255.0, green: 213.0/255.0, blue: 63.0/255.0, alpha: 1.0).CGColor
        
        let colorTop: AnyObject = UIColor.colorFromCode(0x35a7fe).CGColor
        let colorBottom: AnyObject = UIColor.colorFromCode(0x0994ff).CGColor
        
        //let colorBottom: AnyObject = UIColor(red: 255.0/255.0, green: 198.0/255.0, blue: 5.0/255.0, alpha: 1.0).CGColor
        let arrayOfColors: [AnyObject] = [colorTop, colorBottom]
        gradientLayer.colors = arrayOfColors
        
        return gradientLayer
    }
    
    func hideProgressView() {
        progressLayer.strokeEnd = 0.0
        progressLayer.removeAllAnimations()
        progressLabel.text = "Load content"
    }
    
    func animateProgressView() {
        
        var percentToShow = percentComplete * 100
        progressLabel2.hidden = false
        progressLabel2.text = String(format: "%.0f%%", percentToShow)
        
        //progressLabel2.hidden = true
        progressLabel.text = nutrientNameLabel
        progressLayer.strokeEnd = 0.0
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = CGFloat(0.0)
        animation.toValue = CGFloat(percentComplete)
        animation.duration = 0.7 //***was 1.0
        animation.delegate = self
        animation.removedOnCompletion = false
        animation.additive = true
        animation.fillMode = kCAFillModeForwards
        progressLayer.addAnimation(animation, forKey: "strokeEnd")
        
      
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        progressLabel.text = nutrientNameLabel
        //progressLabel2.text = "\(percentComplete) percent"
        
//        var percentToShow = percentComplete * 100
//        progressLabel2.hidden = false
//        progressLabel2.text = String(format: "%.0f%%", percentToShow)

    }
    
    
}
