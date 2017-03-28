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
        //Notifications..
        if let first = txtFirst.text, let last = txtLast.text, let email = txtEmail.text, let phone = txtPhone.text, let campus = txtCampusSafety.text
        {
            FIRAuth.auth()?.createUser(withEmail: email, password: "") {(user, error) in
                
              //  {
                    //Email special case??
              //      let userValues = ["first": first, "last": last, "email": email, "phone": phone, "campus safety": campus]
                  //  self.userNodeRef.child((user?.uid)!).updateChildValues(userValues, withCompletionBlock: {(userDBError, userDBRef) in
                        
             //       })
                    
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "accountSettings")
                    self.present(vc!, animated: true, completion: nil)
                
                
            }
            
            
            }

        }
        
    }


    
    
    
    
    //override func viewDidLoad() {
    //    super.viewDidLoad()

    //    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
   //     self.profileImageView.layer.borderWidth = 3.0
    //    self.profileImageView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        
    
        
  //  }

//    @IBAction func btnLogout(_ sender: AnyObject)
 //   {
 //       try! FIRAuth.auth()?.signOut()
 //   }
    
    //@IBAction func btnReset(_ sender: Any)
    //{
        //Only examples with specific email......
    //    FIRAuth.auth()?.sendPasswordReset(withEmail: email)
    //    {
   //        // error in
    //    }
   // }

    
    
    

