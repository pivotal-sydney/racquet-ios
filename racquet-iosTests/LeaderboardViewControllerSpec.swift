import Foundation
import Quick
import Nimble
import SwiftyJSON
@testable import racquet_ios

class LeaderboardViewControllerSpec: QuickSpec {
    override func spec() {
        var controller: LeaderboardViewController?
        let fakeRestService: FakeRacquetRestService = FakeRacquetRestService()
        
        beforeEach() {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            controller = storyboard.instantiateViewControllerWithIdentifier("LeaderboardViewController") as? LeaderboardViewController
            
            let tabBarController  = storyboard.instantiateViewControllerWithIdentifier("ClubTabViewController") as! ClubTabViewController
            tabBarController.club = SwiftyJSON.JSON.parse("{\"slug\": \"club-slug\",\"name\": \"club-name\"}")
            tabBarController.addChildViewController(controller!)
            
            controller!.loadView()
            controller!.loadData(fakeRestService)
        }
 
        describe("on populate leaderboard") {
            it("should retrieve response") {
                expect(controller!.leaders).to(equal(fakeRestService.leaders))
            }
            
            it("numberOfRowsInSection matches the feed count") {
                let result = controller!.tableView(controller!.leaderboardTableView, numberOfRowsInSection: 1)
                expect(result).to(equal(4))
            }
            
            it("numberOfSectionsInTableView returns one") {
                let result = controller!.numberOfSectionsInTableView(controller!.leaderboardTableView!)
                expect(result).to(equal(1))
            }
            
            it("return Cell With label Attributes") {
             let cell = controller!.tableView(controller!.leaderboardTableView!, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as!LeaderboardMajorViewCell
                expect(cell.rankLabel.text).to(equal("1"))
                expect(cell.playerNameLabel.text).to(equal("Dylan Griffith"))
                expect(cell.winsLabel.text).to(equal("8 WINS"))
                expect(cell.lossesLabel.text).to(equal("6 LOSSES"))
                expect(cell.pointsLabel.text).to(equal("1180 pts"))
                
            }
            
            
            it("return cell with player image") {
            let cell = controller!.tableView(controller!.leaderboardTableView!, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as!LeaderboardMajorViewCell
            expect(cell.playerImage.frame.width) > 0
            }
        }
    }
}