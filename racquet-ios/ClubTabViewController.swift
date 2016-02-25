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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "add_match")
        {
            (segue.destinationViewController as! MatchAddController).club = club
        }
    }
}