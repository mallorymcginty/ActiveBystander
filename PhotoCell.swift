//
//  PhotoCell.swift
//  ActiveBystander
//
//  Created by Ivor D. Addo, PhD on 4/14/17.
//  Copyright © 2017 Mallory McGinty. All rights reserved.
//

import UIKit
import Firebase

protocol btnDesc
{
    func btnDescAlert(alertTitle : String, message: String)
}



class PhotoCell: UICollectionViewCell
{
    
    var btnDescDelegate : btnDesc?
    var photos: [ImageUrlItem] = []
    var ref = FIRDatabase.database().reference(withPath: "Photos")
    
    
    @IBOutlet weak var imgPhoto: UIImageView!
    
    @IBOutlet weak var lblScore: UILabel!

    @IBAction func btnDesc(_ sender: UIButton)
    {
        let alertTitle = "Description"
        let alertMessage = photos.description
        
        btnDescDelegate?.btnDescAlert(alertTitle: alertTitle, message: alertMessage)
        
        
        
      /*  let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
            print("OK")
        }
        
        alertController.addAction(okAction)
        self.parentViewController?.present(alertController, animated: true, completion: nil)  */
    }
    
    
}

