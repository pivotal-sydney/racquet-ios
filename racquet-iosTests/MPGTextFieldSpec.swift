import Quick
import Nimble

@testable import racquet_ios

class MPGTextFieldSpec: QuickSpec {
    override func spec() {
        var subject: MPGTextField_Swift!
        beforeEach {
            subject = MPGTextField_Swift(frame: CGRect.zero)

            subject.data = [
                MPGTextFieldData(title: "test", detail: "testDetail", imageURLString: "https://example.com")
            ]
            subject.text = "t"

            let view = UIView()
            view.addSubview(subject)

            subject.provideSuggestions()
        }

        it("cellForRowAtIndex returns our custom cell") {

            expect(subject.tableView(subject.tableViewController!.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))).to(beAKindOf(PlayerTableCell.self))
        }

        it("cellForRowAtIndex contains correct data") {
            let cell = subject.tableView(subject.tableViewController!.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! PlayerTableCell

            expect(cell.playerLabel.text) == "test"
            expect(cell.twitterLabel.text) == "testDetail"
            expect(cell.playerImage.image).toNot(beNil())
        }
    }
}