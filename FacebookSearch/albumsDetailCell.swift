//
//  albumsDetailCell.swift
//  FacebookSearch
//
//  Created by Xinzhe Li on 4/22/17.
//  Copyright © 2017 Xinzhe Li. All rights reserved.
//

import UIKit
import Toaster
import Foundation
import SwiftyJSON
import Alamofire
import SwiftSpinner

class albumDetailCell: UITableViewCell {
    var isObserving = false;
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var picture1: UIImageView!
    @IBOutlet weak var picture2: UIImageView!
    
    class var expandedHeight: CGFloat { get { return 400 } }
    class var defaultHeight: CGFloat  { get { return 44  } }
    
    func checkHeight() {
        if (frame.size.height < albumDetailCell.expandedHeight) {
            picture1.isHidden = true
            picture2.isHidden = true
        }
    }
    
    func watchFrameChanges() {
        if !isObserving {
            addObserver(self, forKeyPath: "frame", options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.initial], context: nil)
            isObserving = true;
        }
    }
    
    func ignoreFrameChanges() {
        if isObserving {
            removeObserver(self, forKeyPath: "frame")
            isObserving = false;
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
    
//    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//        if keyPath == "frame" {
//            checkHeight()
//        }
//    }
}
