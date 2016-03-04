import UIKit
import Alamofire
import SwiftyJSON
import Haneke

class ClubCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!

    private let reuseIdentifier = "ClubViewCell"
    var clubs: SwiftyJSON.JSON = nil
    let minSquareSize = CGFloat(100)
    var gridSize:Int
    
    required init?(coder aDecoder: NSCoder) {
        self.gridSize = Int(UIScreen.mainScreen().bounds.width / self.minSquareSize)
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.delegate? = self
        populateDatur()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        gridSize = Int(size.width / minSquareSize)
        self.collectionView!.reloadData()
    }

    func populateDatur(service: RacquetRestService = RealRacquetRestService()) {
        progressIndicator.startAnimating()
        service.getClubs(onGetClubs);
    }

    func onGetClubs(response: SwiftyJSON.JSON?, success: Bool) {
        progressIndicator.stopAnimating()
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
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = Int((collectionView.bounds.size.width - CGFloat(gridSize - 1)) / CGFloat(gridSize));
        return CGSize(width: size, height: size)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "select_club")
        {
            let indexPath = collectionView!.indexPathForCell(sender as! UICollectionViewCell)!
            let club = clubs["clubs"][indexPath.row]
            (segue.destinationViewController as! ClubTabViewController).club = club
        }
    }
}