//
//  MapViewController.swift
//  ActiveBystander
//
//  Created by Ivor D. Addo, PhD on 3/9/17.
//  Copyright © 2017 Mallory McGinty. All rights reserved.
//

import UIKit
import MapKit
import Firebase



class MapViewController: UIViewController
{
    @IBOutlet weak var mapView: MKMapView!
    
    var alertNodeRef : FIRDatabaseReference!
    


    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.mapView.delegate = self
            
            let initialLocation = CLLocation(latitude: 43.038611, longitude: -87.928759)
            centerMapOnLocation(location: initialLocation)
        
        

        
        //Create DB reference
        alertNodeRef = FIRDatabase.database().reference().child("alerts")
        
        
       // let pinAlertId = "alrt-1"
        var pinAlert: Alert?
        alertNodeRef.child("alerts").observe(.value, with: { (snapshot: FIRDataSnapshot) in
            
            if let dictionary = snapshot.value as? [String: Any]
            {
                if pinAlert != nil
                {
                    self.mapView.removeAnnotation(pinAlert!)
                }
                
                let pinLat = dictionary["latitude"] as! Double
                let pinLong = dictionary["longitude"] as! Double
                let alertDisabled = dictionary["isDisabled"] as! Bool
                
                let alert = Alert(alertDescription: (dictionary["alertDescription"] as? String)!,
                                  coordinate: CLLocationCoordinate2D(latitude: pinLat, longitude: pinLong),
                                  isDisabled: alertDisabled
                    )
                
            
                
        pinAlert = alert
            
                if !alert.isDisabled
                {
                    self.mapView.addAnnotation(alert)
                }
            }
            })
        }
    
     /*  let alert = Alert(title: "Person Name", locationName: "Person info", username: "user123", coordinate: CLLocationCoordinate2D(latitude: 43.043914, longitude:-87.917262), isDisabled: false)
        
        mapView.addAnnotation(alert)*/
        
        
    
    
   
    
    let regionRadius: CLLocationDistance = 500
    func centerMapOnLocation(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
    }

    
    var locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus()
    {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
            mapView.showsUserLocation = true
        }
        else
        {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
}
