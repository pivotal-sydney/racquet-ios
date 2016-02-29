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
        }
        
        describe("on load") {
            it("should populate club name") {
                controller!.viewDidLoad()
                expect(controller!.clubName.text).to(equal("club-name"))
            }
        }

    }
}