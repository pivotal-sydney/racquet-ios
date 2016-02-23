import UIKit
import Alamofire
import SwiftyJSON
import Haneke

class ClubCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let reuseIdentifier = "ClubViewCell"
    var clubs: SwiftyJSON.JSON = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.delegate? = self
        populateDatur()
    }

    func populateDatur(service: RacquetRestService = RealRacquetRestService()) {
        service.getClubs(onGetClubs);
    }

    func onGetClubs(response: SwiftyJSON.JSON?, success: Bool) {
        if success {
            self.clubs = response!
            self.collectionView!.reloadData()
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ClubViewCell
        cell.backgroundColor = UIColor.whiteColor()
        cell.image.hnk_setImageFromURL(NSURL(string: clubs["clubs"][indexPath.row]["logo"]["standard"]["url"].string!)!, placeholder: UIImage(named: "mini-racquet"))
        cell.clubName.text = clubs["clubs"][indexPath.row]["name"].string!
        return cell
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clubs["clubs"].count
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    let gridSize = 4;
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = (collectionView.frame.size.width - CGFloat(gridSize - 1)) / CGFloat(gridSize);
        return CGSize(width: size, height: size)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "select_club")
        {
            let indexPath = collectionView!.indexPathForCell(sender as! UICollectionViewCell)!
            let name = clubs["clubs"][indexPath.row]["name"].string!
            (segue.destinationViewController as! ClubTabViewController).clubName = name
            
        }
    }
}