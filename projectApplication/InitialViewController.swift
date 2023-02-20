//
//  InitialViewController.swift
//  PaddleMyWay
//
//  Created by Patmavathi on 12/09/2022.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func signIn(_ sender: Any) {
        
        let v = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.navigationController!.pushViewController(v, animated: true)
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        let v = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController!.pushViewController(v, animated: true)
    }
}
