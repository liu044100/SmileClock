//
//  ClockCollectionCell.swift
//  MustangClock
//
//  Created by ryu-ushin on 4/20/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

import UIKit
import SmileClock

class ClockCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var clockContainerView: SmileClockContainerView!
}
