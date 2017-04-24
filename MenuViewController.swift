//
//  MenuViewController.swift
//  ActiveBystander
//
//  Created by Ivor D. Addo, PhD on 2/26/17.
//  Copyright © 2017 Mallory McGinty. All rights reserved.
//

import UIKit
import Firebase


class MenuViewController: UIViewController //, MFMessageComposeViewControllerDelegate
{
    
    
    @IBAction func btnEmergencyContact(_ sender: AnyObject)
    {
        let number:String = "6088976667" // target phonenumber
        let application:UIApplication = UIApplication.shared
        
        // telprompt: vs tel: telpprompt allows the user to return back to your App when the call is complete
        if let url = NSURL(string: "telprompt://\(number)"), application.canOpenURL(url as URL) {
            application.open(url as URL, options: [:], completionHandler: nil)
        }
        else
        {
            let alertTitle = "Cannot complete call!"
            let alertMessage = ("The phone number you have entered is not valid")
            
            
            let alertController = UIAlertController(title: alertTitle, message: (alertMessage), preferredStyle: UIAlertControllerStyle.alert)
            
            // create an OK button for dismissing the alert
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                print("OK") }
            
            // add a button to the alert pop-up
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }

    }
   
    
    
    
    
    @IBAction func btnCampusSafetyCall(_ sender: AnyObject)
    {
        let number:String = "4142886363" // target phonenumber
        let application:UIApplication = UIApplication.shared
        
        // telprompt: vs tel: telpprompt allows the user to return back to your App when the call is complete
        if let url = NSURL(string: "telprompt://\(number)"), application.canOpenURL(url as URL) {
            application.open(url as URL, options: [:], completionHandler: nil)
        }
        else
        {
            let alertTitle = "Cannot complete call!"
            let alertMessage = ("The phone number you have entered is not valid")
            
            
            let alertController = UIAlertController(title: alertTitle, message: (alertMessage), preferredStyle: UIAlertControllerStyle.alert)
            
            // create an OK button for dismissing the alert
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                print("OK") }
            
            // add a button to the alert pop-up
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }

        
    }
    
    @IBAction func btnEmergencyCall(_ sender: AnyObject)
    {
        /*
        let number:String = "4142881911" // target phonenumber
        let application:UIApplication = UIApplication.shared
        
        // telprompt: vs tel: telpprompt allows the user to return back to your App when the call is complete
        if let url = NSURL(string: "telprompt://\(number)"), application.canOpenURL(url as URL) {
            application.open(url as URL, options: [:], completionHandler: nil)
        }
        else
        {
            let alertTitle = "Cannot complete call!"
            let alertMessage = ("The phone number you have entered is not valid")
            
            
            let alertController = UIAlertController(title: alertTitle, message: (alertMessage), preferredStyle: UIAlertControllerStyle.alert)
            
            // create an OK button for dismissing the alert
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                print("OK") }
            
            // add a button to the alert pop-up
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        */
    }
    
    
    
    
    
    
   /* func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case .failed:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case .sent:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        }
    }*/
    
    
    //Add SMS button and implement the rest of the code
    
    
    
    
    
    
}
