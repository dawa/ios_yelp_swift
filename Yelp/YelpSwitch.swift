//
//  YelpSwitch.swift
//  Yelp
//
//  Created by Davis Wamola on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class YelpSwitch: Switch {

    override func awakeFromNib() {
        self.thumb = YelpThumb()
        self.background = YelpBackground()
        replaceViews()
        setup()
        toggle()
    }
}
