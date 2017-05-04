//
//  Incidents.swift
//  ActiveBystander
//
//  Created by Ivor D. Addo, PhD on 4/1/17.
//  Copyright © 2017 Mallory McGinty. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Incident {
    
    
    
    let key: String
    let Category: String
    let Address: String
    let ref: FIRDatabaseReference?
    var City: String
    var State: String
    var Description: String
    let user = FIRAuth.auth()?.currentUser
    let IncDate: String
    
      
    
    
    
    
    init(Category: String, Address: String, City: String, State: String, Description:String, User: String, key: String = "", IncDate: String)
    {
        self.key = key
        self.Category = Category
        self.Address = Address
        self.City = City
        self.State = State
        self.Description = Description
        self.ref = nil
        self.IncDate = IncDate
        
        
        
    }
    
    init(snapshot: FIRDataSnapshot) {
        let uid = user?.uid
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        Category = snapshotValue["Category"] as! String
        Address = snapshotValue["Address"] as! String
        City = snapshotValue["City"] as! String
        State = snapshotValue["State"] as! String
        Description = snapshotValue["Description"] as! String
        ref = snapshot.ref
        IncDate = snapshotValue["IncDate"] as! String
    
    }
    
    func toAnyObject() -> Any {
        return [
            "Category": Category,
            "Address": Address,
            "City": City,
            "State": State,
            "Description": Description,
            "user": user!,
            "IncDate": IncDate
          
            
        ]
    }
    
}
