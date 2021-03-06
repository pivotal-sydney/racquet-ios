import UIKit
import Alamofire
import SwiftyJSON
import Haneke

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var feedTableView: UITableView!

    var matches: SwiftyJSON.JSON = nil
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        progressIndicator.startAnimating()
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.feedTableView.addSubview(self.refreshControl)
    }

    func loadData(service: RacquetRestService = RealRacquetRestService()) {
        let slug = (self.tabBarController as? ClubTabViewController)?.club["slug"].string!
        service.getFeed(slug!, callback: recievedData)
    }

    func recievedData(response: SwiftyJSON.JSON?, success: Bool) {
        self.progressIndicator.stopAnimating()
        if((response) != nil) {
            self.matches = response!
            (self.tabBarController as? ClubTabViewController)?.feedDidLoad(response!)
            self.feedTableView.reloadData()
        }
    }

    override func viewDidAppear(animated: Bool) {
        loadData()
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

        loser_image.hnk_setImageFromURL(NSURL(string: self.matches[indexPath.row]["loser"]["profile_image_url"].string!)!, placeholder: UIImage(named: "mini-racquet"))
        winner_image.hnk_setImageFromURL(NSURL(string: self.matches[indexPath.row]["winner"]["profile_image_url"].string!)!, placeholder: UIImage(named: "mini-racquet"))
        
        return cell
    }
}
