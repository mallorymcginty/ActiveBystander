//
//  IncidentTableViewController.swift
//  ActiveBystander
//
//  Created by Ivor D. Addo, PhD on 3/18/17.
//  Copyright © 2017 Mallory McGinty. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class IncidentTableViewController: UITableViewController

{
    
   var incidents: [Incident] = []
    var ref = FIRDatabase.database().reference(withPath: "Incidents")
    
    struct Storyboard {
        static let incidentCell = "IncidentCell"
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
    
        tableView.allowsSelection = false
        
        tableView.contentInset.top = 15
        tableView.backgroundColor = UIColor(red:0.38, green:0.52, blue:0.69, alpha:1.0)
      
        tableView.allowsMultipleSelectionDuringEditing = false
        
        //ORDER BY TIME POSTED - AUTOMATIC
        ref.observe(.value, with: { snapshot in
            print(snapshot.value!)
            
            var newIncident: [Incident] = []
            
            //Change to child added??
            for Incidents in snapshot.children {
                let incident = Incident(snapshot: Incidents as! FIRDataSnapshot)
                newIncident.append(incident)
            }
            
            self.incidents = newIncident
            self.tableView.reloadData()
            
            })
        
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            //self.user = User(authData: user)
        }
        
        
        
        
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incidents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cellIdentifier = "IncidentCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentCell", for: indexPath) as! IncidentTableViewCell
       let  incidentItem = incidents[indexPath.row]
        
        
        cell.lblIncCategory.text? = incidentItem.Category
        cell.lblIncAddress.text? = incidentItem.Address
        cell.lblIncCity.text? = incidentItem.City
        cell.lblIncState.text? = incidentItem.State
        
        cell.btnIncDesc.accessibilityLabel = incidentItem.Description
        
         return cell
    }
    
    
    
}


