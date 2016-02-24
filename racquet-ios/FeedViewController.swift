import UIKit
import Alamofire
import SwiftyJSON
import Haneke

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var clubName: UILabel!
    @IBOutlet weak var feedTableView: UITableView!
    
    private var matches: SwiftyJSON.JSON = nil
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.feedTableView.addSubview(self.refreshControl) // not required when using UITableViewController
        
        clubName.text = (self.tabBarController as? ClubTabViewController)?.club["name"].string!
        
        loadData()
    }
    
    func loadData() {
        let clubTabViewController = self.tabBarController as? ClubTabViewController
        let slug = clubTabViewController?.club["slug"].string!
        let url = "https://racquet-io.cfapps.io/api/\(slug!)/matches"
        
        Alamofire.request(.GET, url)
            .responseJSON {
                response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print(response.result.error!)
                    return
                }
                if let value: AnyObject = response.result.value {
                    let responseObject = JSON(value)
                    debugPrint(responseObject)
                    self.matches = responseObject
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.feedTableView.reloadData()
                    return
                })
        }
    }
    
    func refresh(sender:AnyObject) {
        loadData()
        self.refreshControl.endRefreshing()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! ClubFeedViewCell
        cell.loserLabel!.text = self.matches[indexPath.row]["loser"]["name"].string
        cell.winnerLabel!.text = self.matches[indexPath.row]["winner"]["name"].string
        
        let loser_image = cell.loserImage!
        let winner_image = cell.winnerImage!
        
        //must be a better way to do rounding
        loser_image.layer.cornerRadius = loser_image.frame.size.width / CGFloat(2)
        loser_image.clipsToBounds = true
        
        winner_image.layer.cornerRadius = loser_image.frame.size.width / CGFloat(2)
        winner_image.clipsToBounds = true
        
        loser_image.hnk_setImageFromURL(NSURL(string: self.matches[indexPath.row]["loser"]["profile_image_url"].string!)!, placeholder: UIImage(named: "mini-racquet"))
        winner_image.hnk_setImageFromURL(NSURL(string: self.matches[indexPath.row]["winner"]["profile_image_url"].string!)!, placeholder: UIImage(named: "mini-racquet"))
        return cell
    }

}
