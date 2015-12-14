//
//  WorldClockModal.swift
//  MustangClock
//
//  Created by yuchen liu on 4/22/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

import UIKit

@objc public protocol SmileWorldClockModelDelegate {
    func timeZonesInModelHaveChanged()
    func secondHasPassed()
}

public class SmileWorldClockModel: NSObject, NSCoding {
    //MARK: ==
    public override func isEqual(object: AnyObject?) -> Bool {
        if let rhs = object as? SmileWorldClockModel {
            return selectedTimeZones == rhs.selectedTimeZones
        }
        return false
    }
    
    //MARK: Property
    var timer: NSTimer?
    public var selectedTimeZones = [SmileTimeZoneData]()
    var delegate: SmileWorldClockModelDelegate!
    
    //MARK: Init
    public override init() {
        
    }
    
    public convenience init(theDelegate: SmileWorldClockModelDelegate) {
        self.init()
        self.delegate = theDelegate
    }
    
    //MARK: NSCoding
    required public init?(coder aDecoder: NSCoder) {
        if let data = aDecoder.decodeObjectForKey("selectedTimeZones") as? [SmileTimeZoneData] {
            selectedTimeZones = data
        }
        super.init()
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(selectedTimeZones, forKey: "selectedTimeZones")
    }
    
    //MARK: Timer
    public func startTimerWithDelegate(theDelegate: SmileWorldClockModelDelegate) {
        delegate = theDelegate
        if selectedTimeZones.count > 0 {
            startTimer()
        }
    }
    
    func startTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "fireTimer", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    }
    
    func fireTimer() {
        if selectedTimeZones.count > 0 {
            for timeZoneData in selectedTimeZones {
                timeZoneData.updateTime()
            }
            delegate.secondHasPassed()
        }
    }
    
    //MARK: Add New TimeZoneData
    public func addData(timeZoneData: SmileTimeZoneData) {
        selectedTimeZones.append(timeZoneData)
        timeZoneData.updateTime()
        if selectedTimeZones.count == 1 {
            startTimer()
        }
    }
}
