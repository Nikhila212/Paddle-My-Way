//
//  LoginAsVC.swift
//  PaddleMyWay
//
//  Created by Patmavathi on 07/02/2023.
//

import UIKit

class LoginAsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @IBAction func admin(_ sender: Any) {
        
        Constants.loginType = .admin
        
        let v = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.navigationController!.pushViewController(v, animated: true)
    }
    
    @IBAction func user(_ sender: Any) {
        
        Constants.loginType = .user
        
        let v = self.storyboard?.instantiateViewController(withIdentifier: "InitialVC") as! InitialVC
        self.navigationController!.pushViewController(v, animated: true)
    }
}
