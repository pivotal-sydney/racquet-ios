//
//  FeedViewController.swift
//  racquet-ios
//
//  Created by pivotal on 2/23/16.
//  Copyright © 2016 Pivotal. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    @IBOutlet weak var clubName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clubName.text = (self.tabBarController as? ClubTabViewController)?.clubName
    }
    
}
