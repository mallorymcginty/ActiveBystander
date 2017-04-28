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

class UpdateAccountSettingsViewController: UIViewController, UITextFieldDelegate {

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
        
        
        txtFirst.delegate = self
        txtFirst.tag = 0
        
        txtLast.delegate = self
        txtLast.tag = 1
        
        txtPhone.delegate = self
        txtPhone.tag = 2
        
        txtCampusSafety.delegate = self
        txtCampusSafety.tag = 3
        
        
        
        // profileImageView.image = FIRStorage.reference(<#T##FIRStorage#>)
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        
        let user = FIRAuth.auth()?.currentUser?.uid
        
        FIRDatabase.database().reference().child("users").child(user!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                //Convert?
                self.profileImageView.image = dictionary["userPhoto"] as? UIImage
                
            }
            
        })

        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
        txtFirst.resignFirstResponder()
        txtLast.resignFirstResponder()
        txtPhone.resignFirstResponder()
        txtCampusSafety.resignFirstResponder()
        
    }
    

    
    
    
    

    @IBAction func btnLogout(_ sender: UIButton)
    {
        try! FIRAuth.auth()?.signOut()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "login")
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    
    
    
}

