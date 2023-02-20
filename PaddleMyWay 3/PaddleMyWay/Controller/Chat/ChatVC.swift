//
//  ChatVC.swift
//  PaddleMyWay
//
//  Created by Patmavathi on 04/02/2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Toast


class ChatVC: UIViewController {
    
    @IBOutlet weak var dataTV: UITableView!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet var messageView: UIView!
    @IBOutlet var messageTF: UITextField!
    @IBOutlet var messageTFView: UIView!
    
    var userID = ""
    var userName = ""
    
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
        
        if userID == "" {
            
            userID = Auth.auth().currentUser?.uid ?? ""
            userName = Auth.auth().currentUser?.displayName ?? ""
        }
        
        
        self.getAllChat()
    }
    
    func setDesign() -> Void {
        
        messageTF.placeholder = "Type your message"
    }
    
    //MARK: Get Chats
    func getAllChat() -> Void {
        
        let id = userID
        FirebaseTables.Chats.child(id).observe(.value) { snapshot in
            
            var all: [ChatModel] = []
            for child in snapshot.children {
                
                let snap = child as! DataSnapshot
                
                var model = ChatModel()
                model.date = snap.key
                
                var chats: [Chat] = []
                for child1 in snap.children {
                    
                    let snap1 = child1 as! DataSnapshot
                    let dic1 = snap1.value as? NSDictionary ?? NSDictionary()
                    
                    var chat = Chat()
                    
                    chat.id = snap.key
                    chat.date = dic1["date"] as? String ?? ""
                    chat.message = dic1["message"] as? String ?? ""
                    chat.name = dic1["name"] as? String ?? ""
                    chat.sender = dic1["sender"] as? Int ?? 0
                    
                    chats.append(chat)
                }
                
                model.chats = chats
                all.append(model)
            }
            
            self.allChat = all
            self.dataTV.reloadData()
        }
    }
    
    @IBAction func sendBtnClicked(_ sender: Any) {
        
        if messageTF.text == "" {
            
            self.view.makeToast("Please enter text")
            return
        }
        
        //Send as customer
        if Constants.loginType == .user {
            
            self.sendMessage(sender: 1)
            
        }else {
            
            self.sendMessage(sender: 0)
        }
    }
    
    func sendMessage(sender: Int) -> Void {
        
        let time = DateFormatter()
        time.dateFormat = "hh:mm a"
        let time_str = time.string(from: Date())
        
        let id = userID
        let params = ["name": userName,
                      "message": messageTF.text!,
                      "sender": sender,
                      "date": time_str] as [String : Any]
        
        self.showSpinner(onView: self.view)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let date_str = formatter.string(from: Date())
        
        FirebaseTables.Chats.child(id).child(date_str).childByAutoId().setValue(params){
            (error:Error?, ref:DatabaseReference) in
            if error == nil {
                
                self.messageTF.text = ""
                self.getAllChat()
                self.removeSpinner()
                
                self.view.makeToast("Message sent successfully")
            } else {
                
                self.view.makeToast("Message sending failed")
            }
        }
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
            let ss = dateFormatter.string(from: d)
            cell.dateBtn.setTitle(ss, for: .normal)
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
        
        let type = UserDefaults.standard.value(forKey: "loginType") as? Int ?? 1
        if chat?.sender == type {
            
            let cell = Bundle.main.loadNibNamed("senderTableViewCell", owner: self)?.first as! senderTableViewCell
            
            cell.messageLabel.text = chat?.message ?? ""
            cell.timeLbl.text = chat?.date ?? ""
            return cell
        }else{
            
            let cell = Bundle.main.loadNibNamed("receiverTableViewCell", owner: self)?.first as! receiverTableViewCell
            
            cell.messageLabel.text = chat?.message ?? ""
            cell.timeLbl.text = chat?.date ?? ""
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}
