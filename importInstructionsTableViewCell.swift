//
//  importInstructionsTableViewCell.swift
//  Scroller
//
//  Created by Clayton Ward on 1/30/17.
//  Copyright © 2017 Flare Software. All rights reserved.
//

import UIKit

class importInstructionsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var subtitleText: UILabel!
    @IBOutlet weak var iconImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
