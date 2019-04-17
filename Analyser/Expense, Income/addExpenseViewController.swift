//
//  addIncomeViewController.swift
//  Analyser
//
//  Created by Корюн Марабян on 03/04/2019.
//  Copyright © 2019 Корюн Марабян. All rights reserved.
//

import UIKit
import Firebase



class addExpenseViewController: UIViewController, UITextFieldDelegate {
    
    let dataSource = ["Car","Supermarkets","Cafe","Entertainment", "Other"]
    var pickerViewText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedGroupTextField.delegate = self
        self.expenseTextField.delegate = self
        createGroupPicker()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let a : Double = 1554823147991
        let newdate = NSDate(timeIntervalSince1970: a / 1000)
        print(newdate)
    }
    
    @IBOutlet weak var expenseTextField: UITextField!
    @IBOutlet weak var selectedGroupTextField: UITextField!
    
    @IBAction func addExpense(_ sender: Any) {
        
        let expenseText = Float(expenseTextField.text!)
        if expenseText == nil && selectedGroupTextField.text == nil{
            dispalayAlertMessage(userMessage: "Please, fill in all fields!")
        } else {
            //Checking for a user
            let ref: DatabaseReference
            ref = Database.database().reference()
            let uid = Auth.auth().currentUser?.uid
        
            //Edditing data choosed with pickerView
            
            ref.child("users").child(uid!).child("expense").child(self.pickerViewText!).childByAutoId().setValue(["amount": expenseText!, "timestamp": [".sv":"timestamp"] ])
            
            ref.child("users").child(uid!).child("expense").child(self.pickerViewText!).child("totalAmount").observeSingleEvent(of: .value){ (snapshot) in
                let getTotalAmount = snapshot.value as! Float
                let update = ["users/\(uid!)/expense/\(self.pickerViewText!)/totalAmount": expenseText! + getTotalAmount]
                ref.updateChildValues(update)
            }
            
            //Editing totalExpenseAmount
            ref.child("users").child(uid!).child("expense").child("totalExpenseAmount").observeSingleEvent(of: .value) { (snapshot) in
                let getTotalExpense = snapshot.value as! Float
                let update = ["users/\(uid!)/expense/totalExpenseAmount": expenseText! + getTotalExpense]
                ref.updateChildValues(update)
            }
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func backToMain(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Picker view
    func createGroupPicker() {
        let groupPicker = UIPickerView()
        groupPicker.delegate = self
        
        selectedGroupTextField.inputView = groupPicker
    }
    
    func dispalayAlertMessage(userMessage:String){
        let errorAlert = UIAlertController(title: "Oops", message: userMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
        errorAlert.addAction(okAction)
        present(errorAlert, animated: true, completion: nil)
    }

}

extension addExpenseViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    //PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerViewText = dataSource[row]
        selectedGroupTextField.text = pickerViewText
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        label.textAlignment = .center
        label.text = dataSource[row]
        label.font = UIFont(name: "Menlo-Regular", size: 30)
        return label
    }
}
