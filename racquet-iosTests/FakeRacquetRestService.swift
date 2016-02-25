//
// Created by pivotal on 2/23/16.
// Copyright (c) 2016 Pivotal. All rights reserved.
//

import Foundation
import SwiftyJSON
@testable import racquet_ios


class FakeRacquetRestService: RacquetRestService {

    var clubs: SwiftyJSON.JSON!
    var feed: SwiftyJSON.JSON!
    
    init() {
        self.clubs = loadJsonData("sample_club_json")
        self.feed = loadJsonData("sample_feed_json")
    }
    
    func loadJsonData(filename: String) -> SwiftyJSON.JSON {
        var jsonString: String
        let bundle = NSBundle(forClass: self.dynamicType)
        let path = bundle.pathForResource(filename, ofType: "json")
        do {
            try jsonString = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        } catch {
            jsonString = "{}"
        }

        return SwiftyJSON.JSON.parse(jsonString)
    }
    
    func getClubs(callback: (response: SwiftyJSON.JSON?, success: Bool) -> Void) {
        callback(response: clubs, success: true)
    }

    func getFeed(slug: String, callback: (response: SwiftyJSON.JSON?, success: Bool) -> Void) {
        callback(response: feed, success: true)
    }

    func getLeaderboard(slug: String, callback: (response: SwiftyJSON.JSON?, success: Bool) -> Void) {
        callback(response: nil, success: false)
    }

    func addMatch(clubId: Int, winner: String, loser: String, callback: (success: Bool) -> Void) {
        callback(success: false)
    }
}
