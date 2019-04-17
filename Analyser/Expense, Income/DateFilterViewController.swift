//
//  DateFilterViewController.swift
//  Analyser
//
//  Created by Корюн Марабян on 09/04/2019.
//  Copyright © 2019 Корюн Марабян. All rights reserved.
//

import UIKit
import Firebase

class DateFilterViewController: UIViewController {

    @IBOutlet weak var carExpenseAmount: UILabel!
    @IBOutlet weak var cafeExpenseAmount: UILabel!
    @IBOutlet weak var intertainmentExpenseAmount: UILabel!
    @IBOutlet weak var supermarketsExpenseAmount: UILabel!
    @IBOutlet weak var otherExpenseAmount: UILabel!
    
    @IBOutlet weak var expenseResultLabel: UILabel!
    @IBOutlet weak var incomeResultLabel: UILabel!
    
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var toDateTextField: UITextField!
    
    private var datePickerFrom, datePickerTo: UIDatePicker?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        let ref: DatabaseReference
        ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        //Printing cafeExpenseAmount
        ref.child("users").child(uid!).child("expense").child("Cafe").child("totalAmount").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as! Float
            self.cafeExpenseAmount.text = String(value)
        }
        //Printing carExpenseAmount
        ref.child("users").child(uid!).child("expense").child("Car").child("totalAmount").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as! Float
            self.carExpenseAmount.text = String(value)
        }
        //Printing intertainmentExpenseAmount
        ref.child("users").child(uid!).child("expense").child("Entertainment").child("totalAmount").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as! Float
            self.intertainmentExpenseAmount.text = String(value)
        }
        //Printing supermarketsExpenseAmount
        ref.child("users").child(uid!).child("expense").child("Supermarkets").child("totalAmount").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as! Float
            self.supermarketsExpenseAmount.text = String(value)
        }
        //Printing otherExpenseAmount
        ref.child("users").child(uid!).child("expense").child("Other").child("totalAmount").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as! Float
            self.otherExpenseAmount.text = String(value)
        }
        
