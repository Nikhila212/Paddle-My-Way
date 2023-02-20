//
//  SignInVC.swift
//  PaddleMyWay
//
//  Created by Patmavathi on 02/09/2022.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignInVC: UIViewController {
    
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signin(_ sender: Any) {
        
        self.view.endEditing(true)
        if emailTF.isEmpty {

            self.showAlert(msg: "Please enter email")

        }else if !self.validateEmail(enteredEmail: emailTF.text!) {
            
            self.showAlert(msg: "Please enter valid email")
            
        }else if passwordTF.isEmpty {

            self.showAlert(msg: "Please enter password")

        }else if !self.isValidPassword(){
            
            self.showAlert(msg: "Password should contain minimum 1 number ,1 symbol ,1 alphabet lower case,1 alphabet Upper case, length miniumum 8")
        }else{

            self.showSpinner(onView: self.view)
            
            Auth.auth().signIn(withEmail: emailTF.text!, password: passwordTF.text!) { [weak self] authResult, error in
              guard let strongSelf = self else { return }
                print(strongSelf)
              
                self?.removeSpinner()
                if error != nil {
                    
                    self?.showAlert(msg: error?.localizedDescription ?? "Error")
                }else{
                    
                    self?.moveToView()
                }
            }
        }
    }
    
    func moveToView() -> Void {
        
        if Constants.loginType == .admin {
            
            if emailTF.text == "admin@admin.com" {
                
                UserDefaults.standard.set(Constants.loginType.rawValue, forKey: "loginType")
                UserDefaults.standard.synchronize()
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "ChatListVC") as! ChatListVC
                self.navigationController!.pushViewController(obj, animated: true)
            }else {
                
                do {
                    
                    try Auth.auth().signOut()
                } catch {}
                
                self.view.makeToast("Invalid user")
            }
        }else {
            
            UserDefaults.standard.set(Constants.loginType.rawValue, forKey: "loginType")
            UserDefaults.standard.synchronize()
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DestinationsVC") as! DestinationsVC
            self.navigationController!.pushViewController(obj, animated: true)
        }
    }
    
    
    func validateEmail(enteredEmail:String) -> Bool {

        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    func isValidPassword() -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 8 characters total
        let password = passwordTF.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)
    }
    
    @IBAction func forgotBtnTapped(_ sender: Any) {
        
        let v = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController!.pushViewController(v, animated: true)
    }
}

