//
// Created by pivotal on 2/23/16.
// Copyright (c) 2016 Pivotal. All rights reserved.
//

import Foundation
import SwiftyJSON
@testable import racquet_ios


struct FakeRacquetRestService: RacquetRestService {
    var json: SwiftyJSON.JSON
    init() {
        self.json = SwiftyJSON.JSON.parse("{}")
    }
    
    func getClubs(callback: (response: SwiftyJSON.JSON?, success: Bool) -> Void) {
        callback(response: json, success: true)
    }
}
