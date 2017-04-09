//
//  UpdateProfileViewController.swift
//  ActiveBystander
//
//  Created by Ivor D. Addo, PhD on 3/5/17.
//  Copyright © 2017 Mallory McGinty. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class UpdateProfileViewController: UIViewController
{

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtRace: UITextField!
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet weak var txtBuild: UITextField!
    @IBOutlet weak var txtHair: UITextField!
    @IBOutlet weak var txtEye: UITextField!
    
    @IBOutlet weak var btnSaveProf: UIButton!
    
    let userNodeRef = FIRDatabase.database().reference().child("users")
    

    @IBAction func btnSaveProf(_ sender: Any)
    {
        if let DoB = txtDOB.text, let gender = txtGender.text, let RaceEth = txtRace.text, let height = txtHeight.text, let build = txtBuild.text, let hair = txtHair.text, let eyes = txtEye.text
        {
            let user = FIRAuth.auth()?.currentUser
            
            let userValues = ["DoB": DoB, "gender": gender, "race": RaceEth, "height": height, "build": build, "hair color": hair, "eye color": eyes]
            self.userNodeRef.child((user?.uid)!).updateChildValues(userValues, withCompletionBlock: {(userDBError, userDBRef) in
            })
            
            
            
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "userInfo")
        self.present(vc!, animated: true, completion: nil)
        }
    }
   
    
    
    
    
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor

        
        
        
    }

    @IBAction func btnLogout(_ sender: AnyObject)
    {
        try! FIRAuth.auth()?.signOut()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "login")
        self.present(vc!, animated: true, completion: nil)
    }
  

}
