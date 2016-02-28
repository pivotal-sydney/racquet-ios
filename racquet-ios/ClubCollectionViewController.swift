import UIKit
import Alamofire
import SwiftyJSON
import Haneke

class ClubCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!

    private let reuseIdentifier = "ClubViewCell"
    var clubs: SwiftyJSON.JSON = nil
    
    var gridSize = Int(UIScreen.mainScreen().bounds.width / CGFloat(100))
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.delegate? = self
        populateDatur()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        //print("height:" + String(size.height) + "width:" + String(size.width))
        gridSize = Int(size.width / CGFloat(100))
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
        
        let cellWidth = (collectionView.frame.size.width - CGFloat(gridSize - 1)) / CGFloat(gridSize);
        let imageWidth = cellWidth - 35.0
        
        cell.image.layer.cornerRadius = (imageWidth / CGFloat(2))
        cell.image.clipsToBounds = true
        return cell
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clubs["clubs"].count
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = (collectionView.frame.size.width - CGFloat(gridSize - 1)) / CGFloat(gridSize);
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