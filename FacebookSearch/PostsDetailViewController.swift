//
//  PostsDetailViewController.swift
//  FacebookSearch
//
//  Created by Xinzhe Li on 4/26/17.
//  Copyright © 2017 Xinzhe Li. All rights reserved.
//

import UIKit
import Toaster
import Foundation
import SwiftyJSON
import Alamofire
import SwiftSpinner

class PostsDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super .viewDidLoad()
        SwiftSpinner.show("Loading data...")
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        if(JSON.parse(self.defaults.value(forKey: "detailData") as! String)["posts"] == JSON.null) {
            self.tableView.isHidden = true
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            label.center = CGPoint(x: 160, y: 285)
            label.textAlignment = .center
            label.text = "No data found"
            self.view.addSubview(label)
        } else {
            self.tableView.reloadData()
        }
        SwiftSpinner.hide()

    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        if(self.defaults.object(forKey: "detailData") == nil) {
            return 0
        } else {
            return JSON.parse(self.defaults.value(forKey: "detailData") as! String)["posts"]["data"].count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postsDetails", for: indexPath) as! PostDetailCell
        cell.message.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.message.numberOfLines = 0
        Alamofire.request(userPictureFromResultToDetail).responseData { response in
            if let data = response.result.value{
               cell.userImage.image = UIImage(data: data)!
            }
        }
        
        if(JSON.parse(self.defaults.value(forKey: "detailData") as! String)["posts"]["data"][indexPath.row]["message"] != JSON.null) {
            cell.message.text = JSON.parse(self.defaults.value(forKey: "detailData") as! String)["posts"]["data"][indexPath.row]["message"].rawString()
        } else {
            cell.message.text = JSON.parse(self.defaults.value(forKey: "detailData") as! String)["posts"]["data"][indexPath.row]["story"].rawString()
        }
        
        
        return cell
    }
}
