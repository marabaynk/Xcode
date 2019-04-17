//
//  loginViewController.swift
//  Analyser
//
//  Created by Корюн Марабян on 20/03/2019.
//  Copyright © 2019 Корюн Марабян. All rights reserved.
//

import UIKit
import Firebase

class  loginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userEmailTextField.delegate = self
        self.userPasswordTextField.delegate = self
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func signInButton(_ sender: Any) {
        
        let userEmail = userEmailTextField.text!
        let userPassword = userPasswordTextField.text!
        
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { user, error in
            if error == nil && user != nil {
                let mainTabController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
                mainTabController.selectedViewController = mainTabController.viewControllers?[0]
                self.present(mainTabController, animated: true, completion: nil)
            } else {
                print("Error loggin in: \(error!.localizedDescription)")
                self.alertMessage(myMessage: "Wrong email or password!")
            }
        }
        
        // Check for empty
        if(userEmail.isEmpty || userPassword.isEmpty){
            alertMessage(myMessage: "Please, fill in all fields!")
        }
        
    }
    
    func alertMessage(myMessage: String) {
        let notSuccessAlert = UIAlertController(title: "Oops", message: myMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
        notSuccessAlert.addAction(okAction)
        present(notSuccessAlert, animated: true, completion: nil)
    }
    
    
    //Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userEmailTextField.resignFirstResponder()
        userPasswordTextField.resignFirstResponder()
        return(true)
    }
}
