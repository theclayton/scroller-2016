//
//  newSongCell.swift
//  Scroller
//
//  Created by Clayton Ward on 1/28/17.
//  Copyright © 2017 Flare Software. All rights reserved.
//

import UIKit

class newSongCell: UITableViewCell {

    @IBOutlet weak var fileNumber: UILabel!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var composerField: UITextField!
    @IBOutlet weak var TextFoundLabel: UILabel!
    @IBOutlet weak var fileName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
