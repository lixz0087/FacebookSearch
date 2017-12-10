//
//  AboutMe.swift
//  FacebookSearch
//
//  Created by Xinzhe Li on 4/27/17.
//  Copyright © 2017 Xinzhe Li. All rights reserved.
//

import UIKit

class AboutMe: UIViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
}
