//
//  SearchViewController.swift
//  FacebookSearch
//
//  Created by Xinzhe Li on 4/17/17.
//  Copyright © 2017 Xinzhe Li. All rights reserved.
//

import UIKit
import Toaster
import Foundation
import SwiftyJSON
import Alamofire

var searchString: String = ""
var favoriteTypeFromResultToDetail: String = ""
var userPictureFromResultToDetail: String = ""
var albumArray = [UIImage]()

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class SearchViewController: UIViewController {
    @IBOutlet weak var searchInput: UITextField!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super .viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.defaults.removeObject(forKey:"userData")
        self.defaults.removeObject(forKey:"pageData")
        self.defaults.removeObject(forKey:"eventData")
        self.defaults.removeObject(forKey:"placeData")
        self.defaults.removeObject(forKey:"groupData")
    }
    
    @IBAction func searchButtonTapped() {
        guard let text = searchInput.text, !text.isEmpty else {
            Toast(text: "Enter a vaild query!").show()
            return
        }
        self.performSegue(withIdentifier: "toTabBarController", sender: self)
        searchString = text
    }
    
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        self.searchInput.text = ""
    }
}
