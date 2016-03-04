//
// Created by pivotal on 2/23/16.
// Copyright (c) 2016 Pivotal. All rights reserved.
//

import Foundation
import Quick
import Nimble
import SwiftyJSON
@testable import racquet_ios

class FeedViewControllerSpec: QuickSpec {
    override func spec() {
        var controller: FeedViewController?
        let fakeRestService: FakeRacquetRestService = FakeRacquetRestService()

        beforeEach() {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            controller = storyboard.instantiateViewControllerWithIdentifier("FeedViewController") as? FeedViewController

            let tabBarController  = storyboard.instantiateViewControllerWithIdentifier("ClubTabViewController") as! ClubTabViewController
            tabBarController.club = SwiftyJSON.JSON.parse("{\"slug\": \"club-slug\",\"name\": \"club-name\"}")
            tabBarController.addChildViewController(controller!)

            controller!.loadView()
            controller!.loadData(fakeRestService)
        }

        describe("on populate feed") {
            it("should retrieve response") {
                expect(controller!.matches).to(equal(fakeRestService.feed))
                expect(controller!.matches.count).to(equal(3))
                expect(controller!.matches[0]["loser"]["name"]).to(equal("loser-name-one"))
                expect(controller!.matches[0]["winner"]["name"]).to(equal("winner-name-one"))
            }

            it("numberOfRowsInSection matches the feed count") {
                let result = controller!.tableView(controller!.feedTableView, numberOfRowsInSection: 1)
                expect(result).to(equal(3))
            }

            it("numberOfSectionsInTableView returns one") {
                let result = controller!.numberOfSectionsInTableView(controller!.feedTableView!)
                expect(result).to(equal(1))
            }
        }
    }
}
