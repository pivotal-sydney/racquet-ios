import UIKit
import Alamofire
import SwiftyJSON
import Haneke

class ClubCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let reuseIdentifier = "ClubViewCell"
    private var clubs : SwiftyJSON.JSON = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.delegate? = self
        populateDatur()
    }

    func populateDatur() {
        Alamofire.request(.GET, "https://racquet-io.cfapps.io/api/clubs")
        .responseJSON {
            response in
            guard response.result.error == nil else {
                // got an error in getting the data, need to handle it
                print("error calling GET on /posts/1")
                print(response.result.error!)
                return
            }
            if let value: AnyObject = response.result.value {
                let responseObject = JSON(value)
                debugPrint(responseObject)
                self.clubs = responseObject
            }
            self.collectionView!.reloadData()
        }

    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ClubViewCell
        cell.backgroundColor = UIColor.whiteColor()
//        cell.name.text = "Pivotal Labs Sydn3y"
//        cell.name.textColor = UIColor.whiteColor()
            print(clubs["clubs"][0]["logo"]["standard"]["url"].string!)
        cell.image.hnk_setImageFromURL(NSURL(string: clubs["clubs"][indexPath.row]["logo"]["standard"]["url"].string!)!, placeholder: UIImage(named: "mini-racquet"))
        cell.clubName.text = clubs["clubs"][indexPath.row]["name"].string!
        // Configure the cell
        return cell
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clubs["clubs"].count
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 2) / 3;
        return CGSize(width: width, height: width)
    }

}