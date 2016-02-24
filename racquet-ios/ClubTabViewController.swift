//
//  ClubViewController.swift
//  racquet-ios
//
//  Created by pivotal on 2/23/16.
//  Copyright © 2016 Pivotal. All rights reserved.
//


import UIKit
import SwiftyJSON

class ClubTabViewController: UITabBarController {
    
    var club: JSON = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}