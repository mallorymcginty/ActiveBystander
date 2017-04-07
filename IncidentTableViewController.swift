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

       
       // self.fetchIncidents()
        
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
    
    /*func fetchIncidents()
    {
        self.incidents = Incident.fetchIncidents()
        self.tableView.reloadData()
    }*/
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incidents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cellIdentifier = "IncidentCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentCell", for: indexPath) as! IncidentTableViewCell
       let  incidentItem = incidents[indexPath.row]
        
        //HOW TO ADD IN CITY AND DESCRIPTION
       // cell.textLabel?.text = incidentItem.Category
       // cell.detailTextLabel?.text = incidentItem.Address
      cell.lblIncCategory.text? = incidentItem.Category
        cell.lblIncAddress.text? = incidentItem.Address
        cell.lblIncCity.text? = incidentItem.City
        cell.lblIncState.text? = incidentItem.State
        
         return cell
    }
    
    
        
    
}
