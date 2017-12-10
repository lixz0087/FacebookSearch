//
//  albumsDetailViewController.swift
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


class albumsDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    let defaults = UserDefaults.standard
    var selectedIndexPath : IndexPath?
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
        SwiftSpinner.show("Loading data...")
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
        
        let url = "http://Sample-env-1.gs23njwudd.us-west-1.elasticbeanstalk.com/?id=" + (self.defaults.value(forKey: "detailId") as! String)
        Alamofire.request(url).responseJSON {  response in
            if let jsonTmp = response.result.value {
                var json = JSON(jsonTmp)
                self.defaults.setValue(json.rawString()!, forKey: "detailData")
                if(json["albums"] == JSON.null) {
                    self.tableView.isHidden = true
                    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
                    label.center = CGPoint(x: 160, y: 285)
                    label.textAlignment = .center
                    label.text = "No data found"
                    self.view.addSubview(label)
                } else {
                    self.tableView.reloadData()
                }
            }
            SwiftSpinner.hide()
        }
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        albumArray = [UIImage]()
        toExit()
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        if(self.defaults.object(forKey: "detailData") == nil) {
            return 0
        } else {
            return JSON.parse(self.defaults.value(forKey: "detailData") as! String)["albums"]["data"].count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumsDetails", for: indexPath) as! albumDetailCell
        cell.albumName.text = JSON.parse(self.defaults.value(forKey: "detailData") as! String)["albums"]["data"][indexPath.row]["name"].rawString()
        
//        let pictureURL = URL(string: "https://graph.facebook.com/v2.8/" + JSON.parse(self.defaults.value(forKey: "detailData") as! String)["albums"]["data"][indexPath.row]["photos"]["data"][0]["id"].rawString()! + "/picture?access_token=EAAClLA4E0DkBAEwzZAMntfW6GHSYkzYcvK392Rpy81yrgmuajTwE3wuomK1rwPu96vYh52CYI6OjmRBfH8zzu1ZCzCzSXN2OJIOcMgA8wUMXPZBqUYzNKHhBPnUTRXWJujaMajlpEQ3k9X3qrKuUZBPZCJqQAJh4ZD")
//        let pictureData = try? Data(contentsOf: pictureURL!) // nil
//        cell.picture1.image = UIImage(data: pictureData!)
        
        
        Alamofire.request("https://graph.facebook.com/v2.8/" + JSON.parse(self.defaults.value(forKey: "detailData") as! String)["albums"]["data"][indexPath.row]["photos"]["data"][0]["id"].rawString()! + "/picture?access_token=EAAClLA4E0DkBAEwzZAMntfW6GHSYkzYcvK392Rpy81yrgmuajTwE3wuomK1rwPu96vYh52CYI6OjmRBfH8zzu1ZCzCzSXN2OJIOcMgA8wUMXPZBqUYzNKHhBPnUTRXWJujaMajlpEQ3k9X3qrKuUZBPZCJqQAJh4ZD").responseData { response in
            if let data = response.result.value{
                if let pic = UIImage(data: data) {
                    cell.picture1.image = pic
                }
            }
        }
        if(JSON.parse(self.defaults.value(forKey: "detailData") as! String)["albums"]["data"][indexPath.row]["photos"]["data"].count == 1) {
            cell.picture2.isHidden = true
        } else {
//            let pictureURL2 = URL(string: "https://graph.facebook.com/v2.8/" + JSON.parse(self.defaults.value(forKey: "detailData") as! String)["albums"]["data"][indexPath.row]["photos"]["data"][1]["id"].rawString()! + "/picture?access_token=EAAClLA4E0DkBAEwzZAMntfW6GHSYkzYcvK392Rpy81yrgmuajTwE3wuomK1rwPu96vYh52CYI6OjmRBfH8zzu1ZCzCzSXN2OJIOcMgA8wUMXPZBqUYzNKHhBPnUTRXWJujaMajlpEQ3k9X3qrKuUZBPZCJqQAJh4ZD")
//            let pictureData2 = try? Data(contentsOf: pictureURL2!) // nil
//            cell.picture2.image = UIImage(data: pictureData2!)
            Alamofire.request("https://graph.facebook.com/v2.8/" + JSON.parse(self.defaults.value(forKey: "detailData") as! String)["albums"]["data"][indexPath.row]["photos"]["data"][1]["id"].rawString()! + "/picture?access_token=EAAClLA4E0DkBAEwzZAMntfW6GHSYkzYcvK392Rpy81yrgmuajTwE3wuomK1rwPu96vYh52CYI6OjmRBfH8zzu1ZCzCzSXN2OJIOcMgA8wUMXPZBqUYzNKHhBPnUTRXWJujaMajlpEQ3k9X3qrKuUZBPZCJqQAJh4ZD").responseData { response in
                if let data = response.result.value{
                    if let pic = UIImage(data: data) {
                        cell.picture2.image = pic
                    } else {
                        cell.picture2.isHidden = true
                    }
                    
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
        var indexPaths : Array<IndexPath> = []
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        if indexPaths.count > 0 {
            tableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! albumDetailCell).watchFrameChanges()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! albumDetailCell).ignoreFrameChanges()
    }
    
    func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        for cell in tableView.visibleCells as! [albumDetailCell] {
            cell.ignoreFrameChanges()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath as IndexPath == selectedIndexPath {
            return albumDetailCell.expandedHeight
        } else {
            return albumDetailCell.defaultHeight
        }
    }
    
    func toExit() {
        for cell in tableView.visibleCells as! [albumDetailCell] {
            cell.ignoreFrameChanges()
        }
    }
}
