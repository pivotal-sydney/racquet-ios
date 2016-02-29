
import UIKit
import SwiftyJSON

class MinorLeaguesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let reuseIdentifier = "MinorLeaguesViewCell"
    private var minors :SwiftyJSON.JSON = []
    //private var numberOfMinors = 4 // Int(UIScreen.mainScreen().bounds.width ))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.delegate? = self
    }
    
    func populateDatur(minors: SwiftyJSON.JSON) {
        self.minors = minors
        self.collectionView!.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MinorLeaguesViewCell
        cell.backgroundColor = UIColor.whiteColor()
        cell.faceImage.hnk_setImageFromURL(NSURL(string: minors[indexPath.row]["member"]["profile_image_url"].string!)!, placeholder: UIImage(named: "mini-racquet"))
        cell.faceImage.layer.cornerRadius = cell.faceImage.frame.size.width / CGFloat(2)
        cell.faceImage.clipsToBounds = true
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return minors.count < self.numberOfMinors ? minors.count : numberOfMinors
        return minors.count
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionView!.frame.size.width = size.width
        self.collectionView!.reloadData()

    }

}