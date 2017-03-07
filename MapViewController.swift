//
//  MapViewController.swift
//  ActiveBystander
//
//  Created by Ivor D. Addo, PhD on 3/5/17.
//  Copyright © 2017 Mallory McGinty. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class MapViewController: UIViewController
{
    

    @IBOutlet weak var mapView: MKMapView!
    
    
    
    
    
    //set initial location - DO I NEED THIS???
    let initialLocation = CLLocation(latitude: 43.038611, longitude: -87.928759)
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }

    
override func viewDidLoad()
    {
    super.viewDidLoad()
        
    //set initial location to MU - DO I NEED THIS??
    let initalLocation = CLLocation(latitude: 43.038611, longitude: -87.928759)
    centerMapOnLocation(location: initialLocation)
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
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
        
    
}
}


