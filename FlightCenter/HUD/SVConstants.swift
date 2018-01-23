//
//  SVConstants.swift
//
//  Created by Sudhakar Dasari on 04/07/17.
//  Copyright © 2017 Sudhakar Dasari. All rights reserved.
//

import UIKit

class SVConstants: NSObject {

    static let sharedInstance = SVConstants()
    
    typealias OtherButtonsAction = (_ action: UIAlertAction?, _ clickedAtIndex: CLong?) -> Void

    // MARK: - Create random string
    func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    // MARK: - Set Navigation Left button
    class func setNavigationLeftBarButton(_ leftBarBtnCliked: Selector, inView view: UIViewController) -> UIBarButtonItem {
        let barBtn = UIBarButtonItem()
        barBtn.image = UIImage(named: "ic_arrow_back_white.png")?.withRenderingMode(.alwaysOriginal)
        barBtn.target = view
        barBtn.action = leftBarBtnCliked
        return barBtn
    }
    
    // MARK: - show Message label on TableView
    class func setNavigationTitleViewWithTitle(_ title: String) -> UILabel {
        let lbNavTitle = UILabel(frame: CGRect(x: 0, y: 40, width: 320, height: 60))
        lbNavTitle.textAlignment = .left
        lbNavTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbNavTitle.numberOfLines = 2
        lbNavTitle.textColor = UIColor.white
        lbNavTitle.text = title
        return lbNavTitle
    }

    //MARK: - simple Alert
    func showAlert(title alertTitle:String ,message alertMessage:String,targetViewController: UIViewController){
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        targetViewController.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - show simple Alert Controller
    func showAlertView(title alerTitle:String ,message alertMessage:String, okLabel: String, cancelLabel: String, targetViewController: UIViewController,okHandler: ((UIAlertAction?) -> Void)!){
        
        let alertController = UIAlertController(title: alerTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: okLabel, style: .default, handler: okHandler)
        alertController.addAction(okAction)
        
        alertController.addAction(UIAlertAction(title: cancelLabel, style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        }))
        targetViewController.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - show Alert Controller with multiple buttons
    func showAlertControllerWithMultipleButtons(withTitle title: String, message: String, otherButtonsTitles: [Any], showCancelButton: Bool, cancelButtonTitle: String, showInview viewController: UIViewController, alertControllerStyle: UIAlertControllerStyle, otherButtonsAction: @escaping OtherButtonsAction) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: alertControllerStyle)
        
        //Add Multiple Actions
        for index in 0..<otherButtonsTitles.count {
            alertController.addAction(UIAlertAction(title: otherButtonsTitles[index] as? String, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                otherButtonsAction(action, index)
                alertController.dismiss(animated: true, completion: nil)
            }))
        }
        // Show Cancel
        if showCancelButton {
            alertController.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                alertController.dismiss(animated: true, completion: nil)
            }))
        }
        // Present Alert Controller
        viewController.present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: - show Alert Controller with multiple buttons and distructive button
    func showAlertControllerWithDestructiveButtonAndWithMultipleButtons(withTitle title: String, message: String, otherButtonsTitles: [Any], showCancelButton: Bool, cancelButtonTitle: String,destructiveButtonTitle: String, showInview viewController: UIViewController, alertControllerStyle: UIAlertControllerStyle, otherButtonsAction: @escaping OtherButtonsAction,destructiveHandler: ((UIAlertAction?) -> Void)!) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: alertControllerStyle)
        
        //Add Multiple Actions
        for index in 0..<otherButtonsTitles.count {
            alertController.addAction(UIAlertAction(title: otherButtonsTitles[index] as? String, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                otherButtonsAction(action, index)
                alertController.dismiss(animated: true, completion: nil)
            }))
        }
        // Show Cancel
        if showCancelButton {
            alertController.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                alertController.dismiss(animated: true, completion: nil)
            }))
        }
        let destructiveAction = UIAlertAction(title: destructiveButtonTitle, style: .destructive, handler: destructiveHandler)
        alertController.addAction(destructiveAction)
        
        // Present Alert Controller
        viewController.present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: - show Message label on TableView
    class func showAttributeMessageLabel(on tableview: UITableView, withMessageString message: String, andGestureAttributeString attributeString: String, withTapGestureAction gestureAction: Selector, showInView view: UIViewController) -> UILabel {
        
        let messageLbl = UILabel(frame: CGRect(x: CGFloat(tableview.bounds.size.width / 2), y: CGFloat(tableview.bounds.size.height / 2), width: CGFloat(tableview.bounds.size.width - 10), height: CGFloat(20)))
        messageLbl.textAlignment = .center
        messageLbl.font = UIFont.systemFont(ofSize: CGFloat(14))
        messageLbl.textColor = UIColor.gray
        messageLbl.numberOfLines = 0
        messageLbl.sizeToFit()
        messageLbl.isUserInteractionEnabled = true
        
        //Add Tapgesture
        let tapped = UITapGestureRecognizer(target: view, action: gestureAction)
        messageLbl.addGestureRecognizer(tapped)
        
        let range: NSRange = (message as NSString).range(of: attributeString)
        let string = NSMutableAttributedString(string: message)
        string.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: CGFloat(30 / 255.0), green: CGFloat(144 / 255.0), blue: CGFloat(255 / 255.0), alpha: CGFloat(1.0)), range: range)
        messageLbl.attributedText = string
        
        return messageLbl
    }
    class func showMessageLabel(on tableview: UITableView, withMessageString message: String) -> UILabel{
        
        let messageLbl = UILabel(frame: CGRect(x: CGFloat(tableview.bounds.size.width / 2), y: CGFloat(tableview.bounds.size.height / 2), width: CGFloat(tableview.bounds.size.width - 10), height: CGFloat(20)))
        messageLbl.textAlignment = .center
        messageLbl.font = UIFont.systemFont(ofSize: CGFloat(14))
        messageLbl.textColor = UIColor.gray
        messageLbl.numberOfLines = 0
        messageLbl.text = message
        messageLbl.sizeToFit()
        
        return messageLbl
    }

    //MARK:- Hide progressHUD
    class func hideHUD(){
        ACProgressHUD.shared.hideHUD()
    }
    
    //MARK:- Show progressHUD
    class func showHUD(){
        SVConstants.sharedInstance.initHUD()
        ACProgressHUD.shared.showHUD(withStatus: "")
    }
    
    //MARK:- Show progressHUD with title
    class func showHUD(withTitle title: String){
        SVConstants.sharedInstance.initHUD()
        ACProgressHUD.shared.showHUD(withStatus: title)
    }
    
    //MARK:- initilise progressHUD
    func initHUD(){
        ACProgressHUD.shared.dismissHudAnimation = .none
        ACProgressHUD.shared.showHudAnimation = .none

        //ACProgressHUD.shared.indicatorColor = .red
        //ACProgressHUD.shared.hudBackgroundColor = .clear
          ACProgressHUD.shared.shadowColor = .clear
        ACProgressHUD.shared.shadowRadius = 20.0
        ACProgressHUD.shared.cornerRadius = 20.0
        ACProgressHUD.shared.enableBackground = false
        //ACProgressHUD.shared.enableBlurBackground = true
        //ACProgressHUD.shared.blurBackgroundColor = .clear
        //ACProgressHUD.shared.progressTextColor = .black
        
    }
    
}
