//
//  MapViewExtension.swift
//  ActiveBystander
//
//  Created by Ivor D. Addo, PhD on 3/10/17.
//  Copyright © 2017 Mallory McGinty. All rights reserved.
//

import UIKit
import MapKit
import Firebase

extension MapViewController: MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if let annotation = annotation as? Alert
        {
            let identifier = "Alert"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            {
                dequeuedView.annotation = annotation
                view = dequeuedView
            }
            else
            {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -8, y: -5)
                view.pinTintColor = .red
                view.animatesDrop = true
                //view.image = UIImage(named: "mapButtonOff.png")
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIButton
            }
            return view
        }
        return nil
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        let alert = view.annotation as! Alert
        //change to person..
        let title = alert.title
        let alertDescription = alert.subtitle
        
        let ac = UIAlertController(title: "User", message: alertDescription, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
       /* ac.addAction(UIAlertAction(title: "Remove", style: .default)
        {
            (result : UIAlertAction) -> Void in
            mapView.removeAnnotation(alert)
        })*/
       present(ac, animated: true)
    

}



}
