import Foundation
import Quick
import Nimble
@testable import racquet_ios

class ClubCollectionViewControllerSpec: QuickSpec {
    override func spec() {
        var controller: ClubCollectionViewController?
        let fakeRestService: FakeRacquetRestService = FakeRacquetRestService()

        beforeEach() {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            controller = storyboard.instantiateViewControllerWithIdentifier("ClubCollectionViewController") as? ClubCollectionViewController
            controller!.loadView()
            controller!.populateDatur(fakeRestService)
        }

        describe("on populate clubs") {
            it("should retrieve response") {
                expect(controller!.clubs).to(equal(fakeRestService.clubs))
                expect(controller!.clubs["clubs"].count).to(equal(2))
                expect(controller!.clubs["clubs"][0]["slug"]).to(equal("test-slug1"))
            }

            it("numberOfItemsInSection matches the clubs count") {
                let result = controller!.collectionView(controller!.collectionView!, numberOfItemsInSection: 1)
                expect(result).to(equal(2))
            }

            it("numberOfSectionsInCollectionView returns one") {
                let result = controller!.numberOfSectionsInCollectionView(controller!.collectionView!)
                expect(result).to(equal(1))
            }
            
            it("sets club name on cell") {
                let result = controller!.collectionView(controller!.collectionView!, cellForItemAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! ClubViewCell
                expect(result.clubName.text).to(equal("test-name1"))
            }
        }
    }
}
