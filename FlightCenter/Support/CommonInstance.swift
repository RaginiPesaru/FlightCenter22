//
//  File.swift
//  APICallingAlamofireDemo
//
//  Created by Ragini pasaru on 17/01/18.
//

import Foundation
import DGActivityIndicatorView
import AVFoundation
import SystemConfiguration
import SDWebImage

class CommonInstance {
    typealias CompletionBlock = (_ error: NSError?, _ response : AnyObject?) -> Void
    
    var window : UIWindow?
    
    class var sharedInstance: CommonInstance {
        let instance = CommonInstance()
        return instance
    }
    
    // Check internet connectivity
    func hasConnectivity() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired
        
        return isReachable && !needsConnection
        
    }
    
    // Alert With Title
    func presentAlertWithTitle(title: String, message : String, btnTitle : String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: btnTitle, style: .default) {
            (action: UIAlertAction) in
        }
        alertController.addAction(OKAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}


