import UIKit

class RoundUIImageView : UIImageView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.layer.bounds.height / CGFloat(2)
    }
}