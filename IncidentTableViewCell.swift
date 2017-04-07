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
    
    var incidents: [Incident] = []
    var ref = FIRDatabase.database().reference(withPath: "Incidents")
    
    
   

 
    
}
