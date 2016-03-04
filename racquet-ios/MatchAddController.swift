//
//  MatchAddController.swift
//  racquet-ios
//
//  Created by pivotal on 2/25/16.
//  Copyright © 2016 Pivotal. All rights reserved.
//

import UIKit
import SwiftyJSON

class MatchAddController: UIViewController, MPGTextFieldDelegate {

    var club: JSON = nil
    var feed: JSON = nil

    @IBOutlet weak var winner: MPGTextField_Swift!
    @IBOutlet weak var loser: MPGTextField_Swift!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loserTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var winnerTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardNotification:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        winner.mDelegate = self
        loser.mDelegate = self
        
        winner.keyboardType = UIKeyboardType.Twitter
        loser.keyboardType = UIKeyboardType.Twitter
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
    
    func dataForPopoverInTextField(textfield: MPGTextField_Swift) -> [MPGTextFieldData]
    {
        return getPlayersFromFeed().map { player in
            MPGTextFieldData(title: player.name, detail: player.twitter_handle, imageURLString: player.image_url)
        }
    }

    func textFieldShouldSelect(textField: MPGTextField_Swift) -> Bool{
        return false
    }
    
    func textFieldDidEndEditing(textField: MPGTextField_Swift, withSelection data: MPGTextFieldData){
        print("Dictionary received = \(data.title)")
    }

    
    func getPlayersFromFeed() -> [Player] {
        var data = Set<Player>()
        for match in self.feed {
            let winner = match.1["winner"]
            data.insert(Player(name: winner["name"].string!, twitter_handle: winner["twitter_handle"].string!, image_url: winner["profile_image_url"].string!))

            let loser = match.1["loser"]
            data.insert(Player(name: loser["name"].string!, twitter_handle: loser["twitter_handle"].string!, image_url: loser["profile_image_url"].string!))
        }
        
        return Array(data.sort({ (lhs: Player, rhs: Player) -> Bool in
            return lhs.name < rhs.name
        }))
    }
    
    
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            if winner.isFirstResponder() {
                NSLayoutConstraint.activateConstraints([self.winnerTopConstraint])
                NSLayoutConstraint.deactivateConstraints([self.loserTopConstraint])
            }
            
            if loser.isFirstResponder() {
                NSLayoutConstraint.activateConstraints([self.loserTopConstraint])
                NSLayoutConstraint.deactivateConstraints([self.winnerTopConstraint])
            }
            
            if endFrame?.origin.y >= UIScreen.mainScreen().bounds.size.height {
                self.bottomConstraint?.constant = 0.0
            } else {
                let height = (endFrame?.size.height)!
                print(endFrame?.size.height)
                self.bottomConstraint?.constant = height ?? 0.0
            }
            UIView.animateWithDuration(duration,
                delay: NSTimeInterval(0),
                options: animationCurve,
                animations: { self.view.layoutIfNeeded() },
                completion: nil)
        }
    }
}