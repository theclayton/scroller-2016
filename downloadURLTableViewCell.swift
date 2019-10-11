//
//  downloadURLTableViewCell.swift
//  Scroller
//
//  Created by Clayton Ward on 1/30/17.
//  Copyright © 2017 Flare Software. All rights reserved.
//

import UIKit

class downloadURLTableViewCell: UITableViewCell {

    @IBOutlet weak var URLTextField: UITextField!
    @IBOutlet weak var URLDownloadButton: UIButton!
    @IBOutlet weak var downloadIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