//        let mil: Date = Date(timeIntervalSince1970: (1554940800000)/1000)
//        print("from\(mil)")
//
//        let mil2: Date = Date(timeIntervalSince1970: (1555275600000)/1000)
//        print("to\(mil2)")
    }
    
    override func viewDidLoad() {

        //Connect ot database
        let ref: DatabaseReference
        ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        //Edditing data choosed with pickerView
        datePickerFrom = UIDatePicker()
        datePickerFrom?.timeZone = TimeZone.current
        datePickerTo = UIDatePicker()
        datePickerTo?.timeZone = TimeZone.current
        
        datePickerTo?.maximumDate = Date()
        datePickerFrom?.maximumDate = Date()
        
        ref.child("users").child(uid!).child("dateOfRegistration").observe(.value) { (snapshot) in
            let value = snapshot.value as? Double
            let dateOfRegistration : Date = Date(timeIntervalSince1970: value!/1000)
            self.datePickerTo?.minimumDate = dateOfRegistration
            self.datePickerFrom?.minimumDate = dateOfRegistration
            
        }
        
        datePickerFrom?.datePickerMode = .date
        datePickerFrom?.addTarget(self, action: #selector(DateFilterViewController.fromDateChanged(datePickerFrom:)), for: .valueChanged)
        
        datePickerTo?.datePickerMode = .date
        datePickerTo?.addTarget(self, action: #selector(DateFilterViewController.toDateChanged(datePickerTo:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DateFilterViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        fromDateTextField.inputView = datePickerFrom
        toDateTextField.inputView = datePickerTo
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func fromDateChanged(datePickerFrom: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        fromDateTextField.text = dateFormatter.string(from: datePickerFrom.date)
        
//        let seconds = datePickerFrom.date.timeIntervalSince1970
//        let milliseconds = seconds * 1000
//        print(milliseconds)
    }
    
    @objc func toDateChanged(datePickerTo: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        toDateTextField.text = dateFormatter.string(from: datePickerTo.date)
        
//        let seconds = datePickerTo.date.timeIntervalSince1970
//        let milliseconds = seconds * 1000
//        print(milliseconds)
    }
    
    @IBAction func showFilteredButtonTapped(_ sender: Any) {
        
        let ref: DatabaseReference
        ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        let difHour: Double = (60*60*26)
        let difMinSec: Double = (60*59+59)
        let dif3hour: Double = (60*60*3)
        
        var totalExpense = 0
        var totalIncome = 0
        
        //Counting income fo choosed date
        ref.child("users").child(uid!).child("income").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String:AnyObject]{
                let fromDate = ((self.datePickerFrom?.date.timeIntervalSince1970)! + dif3hour)*1000
                let toDate = ((self.datePickerTo?.date.timeIntervalSince1970)! + difHour + difMinSec)*1000
                let timeValue = value["timestamp"] as! Double
                
                if timeValue >= fromDate && timeValue <= toDate{
                    totalIncome += Int(value["amount"] as! Double)
                }
            }
            self.incomeResultLabel.text = String(totalIncome)
        }
        
        //Counting cost for Cafe
        ref.child("users").child(uid!).child("expense").child("Cafe").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String: Double] {
                let fromDate = ((self.datePickerFrom?.date.timeIntervalSince1970)! + dif3hour)*1000
                let toDate = ((self.datePickerTo?.date.timeIntervalSince1970)!  + difHour + difMinSec)*1000
                if value["timestamp"]! >= fromDate && value["timestamp"]! <= toDate{
                    totalExpense += Int(value["amount"]!)
                }
            }
        }

        //Counting cost for Car
        ref.child("users").child(uid!).child("expense").child("Car").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String: Double] {
                let fromDate = ((self.datePickerFrom?.date.timeIntervalSince1970)! + dif3hour)*1000
                let toDate = ((self.datePickerTo?.date.timeIntervalSince1970)! + difHour + difMinSec)*1000
                if value["timestamp"]! >= fromDate && value["timestamp"]! <= toDate{
                    totalExpense += Int(value["amount"]!)
                }
            }
        }

        //Counting cost for Entertainment
        ref.child("users").child(uid!).child("expense").child("Entertainment").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String: Double] {
                let fromDate = ((self.datePickerFrom?.date.timeIntervalSince1970)! + dif3hour)*1000
                let toDate = ((self.datePickerTo?.date.timeIntervalSince1970)! + difHour + difMinSec)*1000
                if value["timestamp"]! >= fromDate && value["timestamp"]! <= toDate{
                    totalExpense += Int(value["amount"]!)
                }
            }
        }

        //Counting cost for Other
        ref.child("users").child(uid!).child("expense").child("Other").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String: Double] {
                let fromDate = ((self.datePickerFrom?.date.timeIntervalSince1970)! + dif3hour)*1000
                let toDate = ((self.datePickerTo?.date.timeIntervalSince1970)! + difHour + difMinSec)*1000
                if value["timestamp"]! >= fromDate && value["timestamp"]! <= toDate{
                    totalExpense += Int(value["amount"]!)
                }
            }
        }

        //Counting cost for Supermarkets
        ref.child("users").child(uid!).child("expense").child("Supermarkets").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String: Double] {
                let fromDate = ((self.datePickerFrom?.date.timeIntervalSince1970)! + dif3hour)*1000
                let toDate = ((self.datePickerTo?.date.timeIntervalSince1970)! + difHour + difMinSec)*1000
                if value["timestamp"]! >= fromDate && value["timestamp"]! <= toDate{
                    totalExpense += Int(value["amount"]!)
                }
            }
            self.expenseResultLabel.text = String(totalExpense)
        }
  
        view.endEditing(true)
    }
    
}

