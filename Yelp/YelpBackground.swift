//
//  YelpSwitchBackground.swift
//  Yelp
//
//  Created by Davis Wamola on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import C4
import UIKit

class YelpBackground: SwitchBackground {
    
    var sunColor = Color(red: 256, green: 245, blue: 253, alpha: 1.0)
    var moonColor = Color(red: 19, green: 44, blue: 72, alpha: 1.0)
    var stars = [Image]()

    override func setup() {
        self.backgroundColor = sunColor
        self.placeSmallStars()
    }
    
    override func on() {
        self.backgroundColor = moonColor
    }
    
    override func off() {
        self.backgroundColor = sunColor
    }
    
    func placeSmallStars() {
        let centers = [Point(21.0,5.75), Point(6.5,10.25), Point(20.5,20.75), Point(17.0,26.5), Point(18.0,13.0), Point(17.0,7.75)]
        for point in centers {
            let smallStar = Image("StarSmall")!
            smallStar.center = point
            stars.append(smallStar)
            self.add(smallStar)
        }
    }
}
