import UIKit

class Util: NSObject {
   
    //get path of document directory
    class func getPath(fileName: String) -> String
    {
        
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documentsURL.URLByAppendingPathComponent(fileName)
        return fileURL.path!
        
//        
//        
//        
//        
//        
//        //return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0].stringByAppendingPathComponent(fileName)
//        
//        var v = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
//     
//        let x = v[0]
//        
//        let z = NSURL(fileURLWithPath: x).URLByAppendingPathComponent(fileName)
//        
//        return String(z)
//        
//        
//        
////          examplel 1.2 to 2 swift
////        let writePath = NSTemporaryDirectory().stringByAppendingPathComponent("instagram.igo")
////        
////        let writePath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("instagram.igo")
        
        
    }
    
    //copy databse file .sqlite from project location to device location
    class func copyFile(fileName : NSString)
    {
        let dbPath: String = getPath(fileName as String)
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(dbPath) {
            let documentsURL = NSBundle.mainBundle().resourceURL
            let fromPath = documentsURL!.URLByAppendingPathComponent(fileName as String)
            var error : NSError?
            do {
                try fileManager.copyItemAtPath(fromPath.path!, toPath: dbPath)
            } catch let error1 as NSError {
                error = error1
            }
            let alert: UIAlertView = UIAlertView()
            if (error != nil) {
                alert.title = "Error Occured"
                alert.message = error?.localizedDescription
            } else {
                alert.title = "Successfully Copy"
                alert.message = "Your database copy successfully"
            }
            alert.delegate = nil
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
        
        
        
        
//        
//        let dbPath : NSString = getPath(fileName as String)
//        let fileManager = NSFileManager.defaultManager()
//        if !fileManager.fileExistsAtPath(dbPath as String)
//        {
//            print("File didnt already exist")
//            let fromPath : String? = (NSBundle.mainBundle().resourcePath! as NSString).stringByAppendingPathComponent(fileName as String)
//            do {
//                try fileManager.copyItemAtPath(fromPath!, toPath: dbPath as String)
//            } catch _ {
//            }
//        }
//        else{print("File already existed")}
    }
    
    
    
    class func invokeAlertMethod(strTitle: NSString, strBody: NSString, delegate: AnyObject?)
    {
        let alert: UIAlertView = UIAlertView()
        alert.message = strBody as String
        alert.title = strTitle as String
        alert.delegate = delegate
        alert.addButtonWithTitle("Ok")
        alert.show()
    }

}