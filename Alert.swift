//
//  Alert.swift
//  ActiveBystander
//
//  Created by Ivor D. Addo, PhD on 3/9/17.
//  Copyright © 2017 Mallory McGinty. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class Alert: NSObject, MKAnnotation
{
    
    //Pull First and link profile info
    //First as Title
    let alertDescription: String?
    let coordinate: CLLocationCoordinate2D
    let isDisabled: Bool
    
    init(alertDescription: String, coordinate: CLLocationCoordinate2D, isDisabled: Bool)
    {
        //change to match above
        self.alertDescription = alertDescription
        self.coordinate = coordinate
        self.isDisabled = isDisabled
        
        super.init()
        
    }
   
    var subtitle: String?
    {
            //change to match above
            return alertDescription
    }
    
    
    
    
}
