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
    var feed: JSON = nil
    var matchAddController: MatchAddController?

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "add_match")
        {
            self.matchAddController = (segue.destinationViewController as! MatchAddController)
            (segue.destinationViewController as! MatchAddController).club = club

            if (self.feed != nil) {
                self.matchAddController!.feed = self.feed
            }
        }
    }
    
    func feedDidLoad(response: SwiftyJSON.JSON) {
        self.feed = response
        if (matchAddController != nil) {
            self.matchAddController!.feed = self.feed
        }
    }
    
}