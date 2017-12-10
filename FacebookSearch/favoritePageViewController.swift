//
//  favoritePageViewController.swift
//  FacebookSearch
//
//  Created by Xinzhe Li on 4/21/17.
//  Copyright © 2017 Xinzhe Li. All rights reserved.
//

import UIKit
import Toaster
import Foundation
import SwiftyJSON
import Alamofire
import SwiftSpinner

class favoritePageViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let defaults = UserDefaults.standard
    let favoriteTypeString = "favoritePage"
    let typeString = "pageFavoriteData"
    let cellType = "pageFavoriteCell"
    
    var pictureUrl: String = ""
    
    @IBAction func favoriteButtonTapped(button: UIButton) {
        var favoriteIdArray: [String] = self.defaults.stringArray(forKey: favoriteTypeString)!
        favoriteIdArray.remove(at: button.tag)
        self.defaults.setValue(favoriteIdArray, forKey: favoriteTypeString)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        SwiftSpinner.show("Loading data...")
        // This is important! To connect the tableView with the DataSource
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height + 44 + 18)
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        SwiftSpinner.hide()
    }
    
    override func viewDidLayoutSubviews(){
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height + 44 + 18)
        tableView.reloadData()
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return (self.defaults.stringArray(forKey: favoriteTypeString)?.count)!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath) as! FaPageTableViewCell
        let favoriteIdArray = self.defaults.stringArray(forKey: favoriteTypeString)
        
        
            Alamofire.request("https://graph.facebook.com/v2.8/" + (favoriteIdArray?[indexPath.row])! + "?fields=id,name,picture.width(700).height(700)&access_token=EAAClLA4E0DkBAEwzZAMntfW6GHSYkzYcvK392Rpy81yrgmuajTwE3wuomK1rwPu96vYh52CYI6OjmRBfH8zzu1ZCzCzSXN2OJIOcMgA8wUMXPZBqUYzNKHhBPnUTRXWJujaMajlpEQ3k9X3qrKuUZBPZCJqQAJh4ZD").responseJSON {  response in
                
                if let jsonTmp = response.result.value {
                    let json = JSON(jsonTmp)
                    cell.username.text = json["name"].rawString()
                    self.pictureUrl = json["picture"]["data"]["url"].rawString()!
                    Alamofire.request(json["picture"]["data"]["url"].rawString()!).responseData { response in
                        if let data = response.result.value{
                            cell.userPhoto.image = UIImage(data: data)!
                        }
                    }
                }
            }
        
        cell.favorite.setImage(#imageLiteral(resourceName: "filled"), for: UIControlState.normal)
        cell.favorite.tag = indexPath.row
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetails", sender: indexPath);
        let favoriteIdArray = self.defaults.stringArray(forKey: favoriteTypeString)
        self.defaults.setValue((favoriteIdArray?[indexPath.row])!, forKey: "detailId")
        favoriteTypeFromResultToDetail = favoriteTypeString
        userPictureFromResultToDetail = self.pictureUrl
    }
}
