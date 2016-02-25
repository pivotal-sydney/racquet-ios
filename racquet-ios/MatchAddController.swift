//
//  MatchAddController.swift
//  racquet-ios
//
//  Created by pivotal on 2/25/16.
//  Copyright © 2016 Pivotal. All rights reserved.
//

import UIKit
import SwiftyJSON

class MatchAddController: UIViewController {

    var club: JSON = nil

    @IBOutlet weak var winner: UITextField!
    @IBOutlet weak var loser: UITextField!
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func done(sender: AnyObject) {
        let service = RealRacquetRestService()
        print(winner.text)
        print(loser.text)
        print(club["id"].int!)
        service.addMatch(club["id"].int!, winner: winner.text!, loser: loser.text!, callback: onAddMatch)
    }
    
    func onAddMatch(success: Bool) {
        if success {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Oops!", message:"Something went wrong. Please check the Twitter handles and try again.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        }
    }
}