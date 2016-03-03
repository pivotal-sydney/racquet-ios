//
// Created by pivotal on 2/23/16.
// Copyright (c) 2016 Pivotal. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol RacquetRestService {
    func getClubs(callback: (response: SwiftyJSON.JSON?, success: Bool) -> Void) -> Void
    func getFeed(slug: String, callback: (response: SwiftyJSON.JSON?, success: Bool) -> Void) -> Void
    func addMatch(clubId: Int, winner: String, loser: String, callback: (success: Bool) -> Void) -> Void
    func getLeaderboard(slug: String, callback: (response: SwiftyJSON.JSON?, success: Bool) -> Void) -> Void
}

struct RealRacquetRestService : RacquetRestService {
    func getClubs(callback: (response: SwiftyJSON.JSON?, success: Bool) -> Void) {
        let url = "https://racquet-io.cfapps.io/api/clubs"
        retrieveData(url,callback: callback)
    }

    func getFeed(slug: String, callback: (response: SwiftyJSON.JSON?, success: Bool) -> Void) {
        let url = "https://racquet-io.cfapps.io/api/\(slug)/matches"
        retrieveData(url,callback: callback)
    }

    func getLeaderboard(slug: String, callback: (response: SwiftyJSON.JSON?, success: Bool) -> Void) {
        let url = "https://racquet-io.cfapps.io/api/\(slug)/leaderboard"
        retrieveData(url,callback: callback)
    }

    func retrieveData(url: String, callback: (response: SwiftyJSON.JSON?, success: Bool) -> Void) {
        Alamofire.request(.GET, url)
        .responseJSON {
            response in
            guard response.result.error == nil else {
                // got an error in getting the data, need to handle it
                print("error calling GET for: " + url)
                print(response.result.error!)
                callback(response: nil, success: false)
                return
            }
            if let value: AnyObject = response.result.value {
                let responseObject = JSON(value)
//                debugPrint(responseObject)
                callback(response: responseObject, success: true)
            }
        }
    }

    func addMatch(clubId: Int, winner: String, loser: String, callback: (success: Bool) -> Void) {
        let parameters = [
            "match": [
                "winner": winner,
                "loser": loser
            ]
        ]

        Alamofire.request(.POST, "https://racquet-io.cfapps.io/api/\(clubId)/matches", parameters: parameters, encoding: .JSON)
        .response {
            request, response, data, error in
            guard error == nil else {
                print("error calling POST on /api/\(clubId)/matches")
                print(error)
                callback(success: false)
                return
            }

            guard response?.statusCode == 201 else {
                print("Match failed to be added. Status code was: \(response?.statusCode).")
                callback(success: false)
                return
            }

            callback(success: true)
        }
    }
}
