//
//  senderTableViewCell.swift
//  PaddleMyWay
//
//  Created by Patmavathi on 04/02/2023.
//

import UIKit

class senderTableViewCell: UITableViewCell {
    
    @IBOutlet var contantView: UIView!
      
    @IBOutlet var messageView: UIView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var timeLbl: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.contantView.backgroundColor = .clear
        
        messageView.layer.cornerRadius = 12
        messageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        messageView.backgroundColor = .systemYellow
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
