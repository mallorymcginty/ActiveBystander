//
//  IncidentTableViewCell.swift
//  ActiveBystander
//
//  Created by Ivor D. Addo, PhD on 4/6/17.
//  Copyright © 2017 Mallory McGinty. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

class IncidentTableViewCell: UITableViewCell
{
    @IBOutlet weak var lblIncCategory: UILabel!
    @IBOutlet weak var lblIncAddress: UILabel!
    @IBOutlet weak var lblIncCity: UILabel!
    @IBOutlet weak var lblIncState: UILabel!
    
    @IBOutlet weak var btnIncDesc: UIButton!
    
    
    var incidents: [Incident] = []
    var ref = FIRDatabase.database().reference(withPath: "Incidents")
    
    
    @IBAction func btnIncDesc(_ sender: UIButton)
    {
       let alertTitle = "Incident Info"
        let alertMessage = incidents.description
        
        let alertController = UIAlertController(title: alertTitle, message: (alertMessage), preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
            print("OK")
        }
        alertController.addAction(okAction)
        /*presentViewController(alertController, animated: true) {
            //Do something when alert view is presented
        }*/
    }
   
    
    
    
    

 
    
}
