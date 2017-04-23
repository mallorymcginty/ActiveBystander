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

class AddAlertViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var txtAlertDescription: UITextField!
    
    @IBOutlet weak var btnAddAlert: UIButton!
    
    
    let locationManager   = CLLocationManager()
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            
            print("target position : =  \(location.coordinate)")
            print(locationManager.location!.coordinate.latitude)
            locationManager.stopUpdatingLocation()
            FIRDatabase.database().reference().child("Location").child(FIRAuth.auth()!.currentUser!.uid).setValue(["Latitude": locationManager.location!.coordinate.latitude, "Longitude": locationManager.location!.coordinate.longitude])
        }
        
    }
  
    

    @IBAction func btnAddAlert(_ sender: Any)
    {
        super.viewDidLoad()
        
        var ref: FIRDatabaseReference!
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        
        ref = FIRDatabase.database().reference()
        
        //Might cause an issue
        let alert : [String : Any] =
            ["alertDescription": txtAlertDescription.text!,
             "Location": locationManager,
             "userID": uid!]
        
        //Adds FB JSON node for incidentLog
        ref.child("alerts").childByAutoId().setValue(alert)
        
        txtAlertDescription.text = nil
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "map")
        self.present(vc!, animated: true, completion: nil)
        
    }
    
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
        txtAlertDescription.resignFirstResponder()
    }

    
    

    
}
