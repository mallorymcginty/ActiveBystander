//
//  ImageUrlItem.swift
//  geoMessenger
//
//  Created by Ivor D. Addo on 4/3/17.
//  Copyright © 2017 deHao. All rights reserved.
//

import Foundation
import Firebase

struct ImageUrlItem {
    
    
    //Should I add my description in here?
    let key: String
    let imageUrl: String
    let watsonCollectionImageUrl: String
    let score: Double
    let description: String
    
    let ref: FIRDatabaseReference?
    
    init(imageUrl: String, key: String = "", watsonCollectionImageUrl: String = "", score: Double = 0, description: String) {
        self.key = key
        self.imageUrl = imageUrl
        self.watsonCollectionImageUrl = watsonCollectionImageUrl
        self.ref = nil
        self.score = score
        self.description = description
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        imageUrl = snapshotValue["ImageUrl"] as! String // must map to firebase names
        watsonCollectionImageUrl = ""
        score = 0
        description = snapshotValue["Description"] as! String
        
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "imageUrl": imageUrl,
            "Description": description
        ]
    }
    
}
