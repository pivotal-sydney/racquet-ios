
import UIKit
import SwiftyJSON

class MinorLeaguesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let reuseIdentifier = "MinorLeaguesViewCell"
    private let insetSize = CGFloat(50)
    private let cellSize = CGFloat(50)
    var minors :SwiftyJSON.JSON = []
    private var numberOfMinors: Int
    
    required init?(coder aDecoder: NSCoder) {
        self.numberOfMinors = Int((UIScreen.mainScreen().bounds.width - (self.insetSize * 2)) / self.cellSize)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        self.collectionView!.delegate? = self
        self.collectionView!.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        super.viewDidLoad()
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
        return minors.count < self.numberOfMinors ? minors.count : numberOfMinors
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.numberOfMinors = Int((size.width - (self.insetSize*2)) / self.cellSize)
        self.collectionView!.reloadData()
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, self.insetSize, 0, self.insetSize)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.cellSize, self.cellSize)
    }
    

}