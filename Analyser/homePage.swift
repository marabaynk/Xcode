//
//  homePage.swift
//  Analyser
//
//  Created by Корюн Марабян on 20/03/2019.
//  Copyright © 2019 Корюн Марабян. All rights reserved.
//


import UIKit

class homePage: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /////////////////////////////////////////////
    @IBAction func LogOutTapped(_ sender: Any) {
        UserDefaults().set(false, forKey: "isUserLoggedIn")
        UserDefaults().synchronize()
        self.dismiss(animated: true, completion: nil)
    }
    /////////////////////////////////////////////

    
    //Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}
