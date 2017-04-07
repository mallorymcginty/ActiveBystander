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
    
    //Profile picture

    @IBAction func btnSaveProf(_ sender: Any)
    {
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        
        let user : [String : Any] =
            ["DOB": txtDOB.text!,
             "Gender": txtGender.text!,
             "Race": txtRace.text!,
             "Height": txtHeight.text!,
             "Hair": txtHair.text!,
             "Eyes": txtEye.text!]
        
        //Adds FB JSON node for incidentLog
        
        //SET FOR CURRENT USER
        ref.child("users").childByAutoId().setValue(user)
        
        txtDOB.text = nil
        txtGender.text = nil
        txtRace.text = nil
        txtHeight.text = nil
        txtHair.text = nil
        txtEye.text = nil
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "userInfo")
        self.present(vc!, animated: true, completion: nil)
    }
   
    
    
    
    
    
    
    
    
    override func viewDidLoad()
    {
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
