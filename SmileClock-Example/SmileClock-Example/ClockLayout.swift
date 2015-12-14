//
//  ClockLayout.swift
//  MustangClock
//
//  Created by ryu-ushin on 12/14/15.
//  Copyright © 2015 rain. All rights reserved.
//

import UIKit

class ClockLayout: UICollectionViewFlowLayout {
    
    let kItemWidth: CGFloat = 150.0
    
    override init() {
        super.init()
        self.itemSize = CGSizeMake(kItemWidth, kItemWidth + 50.0);
        self.scrollDirection = .Vertical
        self.sectionInset = updateSectionInset()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        self.sectionInset = updateSectionInset()
        return true
    }
    
    func updateSectionInset() -> UIEdgeInsets {
        guard (self.collectionView != nil) else {
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }
        let screenWidth = self.collectionView!.bounds.size.width
        let i: Int = Int(screenWidth/kItemWidth)
        let count: CGFloat = CGFloat(i)
        let space: CGFloat = (screenWidth - count * kItemWidth) / (count+1)
        self.minimumInteritemSpacing = space - 1.0
        return UIEdgeInsetsMake(0, space, 0, space)
    }
}
