//
//  ProfileViewController.swift
//  ActiveBystander
//
//  Created by Ivor D. Addo, PhD on 3/5/17.
//  Copyright © 2017 Mallory McGinty. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblRace: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblBuild: UILabel!
    @IBOutlet weak var lblHair: UILabel!
    @IBOutlet weak var lblEye: UILabel!
 
  
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // profileImageView.image = FIRStorage.reference(<#T##FIRStorage#>)
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        
        }

    
    @IBAction func btnLogout(_ sender: AnyObject)
    {
       try! FIRAuth.auth()?.signOut()
    }
    
    
    
    
    
    
    }


