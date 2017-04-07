//
//  UpdateAccountSettingsViewController.swift
//  ActiveBystander
//
//  Created by Ivor D. Addo, PhD on 3/18/17.
//  Copyright © 2017 Mallory McGinty. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UpdateAccountSettingsViewController: UIViewController {

    //DONT LET EDIT FIRST OR LAST
    //SPECIAL CASE FOR EMAIL AND PW
    //PHOTO
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var txtFirst: UITextField!
    @IBOutlet weak var txtLast: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
   
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtCampusSafety: UITextField!
    @IBOutlet weak var switchNotifications: UISwitch!
    
    @IBOutlet weak var btnSaveAcct: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    
    

    @IBAction func btnSaveAcct(_ sender: Any)
    {
        var ref: FIRDatabaseReference!
        //SPECIFIC USER
        ref = FIRDatabase.database().reference()
        
        let user : [String : Any] =
            ["Phone": txtPhone.text!,
             "Campus Safety": txtCampusSafety.text!,
             "Notifications": switchNotifications]
        
        //Adds FB JSON node for incidentLog
        ref.child("users").childByAutoId().setValue(user)
        
        txtPhone.text = nil
        txtCampusSafety.text = nil
        switchNotifications = nil
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "accountSettings")
        self.present(vc!, animated: true, completion: nil)
                    
        
                
        
            
            
    

        }
    
    
   /*func btnLogout(_ sender: Any)
    {
        
            print("sign out button tapped")
            let firebaseAuth = FIRAuth.auth()
            do {
                try! firebaseAuth?.signOut()
                
            } catch let signOutError as NSError {
                print ("Error signing out: \(signOutError)")
            } catch {
                print("Unknown error.")
            }

        
    }*/
    
    
    
    
    
    
    
    


    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // profileImageView.image = FIRStorage.reference(<#T##FIRStorage#>)
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
    
        
    }






    //@IBAction func btnReset(_ sender: Any)
    //{
        //Only examples with specific email......
    //    FIRAuth.auth()?.sendPasswordReset(withEmail: email)
    //    {
   //        // error in
    //    }
   // }

    
    
}

