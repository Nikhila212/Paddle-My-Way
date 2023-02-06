//
//  ChatVC.swift
//  PaddleMyWay
//
//  Created by Patmavathi on 04/02/2023.
//

import UIKit

class ChatVC: UIViewController {
    
    @IBOutlet weak var dataTV: UITableView!
    
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    
    @IBOutlet var messageView: UIView!
    @IBOutlet var messageTF: UITextField!
    @IBOutlet var messageTFView: UIView!
    
    var userID = ""
    var allChat: [ChatModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "Chat"
        dataTV.backgroundColor = .clear
        setDesign()
    }
    
    func setDesign() -> Void {
        
        messageTF.placeholder = "Type your message"
    }
}


extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return allChat.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = Bundle.main.loadNibNamed("HeaderTVC", owner: self, options: nil)?.first as! HeaderTVC
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let date = allChat[section].date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM dd"
        
        let f = DateFormatter()
        f.dateFormat = "dd-MM-yyyy"
        let d = f.date(from: date ?? "")!
        
        let relativeDateFormatter = DateFormatter()
        relativeDateFormatter.timeStyle = .none
        relativeDateFormatter.dateStyle = .medium
        relativeDateFormatter.locale = Locale(identifier: "en_GB")
        relativeDateFormatter.doesRelativeDateFormatting = true
        
        
        let string = relativeDateFormatter.string(from: d)
        if let _ = string.rangeOfCharacter(from: .decimalDigits) {
            print(dateFormatter.string(from: d))
        } else {
            cell.dateBtn.setTitle(string, for: .normal)
        }
        
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let chats = allChat[section].chats ?? []
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let chats = allChat[indexPath.section].chats
        let chat = chats?[indexPath.row]
        
        let type = UserDefaults.standard.value(forKey: "loginType") as? Int ?? 0
        if chat?.sender == type {
            
            let cell = Bundle.main.loadNibNamed("senderTableViewCell", owner: self)?.first as! senderTableViewCell
            
            //cell.chat = chat
            return cell
        }else{
            
            let cell = Bundle.main.loadNibNamed("receiverTableViewCell", owner: self)?.first as! receiverTableViewCell
            
            //cell.chat = chat
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}
