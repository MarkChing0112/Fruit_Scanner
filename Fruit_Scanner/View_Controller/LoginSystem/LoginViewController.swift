//
//  LoginViewController.swift
//  SeniorVolunteer
//

//

import UIKit
import FirebaseAuth
import SwiftUI

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var ForgotpasswordBtn: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        self.passwordTextField.isSecureTextEntry = true
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                
                let firstPageNavigationViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.firstPageNavigationViewController) as? FirstPageNavigationViewController
                
                self.view.window?.rootViewController = firstPageNavigationViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    @IBAction func ForgotPasswordBtnOnTap(_ sender: Any) {
        
    }
}
