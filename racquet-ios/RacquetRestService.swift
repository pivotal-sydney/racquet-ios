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
}

struct RealRacquetRestService : RacquetRestService {
    func getClubs(callback: (response: SwiftyJSON.JSON?, success: Bool) -> Void) {
        Alamofire.request(.GET, "https://racquet-io.cfapps.io/api/clubs")
        .responseJSON {
            response in
            guard response.result.error == nil else {
                // got an error in getting the data, need to handle it
                print("error calling GET on /posts/1")
                print(response.result.error!)
                callback(response: nil, success: false)
                return
            }
            if let value: AnyObject = response.result.value {
                let responseObject = JSON(value)
                debugPrint(responseObject)
                callback(response: responseObject, success: true)
            }
        }
    }

    func getFeed(slug: String, callback: (response: SwiftyJSON.JSON?, success: Bool) -> Void) {
        let url = "https://racquet-io.cfapps.io/api/\(slug)/matches"

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
                debugPrint(responseObject)
                callback(response: responseObject, success: true)
            }
        }
    }
}
