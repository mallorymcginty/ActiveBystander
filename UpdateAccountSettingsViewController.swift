//
//  UpdateAccountSettingsViewController.swift
//  ActiveBystander
//
//  Created by Ivor D. Addo, PhD on 3/18/17.
//  Copyright © 2017 Mallory McGinty. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class UpdateAccountSettingsViewController: UIViewController {

    //DONT LET EDIT FIRST OR LAST
    //SPECIAL CASE FOR EMAIL AND PW
    //PHOTO
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var txtFirst: UITextField!
    @IBOutlet weak var txtLast: UITextField!

   
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtCampusSafety: UITextField!
    @IBOutlet weak var switchNotifications: UISwitch!
    
    @IBOutlet weak var btnSaveAcct: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnEmailReset: UIButton!
    
    @IBOutlet weak var btnLogout: UIButton!
    
    
    let userNodeRef = FIRDatabase.database().reference().child("users")
    

    @IBAction func btnSaveAcct(_ sender: Any)
    {
        if let userPhone = txtPhone.text, let campus = txtCampusSafety.text, let first = txtFirst.text, let last = txtLast.text
        {
            let user = FIRAuth.auth()?.currentUser
            
            let userValues = ["user phone": userPhone, "campus phone": campus, "first": first, "last": last]
            
            self.userNodeRef.child((user?.uid)!).updateChildValues(userValues, withCompletionBlock: {(userDBError, userDBRef) in
            })
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "accountSettings")
        self.present(vc!, animated: true, completion: nil)
                    
        
                
        }
        }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
    
        
    }

    @IBAction func btnLogout(_ sender: UIButton)
    {
        try! FIRAuth.auth()?.signOut()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "login")
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    
    
    
}

