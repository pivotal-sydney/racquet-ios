//
//  ClubsViewController.swift
//  racquet-ios
//
//  Created by pivotal on 2/25/16.
//  Copyright © 2016 Pivotal. All rights reserved.
//

import UIKit


class ClubsViewController: UIViewController {
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
}

