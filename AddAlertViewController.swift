//
//  AddAlertViewController.swift
//  ActiveBystander
//
//  Created by Ivor D. Addo, PhD on 4/2/17.
//  Copyright © 2017 Mallory McGinty. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MapKit

class AddAlertViewController: UIViewController {

    @IBOutlet weak var txtAlertDescription: UITextField!
    
    @IBOutlet weak var btnAddAlert: UIButton!
    
    
    
  
    

    @IBAction func btnAddAlert(_ sender: Any)
    {
        super.viewDidLoad()
        
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        
        let alert : [String : Any] =
            ["alertDescription": txtAlertDescription.text!]
        
        //Adds FB JSON node for incidentLog
        ref.child("alerts").childByAutoId().setValue(alert)
        
        txtAlertDescription.text = nil
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "map")
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    
    
    
    
    override func viewDidLoad()
    {
    

        
        
    }

    
}
