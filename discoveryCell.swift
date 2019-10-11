//
//  discoveryCell.swift
//  Scroller
//
//  Created by Clayton Ward on 8/1/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import UIKit

class discoveryCell:  UITableViewCell {
    
    @IBOutlet weak var setlistTitle: UILabel!
    @IBOutlet weak var setlistImage: UIImageView!
    @IBOutlet weak var setlistDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
