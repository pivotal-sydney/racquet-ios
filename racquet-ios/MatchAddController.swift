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
    var feed: JSON = nil

    @IBOutlet weak var winner: AutoCompleteTextField!
    @IBOutlet weak var loser: AutoCompleteTextField!

    @IBOutlet weak var winnerHeightConstraint: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = [String]()
        
        self.loser.autoCompleteStrings = data
        self.loser.maximumAutoCompleteCount = 10
        self.loser.onTextChange = {[weak self] text in
            let players = self!.getPlayersFromFeed().filter({(keyword:String) -> Bool in
                return keyword.containsString(text)
            })
            self!.loser.autoCompleteTableHeight = CGFloat(players.count) * self!.loser.autoCompleteCellHeight
            self!.loser.autoCompleteStrings = players
        }
        
        self.winner.onSelect = {[weak self] text in
            print(text)
//            self!.loser.text = text
            self!.winnerHeightConstraint.constant = 50
        }
        
        
        self.winner.autoCompleteStrings = data
        self.winner.maximumAutoCompleteCount = 10
        self.winner.onTextChange = {[weak self] text in
            let players = self!.getPlayersFromFeed().filter({(keyword:String) -> Bool in
                return keyword.containsString(text)
            })
            print(players)
            self!.winnerHeightConstraint.constant = 900
            print(players.count)
            self!.winner.autoCompleteTableHeight = CGFloat(players.count) * self!.winner.autoCompleteCellHeight
            self!.winner.autoCompleteStrings = players
        }

    }

    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func done(sender: AnyObject) {
        let service = RealRacquetRestService()
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

    func getPlayersFromFeed() -> [String] {
        var data = Set<String>()
        for match in self.feed {
            data.insert(match.1["winner"]["twitter_handle"].string!)
            data.insert(match.1["loser"]["twitter_handle"].string!)
        }
        
        return Array(data.sort())
    }
    
    func dismissKeyboard(){
        self.winner.resignFirstResponder()
        self.loser.resignFirstResponder()
    }
}