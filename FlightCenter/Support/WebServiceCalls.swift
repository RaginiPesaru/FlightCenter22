
//
//  WebServiceCalls.swift
//
//  Created by Ragini pasaru on 17/01/18.
//

import UIKit
import CoreData
import Alamofire
import SVProgressHUD

// server path

let kBasePath = "https://glacial-caverns-15124.herokuapp.com/flights/all"

class WebServiceCalls: NSObject {
    
    typealias CompletionBlock = (_ error: NSError?, _ response : AnyObject?) -> Void    
    // MARK: Master
    
    static func callWebservice(apiPath : String, method : HTTPMethod, header : [String : String], params : [String : Any], onSuccess : CompletionBlock? = nil) {
        
        let API_URL = "\(kBasePath)\(apiPath)"
        let webservice = String(format: "%@",API_URL)
        
        if CommonInstance.sharedInstance.hasConnectivity() == true {
            SVConstants.showHUD()
            Alamofire.request(webservice, method: method, parameters: params, headers: header).responseJSON { (response) in
                switch response.result {
                case .success(let resultValue):
                    SVConstants.hideHUD()
                    onSuccess!(nil,resultValue as AnyObject?)
                case .failure(let error):
                    SVConstants.hideHUD()
                    print("Error - \(error.localizedDescription)")
                    onSuccess!(error as NSError?,nil)
                    break
                }
            }
        }
        else {
            CommonInstance.sharedInstance.presentAlertWithTitle(title: "Alert", message: "No internet connection.", btnTitle: "Ok")
            print("Unable to create Reachability")
            return
        }
    }
}
