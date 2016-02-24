import UIKit
import Alamofire
import SwiftyJSON

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var clubName: UILabel!
    @IBOutlet weak var feedTableView: UITableView!
    
    private var matches: SwiftyJSON.JSON = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let slug = (self.tabBarController as? ClubTabViewController)?.club["slug"].string!
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! ClubFeedViewCell
    }

}
