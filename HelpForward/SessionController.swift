//
//  SessionController.swift
//  HelpForward
//
//  Created by Kirill Zonov on 02.04.16.
//  Copyright © 2016 Kirill Zonov. All rights reserved.
//

import UIKit
import Alamofire

class SessionController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userIdLabel: UILabel!

    @IBAction func loginButtonPressed(sender: AnyObject) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        authoriseUser()
    }
    
    private func authoriseUser() {
        Alamofire.request(.GET, "http://127.0.0.1:3000/api/users/sign_in", parameters: ["email": emailField.text!, "password": passwordField.text!])
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    let userId = "\(JSON["id"] as! Int)"
                    NSUserDefaults.standardUserDefaults().setObject(userId, forKey: "currentUserId")
                }
        }
    }
}
