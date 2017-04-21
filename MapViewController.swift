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
            
        func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
            let location = locations.last as! CLLocation
            //How to zoom in on location?
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
           
            self.mapView.setRegion(region, animated: true)
        }
        

        
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
                
                let alert = Alert(title: (dictionary["first"] as? String)!, alertDescription: (dictionary["alertDescription"] as? String)!,
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
