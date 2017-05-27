////
////  AlamofireClient.swift
////  QA Social
////
////  Created by PaditechDev1 on 7/1/16.
////  Copyright © 2016 Paditech. All rights reserved.
////
//
////import Alamofire
//import SwiftyJSON
//
//@objc class AlamofireClient: NSObject {
//    
//    // Instance object
//    static let sharedInstance = AlamofireClient()
//    var baseURL: String!
//    var manager: Manager!
//    var isShowingAlert = false
//    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
//    
////    var accessToken: String? {
////        get {
////            return Utilities.shareManager.getObject("ACCESS_TOKEN") != nil ? (Utilities.shareManager.getObject("ACCESS_TOKEN") as? String) : ""
////        }
////        
////        set {
////            if let _ = Utilities.shareManager.getObject("ACCESS_TOKEN") as? String {
////                // already exist access token
////            } else {
////                self.getAccessToken({ (status, statusCode, data) in
////                    // write code here
////                })
////            }
////        }
////    }
//    
//    override init() {
//        super.init()
//        
//        baseURL = Constants.kBaseURL + Constants.kVersion
//        
//        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
//        configuration.timeoutIntervalForRequest = Constants.kTimeoutIntervalForRequest
//        manager = Alamofire.Manager(configuration: configuration)
//        
//        // implement NetworkReachabilityManager
//        reachabilityManager?.listener = { status in
//            switch status {
//            case .NotReachable:
//                // show error state
//                self.showAlertConnection(Constants.LANGTEXT("MESSAGE_FAILURE_ERROR"))
//                
//                break
//            case .Reachable(_), .Unknown:
//                // Hide error state
//                
//                break
//            }
//        }
//        reachabilityManager?.startListening()
//    }
//    
//    /**
//     show a alert view
//     
//     - parameter message: message of alert view
//     */
//    func showAlertConnection(message: String) {
//        if isShowingAlert {
//            return
//        }
//        
//        isShowingAlert = true
//        
//        let alertController = UIAlertController(title: "ERROR", message: message, preferredStyle: .Alert)
//        
//        let okAction = UIAlertAction(title: "OK", style:.Default) { (action) in
//            self.isShowingAlert = false
//        }
//        alertController.addAction(okAction)
//       
//        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
//    }
//    
//    // MARK: - Show alert when use feature require login action
//    func ShowAlertRequireLogin() {
//        
//        let alertViewController = UIAlertController(title: "", message: Constants.LANGTEXT("MESSAGE_REQUIRE_LOGIN"), preferredStyle: .Alert)
//        let okAction = UIAlertAction(title: Constants.LANGTEXT("OK"), style: .Default) { (action) -> Void in
//            
//            // redirect to login view
////            let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
////            TabbarController.sharedIntance.navigationController!.pushViewController(loginVC, animated: true)
//        }
//        
//        let cancelAction = UIAlertAction(title: Constants.LANGTEXT("CANCEL"), style: .Default) { (action) -> Void in
//            
//            alertViewController.dismissViewControllerAnimated(true, completion: nil)
//        }
//        // Present alert controler
//        alertViewController.addAction(okAction)
//        alertViewController.addAction(cancelAction)
////        TabbarController.sharedIntance.presentViewController(alertViewController, animated: true, completion: nil)
//    }
//    
//    func checkResultAPI(uri: String, dataReturn: JSON) -> Bool{
//        
//        let resultCode = dataReturn["api_result"]["result"].int
//        
//        if resultCode != nil {
//            
//            if resultCode == 1 {
//                
//                return true
//            } else if resultCode == 99 {
//                
//                return false
//            } else {
//                
//                // Show alert result
//                let keyError = "API_RESULT_" + uri.uppercaseString + String(format: "_%d", resultCode!)
//                
//                let alertController = UIAlertController(title: Constants.LANGTEXT("ERROR"), message: Constants.LANGTEXT(keyError), preferredStyle: .Alert)
//                
//                let okAction = UIAlertAction(title: "OK", style:.Default) { (action) in
//                   
//                    
//                }
//                alertController.addAction(okAction)
//                
//                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
//                
//                return false
//            }
//            
//        } else {
//            
//            return false
//        }
//        
//    }
//    
//    /**
//     Handle failure error API
//     */
//    func processFailureError() {
//        self.showAlertConnection(Constants.LANGTEXT("MESSAGE_FAILURE_ERROR"))
//    }
//    
//    // MARK: - Service main func
//    
//    /**
//     create GET Request
//     
//     - parameter urlString:         the url string for request
//     - parameter parameters:        parameters are involved in request
//     - parameter completionHandler: a closure
//     */
//    func GET(urlString: String, parameters: [String : AnyObject]?, completionHandler: CompletionHandler1) -> () {
//        if reachabilityManager!.isReachable == false {
//            // show error state
//            self.showAlertConnection(Constants.LANGTEXT("MESSAGE_FAILURE_ERROR"))
//            
//            return
//        }
//        
//        //let getURL: String = baseURL + urlString
//        manager.request(.GET, urlString, parameters: parameters, encoding: .URL, headers: nil).validate().responseJSON { (response) in
//            switch response.result {
//            case .Failure(let error):
//                
//                self.processFailureError()
//                completionHandler(false, 0, error)
//                break
//            case .Success:
//                if let value = response.result.value {
//                    if self.checkResultAPI(urlString, dataReturn: JSON(value)) {
//                        
//                        print("Result: \(JSON(value))")
//                        completionHandler(true, 200, value)
//                    } else {
//                        
//                        completionHandler(false, 0, response.result.error)
//                    }
//                    
//                    
//                } else {
//                    
//                    completionHandler(false, 0, response.result.error)
//                }
//                
//                break
//            }
//        }
//    }
//    
//    /**
//     create POST Request
//     
//     - parameter urlString:         the url string for request
//     - parameter parameters:        parameters are involved in request
//     - parameter completionHandler: a closure
//     */
//    func POST(urlString: String, parameters: [String : AnyObject]?, completionHandler: CompletionHandler1) -> () {
//        if reachabilityManager!.isReachable == false {
//            // show error state
//            self.showAlertConnection(Constants.LANGTEXT("MESSAGE_FAILURE_ERROR"))
//            
//            return
//        }
//        
//        let getURL: String = baseURL + urlString
//        
//        print("URI: \(urlString) \n Params:\n \(parameters) ")
//        manager.request(.POST, getURL, parameters: parameters, encoding: .URL, headers: nil).validate().responseJSON { (response) in
//            switch response.result {
//            case .Failure(let error):
//                
//                self.processFailureError()
//                completionHandler(false, 0, error)
//                break
//            case .Success:
//                if let value = response.result.value {
//                    if self.checkResultAPI(urlString, dataReturn: JSON(value)) {
//                        
//                        print("Result post: \(JSON(value))")
//                        completionHandler(true, 200, value)
//                    } else {
//                        
//                        completionHandler(false, 0, response.result.error)
//                    }
//                    
//                    
//                } else {
//                    
//                    completionHandler(false, 0, response.result.error)
//                }
//                
//                break
//            }
//            
//        }
//    }
//    
//    func getAccessToken(completionHandler: CompletionHandler1) -> () {
//        let getURL: String = baseURL + "initAccessToken"
//        
//        manager.request(.POST, getURL, parameters: nil, encoding: .JSON, headers: nil).validate().responseJSON { (response) in
//            switch response.result {
//            case .Failure(let error):
//                completionHandler(false, 0, error)
//                
//                break
//            case .Success:
//                if let aJson = response.result.value {
//                    let json = JSON(aJson)
//                    print(json["datas"]["access_token"])
////                    Utilities.shareManager.setObject(json["datas"]["access_token"].string, key: "ACCESS_TOKEN")
//                    
//                    completionHandler(true, 200, aJson)
//                } else {
//                    completionHandler(false, 0, response.result.error)
//                }
//                
//                break
//            }
//        }
//    }
//    
////    func checkAccessToken(completionHandler: CompletionHandler1) -> () {
////        
////        AlamofireClient.sharedInstance.POST("checkAccessToken", parameters: ["access_token": AlamofireClient.sharedInstance.accessToken!]) { (status, statusCode, data) in
////            
////            
////            if status == true {
////                let json = JSON(data!)
////                print("\(json)")
////                // If not a Array or nil, return []
////                let userJSON: JSON = json["datas"]["user"]
////                let user: UserNormal = UserNormal(json: userJSON)
////                
////                completionHandler(true, statusCode, user)
////            } else {
////                completionHandler(false, statusCode, data)
////            }
////        }
////    }
//
//    
////    func saveAccessToken(access_token: String) {
////        
////         Utilities.shareManager.setObject(access_token, key: "ACCESS_TOKEN")
////    }
////    
////    func clearAccessToken() {
////        Utilities.shareManager.deleteObject("ACCESS_TOKEN")
////    }
//    
//    /// ///////////////////////////////////////
//    /**
//     create upload request
//     
//     - parameter urlString:         the url string for request
//     - parameter parameters:        parameters are involved in request
//     - parameter completionHandler: a closure
//     */
//    func upload(urlString: String, parameters: [String : AnyObject]?, imageData: NSData?, completionHandler: CompletionHandler1) -> () {
//        if reachabilityManager!.isReachable == false {
//            // show error state
//            self.showAlertConnection(Constants.LANGTEXT("MESSAGE_ERROR_INTERNET_CONNECTION"))
//            
//            return
//        }
//        
//        let getURL: String = baseURL + urlString
//        
//        Alamofire.upload(.POST, getURL, multipartFormData: {
//            multipartFormData in
//            if  let data = imageData {
//                multipartFormData.appendBodyPart(data: data, name: "profile_image", fileName: "file.png", mimeType: "image/png")
//            }
//            for (key, value) in parameters! {
//                var dataArg: NSData?
//                print("Key: \(key) - dvalue: \(value)")
//                
//                if var intValue = value as? Int {
//                    dataArg = NSData(bytes: &intValue, length: sizeof(Int))
//                } else {
//                    dataArg = value.dataUsingEncoding(NSUTF8StringEncoding)
//                }
//                
//                multipartFormData.appendBodyPart(data: dataArg!, name: key)
//            }
//            }, encodingCompletion: {
//                encodingResult in
//                
//                switch encodingResult {
//                
//                case .Success(let upload, _, _):
//                    print("s")
//                    upload.progress{ (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in // This doesn't seem to work... can we do this?
//                        print("Total byte writen: \(totalBytesWritten)")
//                    }
//                    upload.responseJSON { response in
//                        print(response.request)  // original URL request
//                        print(response.response) // URL response
//                        print(response.data)     // server data
//                        print(response.result)   // result of response serialization
//                        
//                        if let value = response.result.value {
//                            if self.checkResultAPI(urlString, dataReturn: JSON(value)) {
//                                
//                                completionHandler(true, 200, value)
//                            } else {
//                                
//                                completionHandler(false, 0, response.result.error)
//                            }
//                            
//                            
//                        } else {
//                            
//                            self.processFailureError()
//                            completionHandler(false, 0, response.result.error)
//                        }
//                        
//                    }
//                    
//                    break
//                    
//                case .Failure(let encodingError):
//                    
//                    self.processFailureError()
//                    completionHandler(false, 0, encodingError as? AnyObject)
//                    break
//                    
//                }
//                
//        })
//    }
//    
//       
//}
