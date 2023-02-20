//
//  ChatListVC.swift
//  PaddleMyWay
//
//  Created by Patmavathi on 07/02/2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ChatListVC: UIViewController {
    
    @IBOutlet var dataTV: UITableView!
    
    var allChat: [Chat1] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationItem.title = "Home"
        
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        navigationItem.rightBarButtonItems = [logout]
        
        self.getAllChat()
    }
    
    @objc func logout() -> Void {
        
        do {
            
            try Auth.auth().signOut()
        } catch {}
        
        UserDefaults.standard.removeObject(forKey: "loginType")
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "LoginAsVC") as! LoginAsVC
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
    //MARK: Get Chats
    func getAllChat() -> Void {
        
        FirebaseTables.Chats.observe(.value) { snapshot in
            
            var all: [Chat1] = []
            for child in snapshot.children {
                
                let snap = child as! DataSnapshot
                
                var model = Chat1()
                model.id = snap.key
               
                var date = ""
                var chats: [Chat] = []
                for child1 in snap.children {
                    
                    let snap1 = child1 as! DataSnapshot
                    date = snap1.key
                    
                    for child2 in snap1.children {
                        
                        let snap2 = child2 as! DataSnapshot
                        let dic1 = snap2.value as? NSDictionary ?? NSDictionary()
                        
                        var chat = Chat()
                        
                        chat.id = snap.key
                        chat.date = dic1["date"] as? String ?? ""
                        chat.message = dic1["message"] as? String ?? ""
                        chat.name = dic1["name"] as? String ?? ""
                        chat.sender = dic1["sender"] as? Int ?? 0
                        
                        chats.append(chat)
                    }
                }
                
                let last = chats[chats.count - 1]
                model.name = last.name ?? ""
                model.date = last.date ?? ""
                model.message = last.message ?? ""
                model.time = last.date ?? ""
                model.date = date
                
                all.append(model)
            }
            
            self.allChat = all
            self.dataTV.reloadData()
        }
    }
}


extension ChatListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("ChatListTVC", owner: self)?.first as! ChatListTVC
        
        let chat = allChat[indexPath.row]
        
        let name = chat.name ?? "A"
        let firstChar = Array(name)[0]
        
        cell.imgLbl.layer.cornerRadius = cell.imgLbl.frame.size.height / 2
        cell.imgLbl.layer.borderColor = UIColor.lightGray.cgColor
        cell.imgLbl.layer.borderWidth = 1
        
        cell.imgLbl.text = firstChar.uppercased()
        cell.nameLbl.text = chat.name ?? ""
        cell.msgLbl.text = chat.message ?? ""
        cell.dateLbl.text = chat.date ?? ""
        
        
        let date = chat.date
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
            
            if string.lowercased() == "today" {
                
                cell.dateLbl.text = chat.time ?? ""
            }else {
                
                cell.dateLbl.text = string
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 94
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chat = allChat[indexPath.row]
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        
        obj.userID = chat.id ?? ""
        obj.userName = chat.name ?? ""
        
        self.navigationController!.pushViewController(obj, animated: true)
    }
}
