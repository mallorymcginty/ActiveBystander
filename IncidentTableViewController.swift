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

class IncidentTableViewController: UITableViewController

{
   var incidents: [Incident] = []
    let ref = FIRDatabase.database().reference(withPath: "Incidents")
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //ref = FIRDatabaseReference.database().reference(withPath:"Incidents")
        //fetchIncidents()
        
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        //ORDER BY TIME POSTED - AUTOMATIC
        ref.observe(.value, with: { snapshot in
            print(snapshot.value!)
            
            var newIncident: [Incident] = []
            
            for Incidents in snapshot.children {
                let incident = Incident(snapshot: Incidents as! FIRDataSnapshot)
                newIncident.append(incident)
            }
            
            self.incidents = newIncident
            self.tableView.reloadData()
            
            })
        
        
        
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incidents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentCell", for: indexPath)
        let  incidentItem = incidents[indexPath.row]
        
        //HOW TO ADD IN CITY AND DESCRIPTION
        cell.textLabel?.text = incidentItem.Category
        cell.detailTextLabel?.text = incidentItem.Address
        
        
         return cell
    }
    
    
        
/*func fetchIncidents()
{
    refHandle = ref.child("Incidents").observe(.childAdded, with: { (snapshot) in
    if let dictionary = snapshot.value as? [String : AnyObject]
    {
        print(dictionary)
        
        let incident = Incident()
        
        incident.setValuesForKeysWithDictionary(dictionary)
        self.incident.append(incident)
        
        self.tableView.reloadData()
        
        

        
        }
        
        
        
    })
    
    }*/
    
}
