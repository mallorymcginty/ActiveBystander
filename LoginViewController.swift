//
//  LoginViewController.swift
//  ActiveBystander
//
//  Created by Ivor D. Addo, PhD on 2/26/17.
//  Copyright © 2017 Mallory McGinty. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnSignIn: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSignIn(_ sender: Any)
    {
        
       // activityIndicator.isHidden = false
        btnSignIn.isHidden = true
        
            
            // if the signin is successful then we should have a valid "user" value
            if let email = txtEmail.text, let password = txtPassword.text
            {
                FIRAuth.auth()?.signIn(withEmail: email, password: password) {(user, error) in
                if user != nil
                {
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "menu")
                    self.present(vc!, animated: true, completion: nil)
                    }
            
            else
                {
                // check error and show an error message)
                
                let alertController = UIAlertController(title: "Login Failed!", message: (error?.localizedDescription)!, preferredStyle: UIAlertControllerStyle.alert)
                
                // create an OK button for dismissing the alert
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                    print("OK")
                }
                
                // add a button to the alert pop-up
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
    }

    override func viewDidAppear(_ animated: Bool)
    {
        if FIRAuth.auth()?.currentUser != nil
        {
           // activityIndicator.isHidden = true
            btnSignIn.isHidden = false
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "menu")
            self.present(vc!, animated: true, completion: nil)
        }
    }
    
    

}

