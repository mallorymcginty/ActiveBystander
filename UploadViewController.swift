//
//  UploadViewController.swift
//  ActiveBystander
//
//  Created by Ivor D. Addo, PhD on 4/18/17.
//  Copyright © 2017 Mallory McGinty. All rights reserved.
//

import UIKit
import Firebase


class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var txtPhotoDesc: UITextView!
    
    
    
    
    var storageRef: FIRStorageReference!
    var ref = FIRDatabaseReference()
    
    func configureStorage()
    {
        let storageUrl = FIRApp.defaultApp()?.options.storageBucket
        storageRef = FIRStorage.storage().reference(forURL: "gs://" + storageUrl!)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureStorage()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imgPhoto.image = selectedImage
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

    
    
    
    
    @IBAction func btnUploadImg(_ sender: UIButton)
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.sourceType = .photoLibrary
            imgPicker.allowsEditing = true // allow users to crop , etc.
            // show the photoLibrary
            self.present(imgPicker, animated: true, completion: nil)
        }

    }
    
    
    @IBAction func btnSavePhoto(_ sender: UIBarButtonItem)
    {
        // get the image in the imageView and save it to the Photo Album
        let imageData = UIImageJPEGRepresentation(imgPhoto.image!, 0.8) // compression quality
        let compressedJPEGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPEGImage!, nil, nil, nil)
        
        // save to Firebase Storage
        //let guid =  "test_id" // substitute with the current user's ID
        
        let guid = UUID().uuidString // STEP 1: Generate new UUID
        
        
        let imagePath = "\(guid)/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        self.storageRef.child(imagePath)
            .put(imageData!, metadata: metadata) {  (metadata, error) in
                if let error = error {
                    print("Error uploading: \(error)")
                    return
                }
                
                // STEP 2b: Get the image URL
                let imageUrl = metadata?.downloadURL()?.absoluteString
                
                // STEP 3: Add code to save the imageURL to the Realtime database
                var ref: FIRDatabaseReference!
                ref = FIRDatabase.database().reference()
                
                let imageNode : [String : String] = ["ImageUrl": imageUrl!,
                                                     "Description": self.txtPhotoDesc.text!]
                
                print(imageNode)
                // add to the Firebase JSON node for MyUsers
                ref.child("Photos").childByAutoId().setValue(imageNode) /**/
        
        }
              
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "search")
        self.present(vc!, animated: true, completion: nil)
 
        
    }
 
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
        
        txtPhotoDesc.resignFirstResponder()
    }

    
    
    
    

   
}


//Should this be its own thing similar to Alert and Incident?


class Photo: NSObject
{
    let photoDescription: String?
   // let imgPhoto: UIImage
    
    init(photoDescription: String)
    {
        self.photoDescription = photoDescription
       // self.imgPhoto = imgPhoto
        
        super.init()
    }
    
    
    
}
