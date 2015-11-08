//
//  PhotoReminderViewController.swift
//  NuMo_7_26
//
//  Created by Kathryn Manning on 7/26/15.
//  Copyright (c) 2015 kathrynmanning. All rights reserved.
//

import UIKit

class PhotoReminderViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageImage: UIImageView!

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        
        let photo = PhotoHelper()
        let path = photo.makeImagePath("1")
        imageImage.image = UIImage(contentsOfFile: path)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        
        //create action sheet
        let optionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        
        let photoLibraryOption = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) -> Void in
            print("from library")
            //shows the photo library
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .PhotoLibrary
            self.imagePicker.modalPresentationStyle = .Popover
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        let cameraOption = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) -> Void in
            print("take a photo")
            //shows the camera
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .Camera
            self.imagePicker.modalPresentationStyle = .Popover
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
        })
        let cancelOption = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancel")
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        optionSheet.addAction(photoLibraryOption)
        optionSheet.addAction(cancelOption)
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) == true {
            optionSheet.addAction(cameraOption)} else {
            print ("I don't have a camera.")
        }
        
        
        self.presentViewController(optionSheet, animated: true, completion: nil)
        
    }
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //handle media here i.e. do stuff with photo
        
        print("imagePickerController called")
        
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        //imageImage.image = chosenImage
        
        //save to database
        let intId = ModelManager.instance.addPhotoToDb()
        let stringId = String(intId)
        
        let photo = PhotoHelper()
        let path = photo.makeImagePath(stringId)
        photo.saveImage(chosenImage, path: path)
        
        let d = photo.loadImageFromPath(path)
        imageImage.image = d!
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    


}
