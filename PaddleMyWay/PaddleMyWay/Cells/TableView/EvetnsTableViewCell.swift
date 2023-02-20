//
//  EvetnsTableViewCell.swift
//  PaddleMyWay
//
//  Created by Patmavathi on 12/10/2022.
//

import UIKit

class EvetnsTableViewCell: UITableViewCell {

    @IBOutlet var contantView: UIView!
    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet var detailsView: UIView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var eventLbl: UILabel!
    
    @IBOutlet var dateView: UIView!
    @IBOutlet var dateLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
