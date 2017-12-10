//
//  UserViewController.swift
//  FacebookSearch
//
//  Created by Xinzhe Li on 4/18/17.
//  Copyright © 2017 Xinzhe Li. All rights reserved.
//

import UIKit
import Toaster
import Foundation
import SwiftyJSON
import Alamofire
import SwiftSpinner

class UserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    let typeString = "userData"
    let favoriteTypeString = "favoriteUser"
    
    override func viewDidLoad() {
        super .viewDidLoad()
        SwiftSpinner.show("Loading data...")
        self.tableView.isHidden = true
        let textUrl = searchString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url = "http://Sample-env-1.gs23njwudd.us-west-1.elasticbeanstalk.com/?keyword=" + textUrl!
        Alamofire.request(url).responseData  { response in
            
            if let data = response.result.value{
            let json = JSON(data)
            //            print(json["user"])
            self.defaults.setValue(json["user"].rawString()!, forKey: "userData")
            self.defaults.setValue(json["page"].rawString()!, forKey: "pageData")
            self.defaults.setValue(json["event"].rawString()!, forKey: "eventData")
            self.defaults.setValue(json["place"].rawString()!, forKey: "placeData")
            self.defaults.setValue(json["group"].rawString()!, forKey: "groupData")
            
            //            print(type(of: JSON.parse(self.defaults.value(forKey: "userData") as! String)["data"][0]["name"]))
            if(JSON.parse(self.defaults.value(forKey: self.typeString) as! String)["paging"]["previous"] == JSON.null) {
                self.previousButton.isEnabled = false
            }
            if(JSON.parse(self.defaults.value(forKey: self.typeString) as! String)["paging"]["next"] == JSON.null) {
                self.nextButton.isEnabled = false
            }
            self.tableView.isHidden = false
            self.tableView.reloadData()
            SwiftSpinner.hide()
            }
        }
        tableView.dataSource = self
        tableView.delegate = self
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        

        tableView.tableFooterView = UIView()
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height + 44 + 18)

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    

    
    
    @IBAction func favoriteButtonTapped(button: UIButton) {
        // There is a favorite array in the user default
        if(self.defaults.object(forKey: favoriteTypeString) != nil) {
            let userId = JSON.parse(self.defaults.value(forKey: self.typeString) as! String)["data"][button.tag]["id"].rawString()
            // This user is in the array
            if(self.defaults.stringArray(forKey: favoriteTypeString)?.contains(userId!))! {
                var favoriteIdArray = self.defaults.stringArray(forKey: favoriteTypeString)
                let idString = JSON.parse(self.defaults.value(forKey: self.typeString) as! String)["data"][button.tag]["id"].rawString()!
                favoriteIdArray = favoriteIdArray?.filter { $0 != idString }
                self.defaults.setValue(favoriteIdArray, forKey: favoriteTypeString)
                button.setImage(#imageLiteral(resourceName: "empty"), for: UIControlState.normal)
                // The user is not in the array
            } else {
                var favoriteIdArray = self.defaults.stringArray(forKey: favoriteTypeString)
                favoriteIdArray?.append(JSON.parse(self.defaults.value(forKey: self.typeString) as! String)["data"][button.tag]["id"].rawString()!)
                self.defaults.setValue(favoriteIdArray, forKey: favoriteTypeString)
                button.setImage(#imageLiteral(resourceName: "filled"), for: UIControlState.normal)
            }
            // There isn't a favorite array in the user default
        } else {
            var favoriteIdArray = [String]()
            favoriteIdArray.append(JSON.parse(self.defaults.value(forKey: self.typeString) as! String)["data"][button.tag]["id"].rawString()!)
            self.defaults.setValue(favoriteIdArray, forKey: favoriteTypeString)
            button.setImage(#imageLiteral(resourceName: "filled"), for: UIControlState.normal)
        }
    }
    
    @IBAction func prevPageButton(button: UIButton) {
        Alamofire.request(JSON.parse(self.defaults.value(forKey: self.typeString) as! String)["paging"]["previous"].rawString()!).responseJSON { response in
            //            debugPrint(response)
            
            if let jsonTmp = response.result.value {
                let json = JSON(jsonTmp)
                self.defaults.setValue(json.rawString()!, forKey: self.typeString)
            }
            self.tableView.reloadData()
            self.tableView.frame = CGRect(x: self.tableView.frame.origin.x, y: self.tableView.frame.origin.y, width: self.tableView.frame.size.width, height: self.tableView.contentSize.height + 44 + 18)
            if(JSON.parse(self.defaults.value(forKey: self.typeString) as! String)["paging"]["previous"] == JSON.null) {
                self.previousButton.isEnabled = false
            } else {
                self.previousButton.isEnabled = true
            }
            
            if(JSON.parse(self.defaults.value(forKey: self.typeString) as! String)["paging"]["next"] == JSON.null) {
                self.nextButton.isEnabled = false
            } else {
                self.nextButton.isEnabled = true
            }
        }
    }
    
    @IBAction func nextPageButton(button: UIButton) {
        Alamofire.request(JSON.parse(self.defaults.value(forKey: self.typeString) as! String)["paging"]["next"].rawString()!).responseJSON { response in
            //            debugPrint(response)
            
            if let jsonTmp = response.result.value {
                let json = JSON(jsonTmp)
                self.defaults.setValue(json.rawString()!, forKey: self.typeString)
            }
            self.tableView.reloadData()
            self.tableView.frame = CGRect(x: self.tableView.frame.origin.x, y: self.tableView.frame.origin.y, width: self.tableView.frame.size.width, height: self.tableView.contentSize.height + 44 + 18)
            if(JSON.parse(self.defaults.value(forKey: self.typeString) as! String)["paging"]["previous"] == JSON.null) {
                self.previousButton.isEnabled = false
            } else {
                self.previousButton.isEnabled = true
            }
            
            if(JSON.parse(self.defaults.value(forKey: self.typeString) as! String)["paging"]["next"] == JSON.null) {
                self.nextButton.isEnabled = false
            } else {
                self.nextButton.isEnabled = true
            }
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews(){
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height + 44 + 18)
        tableView.reloadData()
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        if(self.defaults.object(forKey: self.typeString) == nil) {
            return 10
        } else {
            return JSON.parse(self.defaults.value(forKey: self.typeString) as! String)["data"].count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell
        if(self.defaults.object(forKey: self.typeString) != nil) {
        cell.username.text = JSON.parse(self.defaults.value(forKey: self.typeString) as! String)["data"][indexPath.row]["name"].rawString()
        let urlString = JSON.parse(self.defaults.value(forKey: self.typeString) as! String)["data"][indexPath.row]["picture"]["data"]["url"].rawString()!
        Alamofire.request(urlString).responseData { response in
            if let data = response.result.value{
                cell.userPhoto.image = UIImage(data: data)!
            }
        }
        
        let userId = JSON.parse(self.defaults.value(forKey: self.typeString) as! String)["data"][indexPath.row]["id"].rawString()
        
        if(self.defaults.object(forKey: self.favoriteTypeString) != nil && (self.defaults.stringArray(forKey: self.favoriteTypeString)?.contains(userId!))!) {
            cell.favorite.setImage(#imageLiteral(resourceName: "filled"), for: UIControlState.normal)
        } else {
            cell.favorite.setImage(#imageLiteral(resourceName: "empty"), for: UIControlState.normal)
        }
        cell.favorite.tag = indexPath.row
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetails", sender: indexPath);
        if(self.defaults.object(forKey: self.typeString) != nil) {
        self.defaults.setValue(JSON.parse(self.defaults.value(forKey: self.typeString) as! String)["data"][indexPath.row]["id"].rawString()!, forKey: "detailId")
        favoriteTypeFromResultToDetail = favoriteTypeString
        userPictureFromResultToDetail = JSON.parse(self.defaults.value(forKey: self.typeString) as! String)["data"][indexPath.row]["picture"]["data"]["url"].rawString()!
        }
    }
}