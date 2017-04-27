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



class MapViewController: UIViewController, CLLocationManagerDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    
    var alertNodeRef : FIRDatabaseReference!
    var alerts: [Alert] = []
    var ref = FIRDatabase.database().reference(withPath: "alerts")


    
    
        
    
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.mapView.showsUserLocation = true
        mapView.delegate = self
        locationManager.delegate = self
        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        
        
    }

    
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        self.mapView.delegate = self
        
        
        
        
        
        //Create DB reference
        alertNodeRef = FIRDatabase.database().reference()
        
        
        // let pinAlertId = "alrt-1"
        var pinAlert: Alert?
        //alertNodeRef.child("alerts").child.observe(.value, with: { (snapshot: FIRDataSnapshot) in
        
        alertNodeRef.child("alerts").queryOrdered(byChild: "isDisabled").queryEqual(toValue: false).observe(.value, with: { snapshot in
            
            print(snapshot.value)
            
            
            if let dictionary = snapshot.value as? [String: Any]
            {
                
                for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    guard (rest.value as? [String: AnyObject]) != nil else {
                        
                        print("CHILDREN", snapshot.children)
                        print("REST:  ", rest)
                        
                        
                        
                        
                        continue
                        
                        
                        
                        
                    }
                    
                }
                
                for dbItem in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    
                    print("DBITEM:    ", dbItem.value!)
                    
                    guard let restDict = dbItem.value as? [String: AnyObject] else
                    {
                        continue
                    }
                    //let someValue = restDict["key"]
                    
                    
                    // let dict = snapshot.childSnapshot(forPath: dbItem.key)
                    
                    let pinLat = restDict["latitude"] as? Double
                    let pinLong = restDict["longitude"] as? Double
                    let alertDisabled = restDict["isDisabled"] as? Bool
                    
                   //  var clLoc:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:pinLat!, longitude:pinLong!);
                    
                    
                    
                    // convert the snapshot JSON value to your Struct type
                   // let newValue = Alert(alertDescription: (restDict["alertDescription"] as? String)! , coordinate: clLoc, longitude:pinLong!, latitude:pinLat!, isDisabled: alertDisabled!, title: "User")
                    
                    
                    //if pinAlert != nil
                    //{
                     //   self.mapView.removeAnnotation(pinAlert!)
                    //}
                    
                    print(dictionary)
                    
                    
                    
                    let alert = Alert(alertDescription: (restDict["alertDescription"] as? String)!,
                                      coordinate: CLLocationCoordinate2D(latitude: pinLat!, longitude: pinLong!), longitude: pinLong!, latitude: pinLat!,
                                      isDisabled: alertDisabled!, title:"User Name")
                    
                    
                    pinAlert = alert
                    
                   // if !alert.isDisabled
                    //{
                        self.mapView.addAnnotation(alert as MKAnnotation)
                    //}
                    
                    
                   // newItems.append(newValue)
                }
                
            }
            
            
        })
    }
}
