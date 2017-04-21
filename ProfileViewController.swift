//
//  ProfileViewController.swift
//  ActiveBystander
//
//  Created by Ivor D. Addo, PhD on 3/5/17.
//  Copyright © 2017 Mallory McGinty. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

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
 
    var ref: FIRDatabaseReference!
    //ref = FIRDatabase.database().reference()
    let userNodeRef = FIRDatabase.database().reference().child("users")
    
    
    var storageRef: FIRStorageReference!
    
  
    
    
    
    
    
    
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
                self.lblDOB.text = dictionary["DoB"] as? String
                self.lblEye.text = dictionary["eye color"] as? String
                self.lblGender.text = dictionary["gender"] as? String
                self.lblHair.text = dictionary["hair color"] as? String
                self.lblRace.text = dictionary["race"] as? String
                self.lblBuild.text = dictionary["build"] as? String
                self.lblHeight.text = dictionary["height"] as? String
                //Will this display the image
                //Or do I need to convert from url to image
                self.profileImageView.image = dictionary["userPhoto"] as? UIImage
            }
        
        
        })

        
        
        }

    
    @IBAction func btnLogout(_ sender: AnyObject)
    {
       try! FIRAuth.auth()?.signOut()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "login")
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    
    
    
    
    }


