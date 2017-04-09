//
//  AccountSettingsViewController.swift
//  ActiveBystander
//
//  Created by Ivor D. Addo, PhD on 3/18/17.
//  Copyright © 2017 Mallory McGinty. All rights reserved.
//

import UIKit
import Firebase

class AccountSettingsViewController: UIViewController
{
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var lblFirst: UILabel!
    @IBOutlet weak var lblLast: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblCampusSafety: UILabel!
    @IBOutlet weak var switchNotifications: UISwitch!
    
    
     let userNodeRef = FIRDatabase.database().reference().child("users")
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // profileImageView.image = FIRStorage.reference(<#T##FIRStorage#>)
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor

        let user = FIRAuth.auth()?.currentUser?.uid
        
        FIRDatabase.database().reference().child("users").child(user!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                self.lblFirst.text = dictionary["first"] as? String
                self.lblLast.text = dictionary["last"] as? String
                self.lblPhone.text = dictionary["user phone"] as? String
                self.lblCampusSafety.text = dictionary["campus phone"] as? String
                self.lblEmail.text = dictionary["email"] as? String
                
            }
            
            
        })
        
    }

    
    
    @IBAction func btnLogout(_ sender: AnyObject)
    {
        try! FIRAuth.auth()?.signOut()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "login")
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool)
    {
       
    }
    
    
    
    
    
}
