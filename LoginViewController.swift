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
    @IBOutlet weak var btnGoToSignUp: UIButton!
    
    
    @IBAction func btnSignIn(_ sender: UIButton)
    {
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            
            // if the signin is successful then we should have a valid "user" value
            if user != nil {
                // user is found go to the menu screen: present it modally (with no back button)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "menu")
                // in this case, "weather" should be your landing pages' storyboard id
                self.present(vc!, animated: true, completion: nil)
            }
            else{
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
    
    
    
   

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
