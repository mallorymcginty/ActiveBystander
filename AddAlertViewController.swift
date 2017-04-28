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
    
    
    var locationManager: CLLocationManager!
   
    var myLongitude: Double!
    var myLatitude: Double!
    var location: CLLocation!
    {
        didSet
        {
            myLatitude =  location.coordinate.latitude
            myLongitude = location.coordinate.longitude
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkCoreLocationPermission()
    }
    
    func checkCoreLocationPermission()
    {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
            locationManager.startUpdatingLocation()
        
        }
        if CLLocationManager.authorizationStatus() == .notDetermined
        {
            locationManager.requestWhenInUseAuthorization()
        }
        if CLLocationManager.authorizationStatus() == .restricted
        {
            print("Unauthorized")
            let ac = UIAlertController(title: "Unable to Add Alert!", message:"Please allow Active Bystander access to your location.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        location = locations.last
        locationManager.stopUpdatingLocation()
    }
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
     
    }
    
    
  
    

    @IBAction func btnAddAlert(_ sender: Any)
    {
        locationManager.startUpdatingLocation()
        
        var ref: FIRDatabaseReference!
        
       
        
        ref = FIRDatabase.database().reference()
        
        //Might cause an issue
        let alert : [String : Any] =
            ["alertDescription": txtAlertDescription.text!,
             "latitude": self.myLatitude!,
             "longitude": self.myLongitude!,
             "isDisabled": false,
             "title": "Mallory",
             "userID": FIRAuth.auth()!.currentUser!.uid as Any]
        
        print(alert)
        
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
