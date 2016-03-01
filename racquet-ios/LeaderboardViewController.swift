import UIKit
import Alamofire
import SwiftyJSON
import Haneke

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var clubName: UILabel!
    @IBOutlet weak var leaderboardTableView: UITableView!
    @IBOutlet weak var minorLeagueView: UIView!
    
    var minorLeagueController: MinorLeaguesCollectionViewController?
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
        service.getLeaderboard(slug!, callback: receivedData)
    }
    
    func receivedData(response: SwiftyJSON.JSON?, success: Bool) {
        if((response) != nil) {
            self.leaders = response!
            self.leaderboardTableView.reloadData()
            //self.minorLeagueController!.view.clipsToBounds = false
            self.minorLeagueController?.populateDatur(self.leaders["minors"])
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
        return leaders["majors"].count
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
        var profileURL = ""
        if (member["profile_image_url"]){
          profileURL = member["profile_image_url"].string!
        }
        
        player_image.hnk_setImageFromURL(NSURL(string: profileURL)!, placeholder: UIImage(named: "mini-racquet"))
        return cell
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "MinorLeagueSegue") {
            self.minorLeagueController = segue.destinationViewController as? MinorLeaguesCollectionViewController
            self.addChildViewController(self.minorLeagueController!)

        }
    }
    
    override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
        return true
    }
    

    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return true
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        self.leaderboardTableView?.reloadData()
    }
}

