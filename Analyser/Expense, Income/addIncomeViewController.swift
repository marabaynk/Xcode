//
//  addExpenseViewController.swift
//  Analyser
//
//  Created by Корюн Марабян on 03/04/2019.
//  Copyright © 2019 Корюн Марабян. All rights reserved.
//

import UIKit
import Firebase

class addIncomeViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.incomeAmountTextField.delegate = self
        self.incomeCommentTextField.delegate = self
    }
    
    @IBOutlet weak var incomeAmountTextField: UITextField!
    @IBOutlet weak var incomeCommentTextField: UITextField!
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        let incomeText = Float(incomeAmountTextField.text!)
        if incomeText == nil{
            dispalayAlertMessage(userMessage: "Please, fill in the field!")
        } else {
            //Checking for a user
            let ref: DatabaseReference
            ref = Database.database().reference()
            let uid = Auth.auth().currentUser?.uid
            
            //Edditing totalIncomeAmount
            ref.child("users").child(uid!).child("income").childByAutoId().setValue(["amount": incomeText!, "timestamp": [".sv":"timestamp"] ])
            
            //Editing totalExpenseAmount
            ref.child("users").child(uid!).child("income").child("totalIncomeAmount").observeSingleEvent(of: .value) { (snapshot) in
                let getTotalIncome = snapshot.value as! Float
                let update = ["users/\(uid!)/income/totalIncomeAmount": incomeText! + getTotalIncome]
                ref.updateChildValues(update)
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    func dispalayAlertMessage(userMessage:String){
        let errorAlert = UIAlertController(title: "Oops", message: userMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
        errorAlert.addAction(okAction)
        present(errorAlert, animated: true, completion: nil)
    }

    
    //Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func backToMain(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
