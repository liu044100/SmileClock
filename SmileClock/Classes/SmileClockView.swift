//
//  KayacClockView.swift
//  MustangClock
//
//  Created by ryu-ushin on 4/14/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

import UIKit

public enum ClockStyle: Int {
    ///minimal just has circle dial
    case minimal = 0
    ///modal1 has minimal graduation
    case modal1
    ///modal2 has more graduation
    case modal2
    ///modal3 has graduation and number
    case modal3
    static func count() -> Int {
        return ClockStyle.modal3.hashValue
    }
}

public class SmileClockView: UIView {
    
    //MARK: constants
    var bgLineWidth: CGFloat = 0.0
    var circleCenter: CGPoint = CGPointZero
    var circleRadius: CGFloat = 0.0
    var hourHandWidth: CGFloat = 0.0
    var minHandWidth: CGFloat = 0.0
    var secHandWidth: CGFloat = 0.0
    var hourHandLength: CGFloat = 0.0
    var minHandLength: CGFloat = 0.0
    var secHandLength: CGFloat = 0.0
    var graduationLineWidth: CGFloat = 0.0
    var graduationLineLength: CGFloat = 0.0
    var graduationLineWidth_small: CGFloat = 0.0
    var graduationLineLength_small: CGFloat = 0.0
    var graduationFontSize: CGFloat = 0.0
    
    func getDiameter() -> CGFloat {
        let width = CGRectGetWidth(self.bounds)
        let height = CGRectGetHeight(self.bounds)
        return min(width, height)
    }
    
    func getConstantsValue() {
        circleCenter = center
        let diameter = getDiameter()
        bgLineWidth = diameter/35
        hourHandWidth = diameter/30
        minHandWidth = diameter/50
        secHandWidth = diameter/100
        hourHandLength = diameter/3.5
        minHandLength = diameter/2.5
        secHandLength = diameter/2.2
        circleRadius = diameter/2
        graduationLineWidth = diameter/65
        graduationLineLength = diameter/30
        graduationLineWidth_small = diameter/90
        graduationLineLength_small = diameter/60
        graduationFontSize = diameter/10
    }
    
    //MARK: properties
    var second: Int = 0
    var minute: Int = 0
    var hour: Int = 0
    
    var bgImage: UIImage?
    var hourHandImage: UIImage?
    var minHandImage: UIImage?
    var secHandImage: UIImage?
    var centerImage: UIImage?
    
    //MARK: All Layers
    var centerCircleLayer: CAShapeLayer = CAShapeLayer()
    var bgCircleLayer: CAShapeLayer = CAShapeLayer()
    var hourHandLayer: CAShapeLayer = CAShapeLayer()
    var minHandLayer: CAShapeLayer = CAShapeLayer()
    var secHandLayer: CAShapeLayer = CAShapeLayer()
    var graduationLayer_big: CAShapeLayer = CAShapeLayer()
    var graduationLayer_small: CAShapeLayer = CAShapeLayer()
    var fontView: UIView = UIView()
    
