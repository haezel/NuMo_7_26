//
//  PhotoHelper.swift
//  NuMo_7_26
//
//  Created by Kathryn Manning on 11/6/15.
//  Copyright © 2015 kathrynmanning. All rights reserved.
//

import Foundation

class PhotoHelper{
//    static func postRequest() -> [String:String] {
//        // do a post request and return post data
//        return ["someData" : "someData"]
//    }
    
    func saveImage (image: UIImage, path: String ) -> Bool{
        
        let pngImageData = UIImagePNGRepresentation(image)
        //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let result = pngImageData!.writeToFile(path, atomically: true)
        
        return result
        
    }
    
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        
        if image == nil {
            
            print("missing image at: (path)")
        }
        print("\(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
        
    }
    
    
    //----------Creating the image path----------//
    
    
    // Get the documents Directory
    
    private func getDocumentsURL() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }
    
    private func fileInDocumentsDirectory(filename: String) -> String {
        
        let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
        return fileURL.path!
        
    }
    
    // Define the specific path, image name
    func makeImagePath(imageName: String) -> String {
        let imagePath = fileInDocumentsDirectory(imageName)
        return imagePath
    }
    

}
