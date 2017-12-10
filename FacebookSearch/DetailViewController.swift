//
//  DetailViewController.swift
//  FacebookSearch
//
//  Created by Xinzhe Li on 4/25/17.
//  Copyright © 2017 Xinzhe Li. All rights reserved.
//

import UIKit
import Toaster
import Foundation
import SwiftyJSON
import Alamofire
import SwiftSpinner
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit



class DetailViewController: UITabBarController, FBSDKSharingDelegate {
    var optionMenuController: UIAlertController = UIAlertController()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super .viewDidLoad()
        // Initial the option menu
        optionMenuController = UIAlertController(title: "Menu", message: "", preferredStyle: .actionSheet)
        //Favorite
        
        
            let favoriteTypeString = favoriteTypeFromResultToDetail
            let detailIdString = self.defaults.value(forKey: "detailId") as! String
        
            if(self.defaults.object(forKey: favoriteTypeString) != nil) {
                let userId = detailIdString
                // This user is in the array
                if(self.defaults.stringArray(forKey: favoriteTypeString)?.contains(userId))! {
                    let favoriteAction: UIAlertAction = UIAlertAction(title: "Remove from favorites", style: .default) { (action:UIAlertAction) in
                    var favoriteIdArray = self.defaults.stringArray(forKey: favoriteTypeString)
                    let idString = detailIdString
                    favoriteIdArray = favoriteIdArray?.filter { $0 != idString }
                    self.defaults.setValue(favoriteIdArray, forKey: favoriteTypeString)
                    }
                    optionMenuController.addAction(favoriteAction)
                    // The user is not in the array
                } else {
                    let favoriteAction: UIAlertAction = UIAlertAction(title: "Add to favorites", style: .default) { (action:UIAlertAction) in
                    var favoriteIdArray = self.defaults.stringArray(forKey: favoriteTypeString)
                    favoriteIdArray?.append(detailIdString)
                    self.defaults.setValue(favoriteIdArray, forKey: favoriteTypeString)
                    }
                    optionMenuController.addAction(favoriteAction)
                }
                // There isn't a favorite array in the user default
            } else {
                let favoriteAction: UIAlertAction = UIAlertAction(title: "Remove from favorites", style: .default) { (action:UIAlertAction) in
                var favoriteIdArray = [String]()
                favoriteIdArray.append(detailIdString)
                self.defaults.setValue(favoriteIdArray, forKey: favoriteTypeString)
                }
                optionMenuController.addAction(favoriteAction)
            }
        // fb
        let fbAction: UIAlertAction = UIAlertAction(title: "Share", style: .default) {
            action in
            
            let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
            content.contentTitle = "test"
            content.contentDescription = "FB Share for CSCI 571"
            content.imageURL = URL(string: userPictureFromResultToDetail)
            
            let dialog : FBSDKShareDialog = FBSDKShareDialog()
            dialog.fromViewController = self
            dialog.shareContent = content
            dialog.delegate = self
            dialog.mode = FBSDKShareDialogMode.feedBrowser
            if !dialog.canShow() {
                dialog.mode = FBSDKShareDialogMode.automatic
            }
            dialog.show()
            
//            let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
//            content.contentURL = NSURL(string: "http://scontent.xx.fbdn.net")! as URL
//            content.contentTitle = "Content Title"
//            content.contentDescription = "This is the description"
//            content.imageURL = URL(string: "./Assets.xcassets/favorite")
//            
////            let dialog : FBSDKShareDialog = FBSDKShareDialog()
////            dialog.fromViewController = self
////            dialog.shareContent = content
////            dialog.mode = FBSDKShareDialogMode.feedWeb
////            dialog.show()
//            
////            let dialog : FBSDKShareDialog = FBSDKShareDialog()
////            dialog.mode = FBSDKShareDialogMode.native
////            // if you don't set this before canShow call, canShow would always return YES
////            if !dialog.canShow() {
////                // fallback presentation when there is no FB app
////                dialog.mode = FBSDKShareDialogMode.shareSheet
////            }
//////            dialog.show()
//            FBSDKShareDialog.show(from: self, with: content, delegate: self, mode: FBSDKShareDialogMode.feedWeb)
        }

        optionMenuController.addAction(fbAction)
        
        
        
        //Create and add the "Cancel" action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .destructive) { action -> Void in
            //Just dismiss the action sheet
        }
        optionMenuController.addAction(cancelAction)
    }
    
    @IBAction func optionMenuTapped(_ sender: Any) {
        self.present(optionMenuController, animated: true, completion:nil)
    }
    
    /*!
     @abstract Sent to the delegate when the sharer is cancelled.
     @param sharer The FBSDKSharing that completed.
     */
    public func sharerDidCancel(_ sharer: FBSDKSharing!) {
        Toast(text: "Canceled!").show()
    }
    
    /*!
     @abstract Sent to the delegate when the sharer encounters an error.
     @param sharer The FBSDKSharing that completed.
     @param error The error.
     */
    public func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        Toast(text: "Error!").show()
    }
    
    /*!
     @abstract Sent to the delegate when the share completes without error or cancellation.
     @param sharer The FBSDKSharing that completed.
     @param results The results from the sharer.  This may be nil or empty.
     */
    public func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        if results != nil {
            Toast(text: "Shared!").show()
        } else {
            Toast(text: "Canceled!").show()
        }
    }
}
