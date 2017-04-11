//
//  MenuViewController.swift
//  ActiveBystander
//
//  Created by Ivor D. Addo, PhD on 2/26/17.
//  Copyright © 2017 Mallory McGinty. All rights reserved.
//

import UIKit
import Firebase


class MenuViewController: UIViewController {
    
    //Doesnt work..
    @IBAction func btnFakeCall(_ sender: AnyObject)
    {
        guard let number = URL(string: "tel:6088976667") else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    
    
    
    
    
    
}
