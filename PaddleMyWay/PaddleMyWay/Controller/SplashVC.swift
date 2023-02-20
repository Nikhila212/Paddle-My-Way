//
//  SplashVC.swift
//  PaddleMyWay
//
//  Created by Patmavathi on 02/09/2022.
//

import UIKit
import FirebaseAuth

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            self.moveToView()
        }
    }
    
    func moveToView() -> Void {
        
        if Auth.auth().currentUser == nil {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "LoginAsVC") as! LoginAsVC
            self.navigationController!.pushViewController(obj, animated: true)
            
        }else{
            
            let type = UserDefaults.standard.value(forKey: "loginType") as? Int ?? LoginAs.user.rawValue
            if type == LoginAs.user.rawValue {
                
                Constants.loginType = .user
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "DestinationsVC") as! DestinationsVC
                self.navigationController!.pushViewController(obj, animated: true)
                
            }else {
                
                Constants.loginType = .admin
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "ChatListVC") as! ChatListVC
                self.navigationController!.pushViewController(obj, animated: true)
            }
        }
    }
}
