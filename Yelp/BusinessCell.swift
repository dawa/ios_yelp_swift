//
//  BusinessCell.swift
//  Yelp
//
//  Created by Davis Wamola on 4/5/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var business: Business! {
        didSet {
            nameLabel.text = business.name
            if let thumbURL = business.imageURL {
                thumbImageView.setImageWith(thumbURL)
            }
            if let ratingImageUrl = business.ratingImageURL {
                ratingImageView.setImageWith(ratingImageUrl)
            }
            addressLabel.text = business.address
            categoriesLabel.text = business.categories
            reviewsCountLabel.text = "\(String(describing: business.reviewCount!)) Reviews"
            distanceLabel.text = business.distance
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImageView.layer.cornerRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
