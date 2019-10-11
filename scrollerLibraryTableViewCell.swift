//
//  scrollerLibraryTableViewCell.swift
//  Scroller
//
//  Created by Clayton Ward on 2/6/17.
//  Copyright © 2017 Flare Software. All rights reserved.
//

import UIKit

class scrollerLibraryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var composerLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
