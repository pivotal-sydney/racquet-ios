import UIKit
import Alamofire
import SwiftyJSON
import Haneke

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var clubName: UILabel!
    @IBOutlet weak var leaderboardTableView: UITableView!
    
    var leaders: SwiftyJSON.JSON = nil
    var refreshControl: UIRefreshControl!
    
    
    override func viewDidLoad() {

        super.viewDidLoad()

        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.leaderboardTableView.addSubview(self.refreshControl)
        

       self.leaderboardTableView.reloadData()

        clubName.text = (self.tabBarController as? ClubTabViewController)?.club["name"].string!
        
        loadData()
    }
   
    func loadData(service: RacquetRestService = RealRacquetRestService()) {
        let slug = (self.tabBarController as? ClubTabViewController)?.club["slug"].string!
        service.getLeaderboard(slug!, callback: recievedData)
    }
    
    func recievedData(response: SwiftyJSON.JSON?, success: Bool) {
        if((response) != nil) {
            self.leaders = response!
            self.leaderboardTableView.reloadData()
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
        return leaders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("leaderboardMajorCell", forIndexPath: indexPath) as!LeaderboardMajorViewCell
       
        let member = self.leaders["majors"][indexPath.row]["member"]
        
        cell.rankLabel!.text = String(indexPath.row + 1)
        cell.playerNameLabel!.text = member["name"].string
        cell.winsLabel!.text = String(member["wins"]) + " WINS"
        cell.lossesLabel!.text = String(member["losses"]) + " LOSSES"
        cell.pointsLabel!.text = String(member["points"]) + " pts"
        
        let player_image = cell.playerImage!
        player_image.layer.cornerRadius = player_image.frame.size.width / CGFloat(2)
        player_image.clipsToBounds = true
        player_image.hnk_setImageFromURL(NSURL(string: member["profile_image_url"].string!)!, placeholder: UIImage(named: "mini-racquet"))
        return cell
    }

}

