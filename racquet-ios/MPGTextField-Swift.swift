//
//  MPGTextField-Swift.swift
//  MPGTextField-Swift
//
//  Created by Gaurav Wadhwani on 08/06/14.
//  Copyright (c) 2014 Mappgic. All rights reserved.
//

import UIKit

struct MPGTextFieldData {
    let title: String
    let detail: String
    let imageURLString: String?
}

protocol MPGTextFieldDelegate{
    func dataForPopoverInTextField(textfield: MPGTextField_Swift) -> [MPGTextFieldData]
    
    func textFieldDidEndEditing(textField: MPGTextField_Swift, withSelection data: MPGTextFieldData)
    func textFieldShouldSelect(textField: MPGTextField_Swift) -> Bool
}

class MPGTextField_Swift: UITextField, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    var mDelegate : MPGTextFieldDelegate?
    var tableViewController : UITableViewController?
    var data = [MPGTextFieldData]()
    
    //Set this to override the default color of suggestions popover. The default color is [UIColor colorWithWhite:0.8 alpha:0.9]
    @IBInspectable var popoverBackgroundColor : UIColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
    
    //Set this to override the default frame of the suggestions popover that will contain the suggestions pertaining to the search query. The default frame will be of the same width as textfield, of height 200px and be just below the textfield.
    @IBInspectable var popoverSize : CGRect?
    
    //Set this to override the default seperator color for tableView in search results. The default color is light gray.
    @IBInspectable var seperatorColor : UIColor = UIColor(white: 0.95, alpha: 1.0)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
    // Drawing code
    }
    */
    
    
    override func layoutSubviews(){
        super.layoutSubviews()
        let str : String = self.text!
        
        if (str.characters.count > 0 && self.isFirstResponder())
        {
            if (mDelegate != nil){
                data = mDelegate!.dataForPopoverInTextField(self)
                self.provideSuggestions()
            }
            else{
                print("<MPGTextField> WARNING: You have not implemented the requred methods of the MPGTextField protocol.")
            }
        }
        else{
            if let table = self.tableViewController{
                if table.tableView.superview != nil{
                    table.tableView.removeFromSuperview()
                    self.tableViewController = nil
                }
            }
        }
    }
    
    
    override func resignFirstResponder() -> Bool{
        if (self.tableViewController != nil) {
        UIView.animateWithDuration(0.3,
            animations: ({
                self.tableViewController!.tableView.alpha = 0.0
            }),
            completion:{
                (finished : Bool) in
                self.tableViewController!.tableView.removeFromSuperview()
                self.tableViewController = nil
        })
            
        }
        
        self.handleExit()
        return super.resignFirstResponder()
    }
    
    func provideSuggestions(){
        if let tvc = self.tableViewController {
            tvc.tableView.reloadData()
        }
        else if self.applyFilterWithSearchQuery(self.text!).count > 0{
            //Add a tap gesture recogniser to dismiss the suggestions view when the user taps outside the suggestions view
            let tapRecognizer = UITapGestureRecognizer(target: self, action: "tapped:")
            tapRecognizer.numberOfTapsRequired = 1
            tapRecognizer.cancelsTouchesInView = false
            tapRecognizer.delegate = self
            self.superview!.addGestureRecognizer(tapRecognizer)
            
            self.tableViewController = UITableViewController()
            self.tableViewController!.tableView.delegate = self
            self.tableViewController!.tableView.dataSource = self
            self.tableViewController!.tableView.backgroundColor = self.popoverBackgroundColor
            self.tableViewController!.tableView.separatorColor = self.seperatorColor
            self.tableViewController!.tableView.registerNib(UINib(nibName: "PlayerTableCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "cell")
            self.tableViewController!.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableViewController!.tableView.estimatedRowHeight = 70
            if let frameSize = self.popoverSize{
                self.tableViewController!.tableView.frame = frameSize
            }
            else{
                //PopoverSize frame has not been set. Use default parameters instead.
                var frameForPresentation = self.frame
                frameForPresentation.origin.y += self.frame.size.height
                frameForPresentation.size.height = 200
                self.tableViewController!.tableView.frame = frameForPresentation
            }
            
            var frameForPresentation = self.frame
            frameForPresentation.origin.y += self.frame.size.height;
            frameForPresentation.size.height = 200;
            tableViewController!.tableView.frame = frameForPresentation
            
            self.superview!.addSubview(tableViewController!.tableView)
            self.tableViewController!.tableView.alpha = 0.0
            UIView.animateWithDuration(0.3,
                animations: ({
                    self.tableViewController!.tableView.alpha = 1.0
                }),
                completion:{
                    (finished : Bool) in
                    
            })
        }
        
    }
    
    func tapped (sender : UIGestureRecognizer!){
        if let table = self.tableViewController{
            if !CGRectContainsPoint(table.tableView.frame, sender.locationInView(self.superview)) && self.isFirstResponder(){
                self.resignFirstResponder()
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let count = self.applyFilterWithSearchQuery(self.text!).count
        if count == 0{
            UIView.animateWithDuration(0.3,
                animations: ({
                    self.tableViewController!.tableView.alpha = 0.0
                }),
                completion:{
                    (finished : Bool) in
                    if let table = self.tableViewController{
                        table.tableView.removeFromSuperview()
                        self.tableViewController = nil
                    }
            })
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PlayerTableCell

        cell.backgroundColor = UIColor.clearColor()
        let data = self.applyFilterWithSearchQuery(self.text!)[indexPath.row]
        cell.playerLabel!.text = data.title
        cell.twitterLabel!.text = data.detail
        cell.playerImage.hnk_setImageFromURL(NSURL(string: data.imageURLString!)!, placeholder: UIImage(named: "mini-racquet"))

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let filtered = self.applyFilterWithSearchQuery(self.text!)
        let selectedRow = filtered[indexPath.row]
        self.text = selectedRow.detail
        print(self.text)
        self.resignFirstResponder()
    }
    
    
    //   #pragma mark Filter Method
    
    func applyFilterWithSearchQuery(filter : String) -> [MPGTextFieldData]
    {
        let filteredData = data.filter {
            return $0.title.lowercaseString.containsString(filter.lowercaseString) || $0.detail.lowercaseString.containsString(filter.lowercaseString)
        }
        return filteredData
    }
    
    func handleExit(){
        if let table = self.tableViewController{
            table.tableView.removeFromSuperview()
        }
        if self.applyFilterWithSearchQuery(self.text!).count > 0 {
            let selectedData = self.applyFilterWithSearchQuery(self.text!)[0]
            self.text = selectedData.detail
            mDelegate?.textFieldDidEndEditing(self, withSelection: selectedData)
        }
        else{
            mDelegate?.textFieldDidEndEditing(self, withSelection: MPGTextFieldData(title: self.text!, detail: "", imageURLString: nil))
        }

    }




}