//
//  KayacClockContainerView.swift
//  MustangClock
//
//  Created by ryu-ushin on 4/14/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

import UIKit

@IBDesignable public class SmileClockContainerView: UIView {

    @IBInspectable public var bgColor: UIColor = UIColor.blackColor()
    @IBInspectable public var graduationColor: UIColor = UIColor.whiteColor()
    @IBInspectable public var fontColor: UIColor = UIColor.whiteColor()
    @IBInspectable public var handColor: UIColor = UIColor.whiteColor()
    @IBInspectable public var secHandColor: UIColor = UIColor.yellowColor()
    @IBInspectable public var clockStyleNum: Int = 3
    @IBInspectable public var hour: Int = 9
    @IBInspectable public var minute: Int = 30
    @IBInspectable public var second: Int = 7
    
    public var bgImage: UIImage?
    public var hourHandImage: UIImage?
    public var minHandImage: UIImage?
    public var secHandImage: UIImage?
    public var centerImage: UIImage?
    
    public var clockView: SmileClockView!
    
    #if TARGET_INTERFACE_BUILDER
    override public func willMoveToSuperview(newSuperview: UIView?) {
    addClockView()
    }
    #else
    override public func awakeFromNib() {
        super.awakeFromNib()
        addClockView()
    }
    #endif

    public func updateClockView() {
        clockView.removeFromSuperview()
        addClockView()
    }
    
    private func addClockView() {
        self.backgroundColor = UIColor.clearColor()
        clockView = SmileClockView(frame: self.bounds)
        
        clockView.clockStyle = safeSetClockStyle(clockStyleNum)
        clockView.bgColor = bgColor
        clockView.graduationColor = graduationColor
        clockView.handColor = handColor
        clockView.secHandColor = secHandColor
        clockView.fontColor = fontColor
        
        clockView.hour = hour
        clockView.minute = minute
        clockView.second = second
        
        clockView.bgImage = bgImage
        clockView.centerImage = centerImage
        clockView.hourHandImage = hourHandImage
        clockView.minHandImage = minHandImage
        clockView.secHandImage = secHandImage
        
        clockView.updateClockViewLayers()

        self.addSubview(clockView)
    }
    
    func safeSetClockStyle(styleNum: Int) -> ClockStyle {
        if clockStyleNum > ClockStyle.count() || clockStyleNum < 0 {
           clockStyleNum = 0
        } else {
            clockStyleNum = styleNum
        }
        return ClockStyle(rawValue: clockStyleNum)!
    }
}
