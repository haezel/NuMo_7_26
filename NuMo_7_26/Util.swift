import UIKit

class Util: NSObject {
   
    //get path of document directory
    class func getPath(fileName: String) -> String
    {
        
        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0].stringByAppendingPathComponent(fileName)
    }
    
    //copy databse file .sqlite from project location to device location
    class func copyFile(fileName : NSString)
    {
        var dbPath : NSString = getPath(fileName as String)
        var fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(dbPath as String)
        {
            println("File didnt already exist")
            var fromPath : String? = NSBundle.mainBundle().resourcePath?.stringByAppendingPathComponent(fileName as String)
            fileManager.copyItemAtPath(fromPath!, toPath: dbPath as String, error: nil)
        }
        else{println("File already existed")}
    }

}