//
//  PhotoSearchExtension.swift
//  ActiveBystander
//
//  Created by Ivor D. Addo, PhD on 4/29/17.
//  Copyright © 2017 Mallory McGinty. All rights reserved.
//

import UIKit
import Firebase


extension PhotoSearchViewController
{
        
        func btnDecAlert(alertTitle: String, message: String) {
            
            let alert = UIAlertController(title: "your title ", message: "your description", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                
                // here is your action
                print("OK")
                
            })
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
