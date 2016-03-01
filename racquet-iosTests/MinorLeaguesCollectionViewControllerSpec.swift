import Foundation
import Quick
import Nimble
import SwiftyJSON
@testable import racquet_ios

class MinorLeaguesCollectionViewControllerSpec: QuickSpec {
    var controller: MinorLeaguesCollectionViewController?
    
    func loadMinors(response: SwiftyJSON.JSON?, success: Bool) {
        controller!.populateDatur(response!["minors"])
    }
    
    override func spec() {
        let fakeRestService: FakeRacquetRestService = FakeRacquetRestService()
        
        beforeEach() {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            self.controller = storyboard.instantiateViewControllerWithIdentifier("MinorLeaguesCollectionViewController") as? MinorLeaguesCollectionViewController
            self.controller!.loadView()
            fakeRestService.getLeaderboard("", callback: self.loadMinors)
        }
        
        describe("on populate minors") {
            it("should retrieve response") {
                expect(self.controller!.minors).to(equal(fakeRestService.leaders["minors"]))
                expect(self.controller!.minors.count).to(equal(12))
            }
            
            it("numberOfItemsInSection matches the minor count") {
                let result = Int(self.controller!.collectionView(self.controller!.collectionView!, numberOfItemsInSection: 1))
                let maxInRow = (Int((self.controller!.collectionView?.bounds.width)! - 100) / 50)
                expect(result) <= maxInRow
                expect(result) <= 12
                expect(result).to(equal(maxInRow) || equal(12))
            }

            it("numberOfSectionsInCollectionView returns one") {
                let result = self.controller!.numberOfSectionsInCollectionView(self.controller!.collectionView!)
                expect(result).to(equal(1))
            }
            
            it("returns cell with player image") {
                let cell = self.controller!.collectionView(self.controller!.collectionView!, cellForItemAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as!MinorLeaguesViewCell
                expect(cell.faceImage.frame.width) > 0
                expect(cell.faceImage.clipsToBounds) == true
            }
        }
    }
}