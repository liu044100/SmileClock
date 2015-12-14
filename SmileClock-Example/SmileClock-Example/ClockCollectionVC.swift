//
//  ClockCollectionVC.swift
//  MustangClock
//
//  Created by ryu-ushin on 4/16/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

import UIKit
import SmileClock

let reuseIdentifier = "clockCell"

class ClockCollectionVC: UICollectionViewController, SmileWorldClockModelDelegate {
    
    var worldClockModal: SmileWorldClockModel!
    var dataFilePath: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        worldClockModal = SmileWorldClockModel(theDelegate: self)
        loadDefaultClockData()
        self.collectionView?.collectionViewLayout = ClockLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView?.collectionViewLayout.shouldInvalidateLayoutForBoundsChange(view.bounds)
    }
    
    func loadDefaultClockData() {
        let defaultTimeZones = ["JST","EST","HKT", "PDT", "SGT", "CET", "BST", "CAT", "IST", "KST", "MSK"]
        for timeID in defaultTimeZones {
            if let timeZone = NSTimeZone(abbreviation: timeID) {
                let timeZoneData = SmileTimeZoneData(timeZone: timeZone)
                worldClockModal.addData(timeZoneData)
            }
        }
    }
    
    //MARK: WorldClockModelDelegate
    func timeZonesInModelHaveChanged() {
        self.collectionView?.reloadData()
    }
    
    func secondHasPassed() {
        self.collectionView?.reloadData()
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return worldClockModal.selectedTimeZones.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ClockCollectionCell
        //Modal
        let currentTimeData = worldClockModal.selectedTimeZones[indexPath.row]
        
        // Configure the cell
        cell.clockContainerView.second = currentTimeData.second
        cell.clockContainerView.minute = currentTimeData.minute
        cell.clockContainerView.hour = currentTimeData.hour
        
        //test Customize UI
        if customizedUI_switch.on {
            showCustomizedUI(cell, dayTime: currentTimeData.dayTime)
        } else {
            removeCustomizedUI(cell, dayTime: currentTimeData.dayTime)
        }
        
        cell.clockContainerView.updateClockView()
        cell.countryNameLabel.text = currentTimeData.city
        cell.currentTimeLabel.text = currentTimeData.hourMinuteString
        
        return cell
    }
    
    
    @IBOutlet weak var customizedUI_switch: UISwitch!
    @IBAction func switchCutomizedUI(sender: UISwitch) {
    }
    
    // MARK: CustomizeUI
    func showCustomizedUI(cell: ClockCollectionCell, dayTime: Bool) {
        if dayTime {
            cell.clockContainerView.bgImage = UIImage(named: "bg")
        } else {
            cell.clockContainerView.bgImage = UIImage(named: "bg_night")
        }
        cell.clockContainerView.secHandImage = UIImage(named: "sec_hand")
        cell.clockContainerView.minHandImage = UIImage(named: "min_hand")
        cell.clockContainerView.hourHandImage = UIImage(named: "hour_hand")
        cell.clockContainerView.centerImage = UIImage(named: "center")
    }
    
    func removeCustomizedUI(cell: ClockCollectionCell, dayTime: Bool) {
        cell.clockContainerView.bgImage = nil
        cell.clockContainerView.secHandImage = nil
        cell.clockContainerView.minHandImage = nil
        cell.clockContainerView.hourHandImage = nil
        cell.clockContainerView.centerImage = nil
        
        if dayTime {
            cell.clockContainerView.bgColor = UIColor.groupTableViewBackgroundColor()
            cell.clockContainerView.handColor = UIColor.blackColor()
            cell.clockContainerView.fontColor = UIColor.blackColor()
            cell.clockContainerView.graduationColor = UIColor.blackColor()
        } else {
            cell.clockContainerView.bgColor = UIColor.blackColor()
            cell.clockContainerView.handColor = UIColor.whiteColor()
            cell.clockContainerView.fontColor = UIColor.whiteColor()
            cell.clockContainerView.graduationColor = UIColor.whiteColor()
        }
    }

    // MARK: Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

