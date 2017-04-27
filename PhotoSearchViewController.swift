//
//  PhotoSearchViewController.swift
//  geoMessenger
//
//  Created by Ivor D. Addo on 4/3/17.
//  Copyright © 2017 deHao. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage
import VisualRecognitionV3

class PhotoSearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let apiKey = "ce5c9a38c2dd1868be46cd7bff62d587e38aaef3"
    let version = "2017-21-2017" // plug-in today’s date here
    let watsonCollectionName = "PhotoCollection" // watson collection id
    var watsonCollectionId = "" // watson collection id
    
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
     var imgPhoto: UIImageView!
   
    
    var ref: FIRDatabaseReference!
    var existingImageUrls: [ImageUrlItem] = []
    var resultsImageUrls: [ImageUrlItem] = []
    var similarImageUrls: [ImageUrlItem] = []
    var newPhotoRecognitionURL: URL!
    var visualRecognition: VisualRecognition!
    let similarityScoreThrehold = 0.6 // change to see less/more accurate results
    let maxFirebaseImages: UInt = 15 // set maxmimum number of images to be used from firebase here
    var firstTimeSearch: Bool = true
    
    @IBAction func btnSearch(_ sender: UIButton) {
        
        self.btnSearch.isHidden = true // hide the upload button
        
        // MARK: Show an ActionSheet for picking the Photo or using the Camera
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        //#1
        let pickPhotoAction = UIAlertAction(title: "Pick from the Gallery", style: .default) { (alert: UIAlertAction!) in
            // STEP 1: MARK - pick the image
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
            {
                let imgPicker = UIImagePickerController()
                imgPicker.delegate = self
                imgPicker.sourceType = .photoLibrary
                imgPicker.allowsEditing = false
                // show the photoLibrary
                self.present(imgPicker, animated: true, completion: nil)
            }
            self.showButton()
        }
        
        //#2
        let takePhotoAction = UIAlertAction(title: "Take a Photo", style: .default) { (alert: UIAlertAction!) in
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                let imgPicker = UIImagePickerController()
                imgPicker.delegate = self
                imgPicker.sourceType = .camera
                imgPicker.allowsEditing = false
                // show the camera App
                self.present(imgPicker, animated: true, completion: nil)
            }
            self.showButton()
        }
        
        //#3 - use a cancel style with no action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction!) in
            // cancelled, show button and hide activity icon
            self.showButton()
        }
        
        //#4
        optionMenu.addAction(pickPhotoAction)
        optionMenu.addAction(takePhotoAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func showButton()
    {
        DispatchQueue.main.async {
                        self.btnSearch.isHidden = false // hide the upload button
        }
    }
    
    func hideButton()
    {
        DispatchQueue.main.async {
                        self.btnSearch.isHidden = true // hide the upload button
        }
    }
    
    // 2: create an instance variable
    var storageRef: FIRStorageReference!
    
    // 3: create a function for saving content to Firebase storage
    func configureStorage()
    {
        let storageUrl = FIRApp.defaultApp()?.options.storageBucket
        storageRef = FIRStorage.storage().reference(forURL: "gs://" + storageUrl!)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgPhoto.image = selectedImage
        } else {
            print("Something went wrong")
        }
        
        dismiss(animated:true, completion: nil)
        
        self.hideButton()
        
        // initialize
        existingImageUrls = []
        resultsImageUrls = []
        similarImageUrls = []
        
        collectionView.dataSource = self
        collectionView.reloadData()
        
        // if it's the first time, we won't show the no image found error
        self.firstTimeSearch = true
       // lblImageCaption.text = "Searching ..."
        
        performSearch()
    }
    
    
    func performSearch()
    {
        let imageData = UIImageJPEGRepresentation(imgPhoto.image!, 0.8) // compression quality
        let compressedJPEGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPEGImage!, nil, nil, nil)
        
        // save to Firebase Storage, overwrite existing image here
        let guid =  "search_image" // substitute with the current user's ID
        
        let imagePath = "\(guid)/\(guid).jpg"
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        self.storageRef.child(imagePath)
            .put(imageData!, metadata: metadata) {  (metadata, error) in
                if let error = error {
                    print("Error uploading: \(error)")
                    return
                }
                
                // STEP 2b: Get the image URL
                // limit the size of uploaded images to < 2MB
                self.newPhotoRecognitionURL = URL(string: (metadata?.downloadURL()?.absoluteString)!)!
                
                
                // STEP 3: MARK - get a list of previous imageUrls from Firebase
                // Ideally, this will be a batch submission but the SDK doesn't support it yet
                
                self.ref = FIRDatabase.database().reference()
                
                // get only the latest 15 photos for now
                self.ref.child("Photos").queryLimited(toLast: self.maxFirebaseImages)
                    .observe(.value, with: { snapshot in
                        
                        // loop through the children and append them to the new array
                        for dbItem in snapshot.children.allObjects {
                            let gItem = (snapshot: dbItem )
                            
                            // convert the snapshot JSON value to your Struct type
                            let newValue = ImageUrlItem(snapshot: gItem as! FIRDataSnapshot)
                            self.existingImageUrls.append(newValue)
                        }
                        
                        // STEP 4: MARK make call to API with
                        // MARK - CALL IBM Watson here
                        self.visualRecognition = VisualRecognition(apiKey: self.apiKey, version: self.version)
                        
                        // MARK - classify the curent Image
                        self.classifyImage()
                        
                        // MARK - create a collection; Create one-time via CURL or PostMan; gt the ID and use it
                        self.createCollection()
                        
                    })
        }
    }
    
    
    
    func createCollection()
    {
        // create a collection and find similar images
        self.visualRecognition.createCollection(withName: self.watsonCollectionName,
                                                failure: { (error) in
                                                    print("Collection Failed:  \(error)")
        },
                                                success: { (collection) in
                                                    self.watsonCollectionId = collection.collectionID
                                                    print("Collection Created:  \(collection.collectionID)")
                                                    
                                                    // MARK - Add images to the Watson collection
                                                    for existingImageUrlItem in self.existingImageUrls {
                                                        
                                                        print(existingImageUrlItem.imageUrl)
                                                        self.addCurrentImageToCollection(imageURL: URL(string: existingImageUrlItem.imageUrl)!)
                                                        
                                                    }
                                                    
                                                    // MARK - Find Similar Images
                                                    self.visualRecognition.findSimilarImages(toImageFile: self.newPhotoRecognitionURL!,
                                                                                             inCollectionID: self.watsonCollectionId,
                                                                                             limit: 9,
                                                                                             failure: { (searchError) in
                                                                                                DispatchQueue.main.async {
                                                                                                    // show alert of failure
                                                                                                    let ac = UIAlertController(title: "Watson Search Failed!", message:"Your photo search was not successful. Try again later. Error Code: \(searchError)", preferredStyle: .alert)
                                                                                                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                                                                                                    self.present(ac, animated: true)
                                                                                                }
                                                                                                //
                                                                                                print(searchError)
                                                                                                self.removeCollection()
                                                    },
                                                                                             success: { similarImageList in
                                                                                                // similar images were found
                                                                                                self.firstTimeSearch = false
                                                                                                
                                                                                                if let classifiedImage = similarImageList.similarImages.first
                                                                                                {
                                                                                                    // show score of first item
                                                                                                    print("Classification Score: \(classifiedImage.score!)")
                                                                                                    
                                                                                                    //  list is already sorted
                                                                                                    //similarImageList = similarImageList.similarImages.sorted(by: .score)
                                                                                                    var counter = 1
                                                                                                    // loop through the children and append them to the new array
                                                                                                    for similarImageItem in similarImageList.similarImages {
                                                                                                        
                                                                                                        // check if the image score is above the threshold
                                                                                                        if (similarImageItem.score! > self.similarityScoreThrehold){
                                                                                                            
                                                                                                            print("Classification Score: \(similarImageItem.score!)")
                                                                                                            
                                                                                                            for resultsImageItem in self.resultsImageUrls
                                                                                                            {
                                                                                                                if resultsImageItem.watsonCollectionImageUrl == similarImageItem.imageFile
                                                                                                                {
                                                                                                                    // convert the snapshot JSON value to your Struct type
                                                                                                                    let newValue = ImageUrlItem(imageUrl: resultsImageItem.imageUrl, key: String(counter), watsonCollectionImageUrl: similarImageItem.imageFile, score: similarImageItem.score!)
                                                                                                                    
                                                                                                                    print(newValue.imageUrl)
                                                                                                                    self.similarImageUrls.append(newValue)
                                                                                                                }
                                                                                                            }
                                                                                                            counter += 1
                                                                                                        }
                                                                                                    }
                                                                                                    
                                                                                                    // show images in collectionView
                                                                                                    DispatchQueue.main.async {
                                                                                                        self.showButton()
                                                                                                        self.collectionView.reloadData()
                                                                                                    }
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    DispatchQueue.main.async {
                                                                                                        // show alert of failure
                                                                                                        let ac = UIAlertController(title: "Photo Search Results", message:"No match was found", preferredStyle: .alert)
                                                                                                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                                                                                                        self.present(ac, animated: true)
                                                                                                    }
                                                                                                }
                                                                                                self.removeCollection()
                                                                                                self.showButton()
                                                    })
                                                    
                                                    // TODO:
                                                    print(self.similarImageUrls)
                                                    
        })
        
    }
    
    
    func removeCollection()
    {
        // create a collection and
        self.visualRecognition.deleteCollection(withID: self.watsonCollectionId)
        print("Collection Removed")
    }
    
    func addCurrentImageToCollection(imageURL: URL)
    {
        // create a collection and
        self.visualRecognition.addImageToCollection(withID: self.watsonCollectionId, imageFile: imageURL) { (colImages) in
            // number of images
            print("Images added: \(colImages.collectionImages.count)")
            
            // add images to new collection for display
            for existingItem in self.existingImageUrls
            {
                if String(describing: imageURL) == existingItem.imageUrl
                {
                    let newValue = ImageUrlItem(imageUrl: existingItem.imageUrl, key: String(colImages.collectionImages.count), watsonCollectionImageUrl: colImages.collectionImages[0].imageFile)
                    self.resultsImageUrls.append(newValue)
                }
            }
        }
    }
    
    
    func classifyImage()
    {
        // determine if IBM Watson call failed
        let failure = {(error:Error) in
            DispatchQueue.main.async {
                // show alert of failure
                let ac = UIAlertController(title: "Photo Search Failed!", message:"Your photo search was not successful. Try again later", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            }
            
            // for troubleshooting only
            print(error)
        }
        
        // classify the image to show classified verbiage about the image
        self.visualRecognition.classify(image: (self.newPhotoRecognitionURL?.absoluteString)!, failure: failure){
            classifiedImages in
            
            if let classifiedImage = classifiedImages.images.first
            {
                print(classifiedImage.classifiers)
                
                if (classifiedImage.classifiers.first?.classes.first?.classification) != nil {
                    
                    DispatchQueue.main.async {
                        // success: show the results in the title bar
                        
                    }
               }
            }
            else
            {
                DispatchQueue.main.async {
                    // show alert of failure
                    let ac = UIAlertController(title: "Photo Search Failed!", message:"Your photo search was not successful. Try again later", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
            }
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: { _ in })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstTimeSearch = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        
        configureStorage()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Set the number of items in your collection view - 9 max photos in this case
        return 9
    }
    
    
    //In order to access properties and methods in your Custom Cell Swift file, you will need to cast your cell to be of type, PhotoCell using as! PhotoCell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = "PhotoCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PhotoCell
        cell.backgroundColor = UIColor(red:0.96, green:0.97, blue:0.99, alpha:1.0)
        
        // Do any custom modifications you your cell, referencing the outlets you defined in the Custom cell file // if we have a label IBOutlet in PhotoCell we can customize it here
        
        // on page load when we have no search results, show nothing
        if similarImageUrls.count > 0 {
            
            //print(indexPath.row)
            //print(similarImageUrls.count)
            
            if (indexPath.row < similarImageUrls.count){
                
                let image = self.similarImageUrls[indexPath.row]
                
                // get image asynchronously via URL
                let url = URL(string: image.imageUrl)
                
                DispatchQueue.global().async {
                    // make an asynchonorous call to load the image
                    DispatchQueue.main.async {
                        cell.imgPhoto.af_setImage(withURL: url!) // show image using alamofire
                    }
                }
                cell.lblScore.isHidden = false
                cell.lblScore.text = "Score: \(NSString(format: "%.2f", (image.score * 100)) as String)%"
            }
            else
            {
                // show the placeholder image instead
                cell.imgPhoto.image = UIImage(named: "profile_photo")
                cell.lblScore.isHidden = true
                cell.lblScore.text = "0.00%"
            }
        }
        else
        {
            // show the placeholder image instead
            cell.imgPhoto.image = UIImage(named: "profile_photo")
            cell.lblScore.isHidden = true
            cell.lblScore.text = "0.00%"
            
            // when we get to the last image, and it is not the first time load
            if (indexPath.row == 8 && !firstTimeSearch){
                // show nothing found alert here
                let ac = UIAlertController(title: "Photo Search Completed!", message:"No macthing photo found!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            }
        }
        
        return cell
    }
    
}
