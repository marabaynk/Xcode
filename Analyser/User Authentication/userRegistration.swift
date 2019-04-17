//
//  userRegistration.swift
//  Analyser
//
//  Created by Корюн Марабян on 20/03/2019.
//  Copyright © 2019 Корюн Марабян. All rights reserved.
//


import UIKit
import Firebase


class userRegistration: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userLoginTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userConfirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userLoginTextField.delegate = self
        self.userPasswordTextField.delegate = self
        self.userConfirmPasswordTextField.delegate = self
    }
    
    @IBAction func singUpButton(_ sender: Any) {
        let userEmail = userLoginTextField.text!
        let userPassword = userPasswordTextField.text!
        let userConfirmPassword = userConfirmPasswordTextField.text!
        
        // Check for empty and create user
        if(userEmail.isEmpty || userPassword.isEmpty || userConfirmPassword.isEmpty){
            dispalayAlertMessage(userMessage: "Please, fill in all fields!")
        }; if (userPassword != userConfirmPassword){
            dispalayAlertMessage(userMessage: "Passwords do not match!\n Please, try again!")
        } else {
            Auth.auth().createUser(withEmail: userEmail, password: userPassword) { user, error in
                if error == nil && user != nil {
                    print("User created")
                    
                    // Display alert message
                    let successAlert = UIAlertController(title: "Success", message: "Registration complete!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Continue", style: .default, handler:{
                        action in self.dismiss(animated: true, completion: nil)
                    })
                    successAlert.addAction(okAction)
                    self.present(successAlert, animated: true, completion: nil)
                    // Present view
                    let mainTabController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
                    mainTabController.selectedViewController = mainTabController.viewControllers?[0]
                    self.present(mainTabController, animated: true, completion: nil)
                    
                } else {
                    print("Error: \(error!.localizedDescription)")
                }
                
                //Connection to database
                let ref: DatabaseReference
                ref = Database.database().reference()
                let uid = Auth.auth().currentUser?.uid
                
                //Set userEmail to databse
                ref.child("users").child(uid!).setValue(["userEmail": userEmail])
                
                //Get current date and set user registration date
                let currentDate = Date()
                let timezoneOffset =  TimeZone.current.secondsFromGMT()
                let epochDate = currentDate.timeIntervalSince1970
                let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
                let timeZoneOffsetDate = Date(timeIntervalSince1970: timezoneEpochOffset)
                //print(timeZoneOffsetDate)
                ref.child("users").child(uid!).setValue(["dateOfRegistration": timeZoneOffsetDate])
                
                //Expense
                ref.child("users").child(uid!).child("expense").setValue(["totalExpenseAmount": 0])
                ref.child("users").child(uid!).child("expense").child("Cafe").setValue(["totalAmount" : 0])
                ref.child("users").child(uid!).child("expense").child("Car").setValue(["totalAmount" : 0])
                ref.child("users").child(uid!).child("expense").child("Supermarkets").setValue(["totalAmount" : 0])
                ref.child("users").child(uid!).child("expense").child("Entertainment").setValue(["totalAmount" : 0])
                ref.child("users").child(uid!).child("expense").child("Other").setValue(["totalAmount" : 0])
                
                //Income
                ref.child("users").child(uid!).child("income").setValue(["totalIncomeAmount" : 0])
            }
        }
    }
    
    func dispalayAlertMessage(userMessage:String){
        let errorAlert = UIAlertController(title: "Oops", message: userMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
        errorAlert.addAction(okAction)
        present(errorAlert, animated: true, completion: nil)
    }
 
    @IBAction func backToLoginPage(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    //Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userLoginTextField.resignFirstResponder()
        userPasswordTextField.resignFirstResponder()
        userConfirmPasswordTextField.resignFirstResponder()
        return(true)
    }
}
