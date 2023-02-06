//
//  SplashViewController.swift
//  PaddleMyWay
//
//

import UIKit
import FirebaseAuth

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            self.moveToView()
        }
    }
    
    func moveToView() -> Void {
        
        if Auth.auth().currentUser == nil {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
            self.navigationController!.pushViewController(obj, animated: true)
            
        }else{
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController!.pushViewController(obj, animated: true)
        }
    }
    
}

