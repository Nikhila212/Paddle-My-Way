//
//  ForgotPasswordViewController.swift
//  PaddleMyWay
//
//  Created by Patmavathi on 02/09/2022.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    @IBOutlet var emailTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func backBtnClicked(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendBtnClicked(_ sender: Any) {
        
        if emailTF.text == "" {
            
            self.showAlert(msg: "Please enter email")
            
        }else if !self.validateEmail(enteredEmail: emailTF.text!) {
            
            self.showAlert(msg: "Please enter valid email")
            
        }else {
            
            self.sendOTP()
        }
    }
    
    func sendOTP() -> Void {
        
        self.showSpinner(onView: self.view)
        Auth.auth().sendPasswordReset(withEmail: emailTF.text!) { error in
            
            self.removeSpinner()
            if let error = error {
                
                self.showAlert(msg: error.localizedDescription )
                
            }else{
                
                self.showAlert(msg: "OTP sent to \(self.emailTF.text!)" )
            }
        }
    }
    
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
}
