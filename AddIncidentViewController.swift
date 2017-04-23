//
//  AddIncidentViewController.swift
//  ActiveBystander
//
//  Created by Ivor D. Addo, PhD on 3/29/17.
//  Copyright © 2017 Mallory McGinty. All rights reserved.
//

import UIKit
import Firebase

class AddIncidentViewController: UIViewController
{
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtDescription: UITextView!

    
    @IBOutlet weak var btnPostIncident: UIButton!
    
    
    
    @IBAction func btnPostIncident(_ sender: Any)
    {
        
        var ref: FIRDatabaseReference!
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        ref = FIRDatabase.database().reference()
        
        let incidentLog : [String : Any] =
            ["Category": txtCategory.text!,
             "Address": txtAddress.text!,
             "City": txtCity.text!,
             "State": txtState.text!,
             "Description": txtDescription.text!,
             "userID": uid!]
        
        //Adds FB JSON node for incidentLog
        ref.child("Incidents").childByAutoId().setValue(incidentLog)
    
    txtCategory.text = nil
    txtAddress.text = nil
    txtCity.text = nil
    txtState.text = nil
    txtDescription.text = nil
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "incidents")
        self.present(vc!, animated: true, completion: nil)
    
    }
                        
        
        
        
        
        
        
       override func viewDidLoad()
       {
            super.viewDidLoad()
            
            // Do any additional setup after loading the view.
        }
        
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
        txtCity.resignFirstResponder()
        txtState.resignFirstResponder()
        txtAddress.resignFirstResponder()
        txtCategory.resignFirstResponder()
        txtDescription.resignFirstResponder()
    }

    
    
    
    
}


    
    


    
    
    
    
    
    

    

   

