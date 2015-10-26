import UIKit

class Util: NSObject {
   
    //get path of document directory
    class func getPath(fileName: String) -> String
    {
        
        //return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0].stringByAppendingPathComponent(fileName)
        
        var v = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
     
        let x = v[0]
        
        let z = NSURL(fileURLWithPath: x).URLByAppendingPathComponent(fileName)
        
        return String(z)
        
        
        
//          examplel 1.2 to 2 swift
//        let writePath = NSTemporaryDirectory().stringByAppendingPathComponent("instagram.igo")
//        
//        let writePath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("instagram.igo")
        
        
    }
    
    //copy databse file .sqlite from project location to device location
    class func copyFile(fileName : NSString)
    {
        let dbPath : NSString = getPath(fileName as String)
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(dbPath as String)
        {
            print("File didnt already exist")
            let fromPath : String? = (NSBundle.mainBundle().resourcePath! as NSString).stringByAppendingPathComponent(fileName as String)
            do {
                try fileManager.copyItemAtPath(fromPath!, toPath: dbPath as String)
            } catch _ {
            }
        }
        else{print("File already existed")}
    }

}