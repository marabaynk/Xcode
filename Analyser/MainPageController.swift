//
//  MainPage.swift
//  Analyser
//
//  Created by Корюн Марабян on 27/03/2019.
//  Copyright © 2019 Корюн Марабян. All rights reserved.
//

import UIKit
import Firebase



class MainPageController: UIViewController {
    
    @IBOutlet weak var totalExpenseAmountTextField: UILabel!
    @IBOutlet weak var totalIncomeAmountTextField: UILabel!

    
    //Checking for a user
    let ref: DatabaseReference = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Show total Expense Amount
        ref.child("users").child(uid!).child("expense").child("totalExpenseAmount").observeSingleEvent(of: .value) { (snapshot) in
            let getExpenseAmount = snapshot.value as! Float
            self.totalExpenseAmountTextField.text =  String(Int(getExpenseAmount))
        }
        
        //Show total Income Amount
        ref.child("users").child(uid!).child("income").child("totalIncomeAmount").observeSingleEvent(of: .value) { (snapshot) in
            let getIncomeAmount = snapshot.value as! Float
            self.totalIncomeAmountTextField.text =  String(Int(getIncomeAmount))
        }
        
    }
    //Log out user
    @IBAction func LogOutButton(_ sender: Any) {
        try! Auth.auth().signOut()
    }
    
    //Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
