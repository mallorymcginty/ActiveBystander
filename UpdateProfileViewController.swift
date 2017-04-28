//
//  UpdateProfileViewController.swift
//  ActiveBystander
//
//  Created by Ivor D. Addo, PhD on 3/5/17.
//  Copyright © 2017 Mallory McGinty. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage


class UpdateProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtRace: UITextField!
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet weak var txtBuild: UITextField!
    @IBOutlet weak var txtHair: UITextField!
    @IBOutlet weak var txtEye: UITextField!
    

    
    @IBOutlet weak var btnSaveProf: UIButton!
    
    var storageRef: FIRStorageReference!
    
    
    let userNodeRef = FIRDatabase.database().reference().child("users")
    
    let storage = FIRStorage.storage()
    //let storageRef = FIRStorageReference!
    
    func configureStorage()
    {
    let storageUrl = FIRApp.defaultApp()?.options.storageBucket
    storageRef = FIRStorage.storage().reference(forURL: "gs://" + storageUrl!)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureStorage()
        
        txtDOB.delegate = self
        txtDOB.tag = 0
        
        txtGender.delegate = self
        txtGender.tag = 1
        
        txtRace.delegate = self
        txtRace.tag = 2
        
        txtHeight.delegate = self
        txtHeight.tag = 3
        
        txtBuild.delegate = self
        txtBuild.tag = 4
        
        txtHair.delegate = self
        txtHair.tag = 5
        
        txtEye.delegate = self
        txtEye.tag = 6
        
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.25
        profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        
    }

    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    
    
    
    
    
    

    @IBAction func btnSaveProf(_ sender: Any)
    {
        if let DoB = txtDOB.text, let gender = txtGender.text, let RaceEth = txtRace.text, let height = txtHeight.text, let build = txtBuild.text, let hair = txtHair.text, let eyes = txtEye.text
        {
            let user = FIRAuth.auth()?.currentUser
            
            let userValues = ["DoB": DoB, "gender": gender, "race": RaceEth, "height": height, "build": build, "hair color": hair, "eye color": eyes]
            self.userNodeRef.child((user?.uid)!).updateChildValues(userValues, withCompletionBlock: {(userDBError, userDBRef) in
            })
            
        }
        
            // get the image in the imageView and save it to the Photo Album
            let imageData = UIImageJPEGRepresentation(profileImageView.image!, 0.8) // compression quality
            let compressedJPEGImage = UIImage(data: imageData!)
            UIImageWriteToSavedPhotosAlbum(compressedJPEGImage!, nil, nil, nil)
            
            // save to Firebase Storage - to current user?
            //let guid =  "test_id" // substitute with the current user's ID
            
            let guid = UUID().uuidString // STEP 1: Generate new UUID
            
            
            let imagePath = "\(guid)/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            self.storageRef.child(imagePath)
                .put(imageData!, metadata: metadata) {  (metadata, error) in
                    if let error = error
                    {
                        print("Error uploading: \(error)")
                        return
                    }
                    
                    // STEP 2b: Get the image URL
                    let imageUrl = metadata?.downloadURL()?.absoluteString
                    
                    // STEP 3: Add code to save the imageURL to the Realtime database
                    var ref: FIRDatabaseReference!
                    ref = FIRDatabase.database().reference()
                    
                    let imageNode : [String : String] = ["ImageUrl": imageUrl!]
                    
                    // add to the Firebase JSON node for MyUsers
                    ref.child("users").childByAutoId().setValue(imageNode)
            
        }
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "userInfo")
        self.present(vc!, animated: true, completion: nil)
        
    }

    
    
    


    @IBAction func btnUploadProf(_ sender: UIButton)
    {
        //saving to FB and show in the profileImageView
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.sourceType = .photoLibrary
            imgPicker.allowsEditing = true
            
            self.present(imgPicker, animated: true, completion: nil)
        }
        
    }

        
       
        //Error with datatype - think I fixed it unable to test
    func  imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) 
        {
            if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            {
                profileImageView.image = selectedImage
                
            } else
            {
                print("Something went wrong")
            }
            
            dismiss(animated:true, completion: nil)
    
       
 
    }
 
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: { _ in })
    }
 
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
        txtDOB.resignFirstResponder()
        txtGender.resignFirstResponder()
        txtRace.resignFirstResponder()
        txtHeight.resignFirstResponder()
        txtBuild.resignFirstResponder()
        txtHair.resignFirstResponder()
        txtEye.resignFirstResponder()
    }
    

 
 
 
    
    @IBAction func btnLogout(_ sender: AnyObject)
    {
        try! FIRAuth.auth()?.signOut()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "login")
        self.present(vc!, animated: true, completion: nil)
    }
  


}

