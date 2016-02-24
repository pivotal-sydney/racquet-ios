//
// Created by pivotal on 2/23/16.
// Copyright (c) 2016 Pivotal. All rights reserved.
//

import Foundation
import SwiftyJSON
@testable import racquet_ios


class FakeRacquetRestService: RacquetRestService {
    var clubs: SwiftyJSON.JSON

    var clubJsonString: String

    init() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let path = bundle.pathForResource("sample_club_json", ofType: "json")
        do {
            try clubJsonString = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        } catch {
            clubJsonString = "{}"
        }

        self.clubs = SwiftyJSON.JSON.parse(clubJsonString)
    }
    
    func getClubs(callback: (response: SwiftyJSON.JSON?, success: Bool) -> Void) {
        callback(response: clubs, success: true)
    }
}
