//
//  InitialVC.swift
//  PaddleMyWay
//
//  Created by Patmavathi on 12/09/2022.
//

import UIKit

class InitialVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func signIn(_ sender: Any) {
        
        let v = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.navigationController!.pushViewController(v, animated: true)
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        let v = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController!.pushViewController(v, animated: true)
    }
}
