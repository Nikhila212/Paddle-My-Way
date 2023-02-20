//
//  ReviewsTableViewCell.swift
//  PaddleMyWay
//
//  Created by Patmavathi on 12/10/2022.
//

import UIKit
import HCSStarRatingView


class ReviewsTableViewCell: UITableViewCell {

    @IBOutlet var contantView: UIView!
    @IBOutlet var ratingView: HCSStarRatingView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
