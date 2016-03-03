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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardNotification:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        winner.mDelegate = self
        loser.mDelegate = self
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
    
    func dataForPopoverInTextField(textfield: MPGTextField_Swift) -> [Dictionary<String, AnyObject>]
    {
        var sampleData = [Dictionary<String, AnyObject>]()
        let players = getPlayersFromFeed()
        for player in players {
            let dictionary = ["DisplayText": player,"DisplaySubText": "email","CustomObject": "content"]
            sampleData.append(dictionary)
        }
        return sampleData
    }

    func textFieldShouldSelect(textField: MPGTextField_Swift) -> Bool{
        return false
    }
    
    func textFieldDidEndEditing(textField: MPGTextField_Swift, withSelection data: Dictionary<String,AnyObject>){
        print("Dictionary received = \(data)")
    }

    
    func getPlayersFromFeed() -> [String] {
        var data = Set<String>()
        for match in self.feed {
            data.insert(match.1["winner"]["twitter_handle"].string!)
            data.insert(match.1["loser"]["twitter_handle"].string!)
        }
        
        return Array(data.sort())
    }
    
    
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrame?.origin.y >= UIScreen.mainScreen().bounds.size.height {
                //self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                //self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animateWithDuration(duration,
                delay: NSTimeInterval(0),
                options: animationCurve,
                animations: { self.view.layoutIfNeeded() },
                completion: nil)
        }
    }
}