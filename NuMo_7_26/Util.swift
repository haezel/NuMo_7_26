import UIKit

class Util: NSObject {
   
    //get path of document directory
    class func getPath(fileName: String) -> String
    {
        
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documentsURL.URLByAppendingPathComponent(fileName)
        return fileURL.path!
        
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
                alert.title = "Success"
                alert.message = "Database Copied Successfully"
            }
            alert.delegate = nil
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
        
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