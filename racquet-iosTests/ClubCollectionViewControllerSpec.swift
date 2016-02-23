//
// Created by pivotal on 2/23/16.
// Copyright (c) 2016 Pivotal. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import racquet_ios

class ClubCollectionViewControllerSpec: QuickSpec {
    override func spec() {
        var controller: ClubCollectionViewController?
        beforeEach() {
            var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            controller = storyboard.instantiateViewControllerWithIdentifier("ClubCollectionViewController") as! ClubCollectionViewController
            controller!.loadView()
        }
        describe("on populate clubs") {
            it("should retrieve response") {
                let fakeRestService = FakeRacquetRestService()
                controller!.populateDatur(fakeRestService)
                expect(controller!.clubs).to(equal(fakeRestService.json))
            }
        }
    }
}
