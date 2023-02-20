//
//  ChatListTVC.swift
//  PaddleMyWay
//
//  Created by Patmavathi on 07/02/2023.
//

import UIKit

class ChatListTVC: UITableViewCell {

    @IBOutlet var imgLbl: UILabel!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var msgLbl: UILabel!
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
