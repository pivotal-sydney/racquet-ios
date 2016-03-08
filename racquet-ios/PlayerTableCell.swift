//
//  PlayerTableCell.swift
//  racquet-ios
//
//  Created by pivotal on 3/3/16.
//  Copyright © 2016 Pivotal. All rights reserved.
//

import UIKit

class PlayerTableCell: UITableViewCell {

    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var twitterLabel: UILabel!
    @IBOutlet weak var playerImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
