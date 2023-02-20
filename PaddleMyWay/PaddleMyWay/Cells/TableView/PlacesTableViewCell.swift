//
//  PlacesTableViewCell.swift
//  PaddleMyWay
//
//  Created by Patmavathi on 26/09/2022.
//

import UIKit

class PlacesTableViewCell: UITableViewCell {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    
    @IBOutlet var infoBtn: UIButton!
    @IBOutlet var favBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
