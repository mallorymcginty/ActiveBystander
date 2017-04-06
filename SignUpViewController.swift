//
//  SignUpViewController.swift
//  ActiveBystander
//
//  Created by Ivor D. Addo, PhD on 2/26/17.
//  Copyright © 2017 Mallory McGinty. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class SignUpViewController: UIViewController {

    @IBOutlet weak var txtFirst: UITextField!
    @IBOutlet weak var txtLast: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirm: UITextField!
    
    @IBOutlet weak var btnSignUp: UIButton!

//Still need to add password = confirm
//Still need to add user must have .edu email

    
   let userNodeRef = FIRDatabase.database().reference().child("users")

    
    @IBAction func btnSignUp(_ sender: Any)

    {
    
  
        if let email = txtEmail.text, let password = txtPassword.text, let confirm = txtConfirm.text, let first = txtFirst.text, let last = txtLast.text
         {
            FIRAuth.auth()?.createUser(withEmail: email, password: password) {(user, error) in
                if user != nil
                {
            
                    
                    let userValues = ["first": first, "last": last, "email": email]
                    self.userNodeRef.child((user?.uid)!).updateChildValues(userValues, withCompletionBlock: {(userDBError, userDBRef) in
                        if userDBError != nil
                        {
                            let alertTitle = "User registration Failed!"
                            let alertMessage = ("Unable to save your information to the database. Contact System Administrator.")
                            
                            
                            
                            let alertController = UIAlertController(title: alertTitle, message: (alertMessage), preferredStyle: UIAlertControllerStyle.alert)
                            
                            // create an OK button for dismissing the alert
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                (result : UIAlertAction) -> Void in
                                print("OK")
                            }
                            
                            // add a button to the alert pop-up
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }

                        
                    })
                    
                    
                   let vc = self.storyboard?.instantiateViewController(withIdentifier: "terms")
                   self.present(vc!, animated: true, completion: nil)
                
    
                    
                }
                else
                {
                    let alertTitle = "Registration Failed!"
                    let alertMessage = (error?.localizedDescription)!
                    

                    
                    let alertController = UIAlertController(title: alertTitle, message: (alertMessage), preferredStyle: UIAlertControllerStyle.alert)
                
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

        
        
        
        

    func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        txtConfirm.resignFirstResponder()
        txtFirst.resignFirstResponder()
        txtLast.resignFirstResponder()
    }
    
    
    
}
