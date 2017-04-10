//
//  YelpThumb.swift
//  Yelp
//
//  Created by Davis Wamola on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//
import C4
import UIKit

class YelpThumb: SwitchThumb {
    var yelpLogo = Image("YelpLogo")
    var outerGlow = Image("OuterGlow")
    var sunColor = Color(red: 255, green: 238, blue: 90, alpha: 1.0)
    var moonColor = Color(red: 251, green: 246, blue: 217, alpha: 1.0)
    
    override func setup() {
        lineWidth = 0
        fillColor = sunColor
        self.add(yelpLogo)
        
        outerGlow?.constrainsProportions = true
        outerGlow?.center = self.bounds.center
        self.add(outerGlow)
    }

    override func on() {
        fillColor = moonColor
        yelpLogo?.opacity = 0.66
        yelpLogo?.transform.rotate(-.pi/4)
        outerGlow?.opacity = 1.0
    }

    override func off() {
        fillColor = sunColor
        yelpLogo?.opacity = 0.0
        yelpLogo?.transform.rotate(.pi/4)
        outerGlow?.opacity = 0.0
    }
}
