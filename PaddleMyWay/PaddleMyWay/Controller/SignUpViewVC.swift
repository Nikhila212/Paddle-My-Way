//
//  SignUpVC.swift
//  PaddleMyWay
//
//  Created by Patmavathi on 02/09/2022.
//

import UIKit
import FirebaseDatabase
import FirebaseCore
import FirebaseAuth


class SignUpVC: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signup(_ sender: Any) {
        
        self.view.endEditing(true)
        if nameTF.isEmpty {
            
            self.showAlert(msg: "Please enter name")
            
        }else if emailTF.isEmpty {
            
            self.showAlert(msg: "Please enter email")

        }else if !self.validateEmail(enteredEmail: emailTF.text!) {
            
            self.showAlert(msg: "Please enter valid email")
            
        }else if passwordTF.isEmpty {

            self.showAlert(msg: "Please enter password")

        }else if !self.isValidPassword(){
            
            self.showAlert(msg: "Password should contain minimum 1 number ,1 symbol ,1 alphabet lower case,1 alphabet Upper case, length miniumum 8")
        }else{
            
            self.showSpinner(onView: self.view)
            Auth.auth().createUser(withEmail: emailTF.text!, password: passwordTF.text!) { authResult, error in
              
                if error != nil {
                    
                    self.removeSpinner()
                    self.showAlert(msg: error?.localizedDescription ?? "Something went wrong while saving user")
                }else{
                    
                    let user = authResult?.user.createProfileChangeRequest()
                    user?.displayName = self.nameTF.text!
                    user?.commitChanges(completion: { err in
                        if err != nil {
                            
                            self.removeSpinner()
                            self.showAlert(msg: err?.localizedDescription ?? "Something went wrong while saving user")
                        }else{
                            
                            self.loginUser()
                        }
                    })
                }
            }
        }
    }
    
    func loginUser() -> Void {
        
        Auth.auth().signIn(withEmail: emailTF.text!, password: passwordTF.text!) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            print(strongSelf)
          
            self?.removeSpinner()
            
            let obj = self?.storyboard?.instantiateViewController(withIdentifier: "DestinationsVC") as! DestinationsVC
            self?.navigationController!.pushViewController(obj, animated: true)
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
}