    //MARK: Customize UI Key Properties
    var bgColor: UIColor = UIColor.purpleColor()
    var graduationColor: UIColor = UIColor.blackColor()
    var fontColor: UIColor = UIColor.purpleColor()
    var handColor: UIColor = UIColor.redColor()
    var secHandColor: UIColor = UIColor.purpleColor()
    public var clockStyle: ClockStyle = .minimal
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        //set constants
        getConstantsValue()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func drawRect(rect: CGRect) {
        if bgImage != nil {
            return
        }
        bgColor.setFill()
        let bgCirclePath = UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: false)
        bgCirclePath.fill()
    }
    
    func updateClockViewLayers() {
        setUpLayers()
        if bgImage == nil {
            updateClockStyle()
        }

        updateSecondLayer()
    }
    
    //MARK: didSet time properties
    func updateSecondLayer() {
        let keyPath = "transform"
        let duration = 1.0
        let angle_pre: CGFloat = degreeFromMinutes(second)
        let angle: CGFloat = degreeFromMinutes(Int(duration))
        let fromValueCA = CATransform3DRotate(CATransform3DIdentity, angle_pre, 0, 0, 1)
        let toValueCA = CATransform3DRotate(fromValueCA, angle, 0, 0, 1)
        
        let animation = CABasicAnimation(keyPath: keyPath)
        
        #if TARGET_INTERFACE_BUILDER
            secHandLayer.transform = fromValueCA
        #else
            animation.fromValue = NSValue(CATransform3D: fromValueCA)
            animation.toValue = NSValue(CATransform3D: toValueCA)
            animation.duration = duration
            
            secHandLayer.addAnimation(animation, forKey: keyPath)
            secHandLayer.transform = toValueCA
        #endif
    }
    
    func degreeFromMinutes(minutes: Int) -> CGFloat {
        return CGFloat(minutes * 6) * CGFloat(M_PI) / 180.0
    }
    
    func degreeFromHours(hours: Int, minutes: Int) -> CGFloat {
        return CGFloat(hours * 30 + minutes/2) * CGFloat(M_PI) / 180.0
    }
    
    //MARK: configure layer
    func setUpLayers() {
        //set origin bg clear color
        self.backgroundColor = UIColor.clearColor()
        
        //setUp hourHandLayer
        if let image = hourHandImage {
            hourHandLayer.frame = layerFrameFromImage(image)
            hourHandLayer.contents = image.CGImage
            hourHandLayer.anchorPoint = CGPointMake(0.5, 1.0)
            hourHandLayer.position = center
            let angle: CGFloat = degreeFromHours(hour, minutes: minute)
            let transform = CATransform3DRotate(CATransform3DIdentity, angle, 0, 0, 1)
            hourHandLayer.transform = transform
            addShadowToLayer(hourHandLayer)
        } else {
            let hourHandRect = CGRectMake(-hourHandWidth/2, -hourHandLength, hourHandWidth, hourHandLength)
            let hourCornerRadius = CGRectGetWidth(hourHandRect)/2
            let hourPath =  UIBezierPath(roundedRect: hourHandRect, cornerRadius: hourCornerRadius)
            let hourTransform = CGAffineTransformMakeRotation(degreeFromHours(hour, minutes: minute))
            hourPath.applyTransform(hourTransform)
            hourHandLayer.path = hourPath.CGPath
            hourHandLayer.fillColor = handColor.CGColor
            hourHandLayer.position = center
        }
        
        //setUp minHandLayer
        if let image = minHandImage {
            minHandLayer.frame = layerFrameFromImage(image)
            minHandLayer.contents = image.CGImage
            minHandLayer.anchorPoint = CGPointMake(0.5, 1.0)
            minHandLayer.position = center
            let angle: CGFloat = degreeFromMinutes(minute)
            let transform = CATransform3DRotate(CATransform3DIdentity, angle, 0, 0, 1)
            minHandLayer.transform = transform
            addShadowToLayer(minHandLayer)
        } else {
            let minHandRect = CGRectMake(-minHandWidth/2, -minHandLength, minHandWidth, minHandLength)
            let minCornerRadius = CGRectGetWidth(minHandRect)/2
            let minPath =  UIBezierPath(roundedRect: minHandRect, cornerRadius: minCornerRadius)
            let minTransform = CGAffineTransformMakeRotation(degreeFromMinutes(minute))
            minPath.applyTransform(minTransform)
            minHandLayer.path = minPath.CGPath
            minHandLayer.fillColor = handColor.CGColor
            minHandLayer.position = center
        }
        
        //setUp secHandLayer
        if let image = secHandImage {
            secHandLayer.frame = layerFrameFromImage(image)
            secHandLayer.contents = image.CGImage
            secHandLayer.anchorPoint = CGPointMake(0.5, 1.0)
            secHandLayer.position = center
            addShadowToLayer(secHandLayer)
        } else {
            let secPath = UIBezierPath(rect: CGRectMake(-secHandWidth/2, -secHandLength, secHandWidth, secHandLength))
            secHandLayer.path = secPath.CGPath
            secHandLayer.fillColor = secHandColor.CGColor
            secHandLayer.position = center
        }
        
        //setUp bgCircleLayer
        if let image = bgImage {
            bgCircleLayer.frame = layerFrameFromImage(image)
            bgCircleLayer.contents = image.CGImage
        }
        
        //setUp centerCircleLayer
        if let image = centerImage {
            centerCircleLayer.frame = layerFrameFromImage(image)
            centerCircleLayer.contents = image.CGImage
            addShadowToLayer(centerCircleLayer)
        } else {
            let centerCirclePath = UIBezierPath(arcCenter: circleCenter, radius: circleRadius/25, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: false)
            centerCircleLayer.path = centerCirclePath.CGPath
            centerCircleLayer.fillColor = bgColor.CGColor
            
            centerCircleLayer.lineWidth = bgLineWidth/2
            centerCircleLayer.strokeColor = handColor.CGColor
        }
        
        //add layers
        self.layer.addSublayer(bgCircleLayer)
        self.layer.addSublayer(hourHandLayer)
        self.layer.addSublayer(minHandLayer)
        self.layer.addSublayer(secHandLayer)
        self.layer.addSublayer(centerCircleLayer)
    }
    
    func addShadowToLayer(layer: CALayer) {
        layer.shadowOffset = CGSizeMake(0.0, 3.0);
        layer.shadowOpacity = 0.5;
        layer.shadowColor = UIColor.blackColor().CGColor;
        layer.shadowRadius = 3.0;
    }
    
    func layerFrameFromImage(image: UIImage) -> CGRect {
        let width = image.size.width
        let height = image.size.height
        return CGRectMake(circleCenter.x - width/2, circleCenter.y - height/2, width, height)
    }
    
    func clearAllStyle() {
        graduationLayer_big.sublayers = nil
        graduationLayer_small.sublayers = nil
        for subview in fontView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    public func updateClockStyle() {
        clearAllStyle()
        switch clockStyle {
        case .modal1:
            updateClockModal1()
        case .modal2:
            updateClockModal2()
        case .modal3:
            updateClockModal3()
        default:
            break
        }
    }
    
    func updateClockModal1() {
        let radius = graduationRadius()
        for i in 0..<12 {
            addGraduationLine(radius, i: i, bigType: true)
        }
        self.layer.insertSublayer(graduationLayer_big, above: bgCircleLayer)
    }
    
    func updateClockModal2() {
        self.updateClockModal1()
        let radius = graduationRadius()
        for i in 0..<60 {
            addGraduationLine(radius, i: i, bigType: false)
        }
        self.layer.insertSublayer(graduationLayer_small, above: bgCircleLayer)
    }
    
    func updateClockModal3() {
        updateClockModal2()
        let radius = timeTextRadius()
        for i in 0..<12 {
            addTimeText(radius, i: i)
        }
        self.layer.insertSublayer(fontView.layer, below: minHandLayer)
    }
    
    func graduationRadius() -> CGFloat {
        return circleRadius - bgLineWidth * graduationScale
    }
    
    func timeTextRadius() -> CGFloat {
        return circleRadius - bgLineWidth * timeTextScale
    }
    
    //the bigger scale value, the smaller circle radius
    let graduationScale: CGFloat = 1.0
    let timeTextScale: CGFloat = 4.0
    
    func addGraduationLine(radius: CGFloat, i: Int, bigType: Bool) {
        if bigType == false {
            if i % 5 == 0{return}
        }
        let denominator = bigType ? 6.0 : 30.0
        let lineLength = bigType ? graduationLineLength : graduationLineLength_small
        let linewidth = bigType ? graduationLineWidth : graduationLineWidth_small
        let angle = M_PI/denominator * Double(i)
        let radio: CGFloat = CGFloat(sin(angle))
        let radio1: CGFloat = CGFloat(cos(angle))
        let offset_x = circleCenter.x - circleRadius
        let offset_y = circleCenter.y - circleRadius
        let x: CGFloat = radius + radio * radius + bgLineWidth * graduationScale + offset_x
        let y: CGFloat = radius - radio1 * radius +  bgLineWidth * graduationScale + offset_y
        let p1 = CGPointMake(0, 0)
        let p2 = CGPointMake(0, lineLength)
        let path = UIBezierPath()
        path.moveToPoint(p1)
        path.addLineToPoint(p2)
        let layer = CAShapeLayer()
        layer.path = path.CGPath
        layer.position = CGPointMake(x, y)
        layer.strokeColor = graduationColor.CGColor
        layer.lineWidth = linewidth
        layer.lineCap = kCALineCapRound
        layer.transform = CATransform3DMakeRotation(CGFloat(angle), 0, 0, 1)
        if bigType{
            graduationLayer_big.addSublayer(layer)
        } else {
            graduationLayer_small.addSublayer(layer)
        }
    }
    
    func addTimeText(radius: CGFloat, i: Int) {
        let specialText = "12"
        let angle = M_PI/6.0 * Double(i)
        let radio: CGFloat = CGFloat(sin(angle))
        let radio1: CGFloat = CGFloat(cos(angle))
        let offset_x = circleCenter.x - circleRadius
        let offset_y = circleCenter.y - circleRadius
        let x: CGFloat = radius + radio * radius + bgLineWidth * timeTextScale + offset_x
        let y: CGFloat = radius - radio1 * radius +  bgLineWidth * timeTextScale + offset_y
        let label = UILabel()
        label.font = UIFont.boldSystemFontOfSize(graduationFontSize)
        label.textColor = fontColor
        label.text = "\(i)"
        if i == 0 {
            label.text = specialText
        }
        label.sizeToFit()
        let width = CGRectGetWidth(label.bounds)
        let height = CGRectGetHeight(label.bounds)
        if let text = label.text {
            if text.characters.count > 1 && label.text != specialText {
                label.frame = CGRectMake(x - width/2.5, y - height/2.5, width, height)
            }else{
                label.center = CGPointMake(x, y)
            }
        }
        fontView.addSubview(label)
    }
    
}

//MARK: Utility
func DegreesToRadians (value:Double) -> CGFloat {
    return CGFloat(value * M_PI / 180.0)
}

func RadiansToDegrees (value:Double) -> CGFloat {
    return CGFloat(value * 180.0 / M_PI)
}
