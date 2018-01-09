//
//  ScriptTableViewCell.swift
//  Gadfly
//
//  Created by Ziwen Chen on 1/9/18.
//  Copyright © 2018 G-FORVM. All rights reserved.
//

import UIKit

class ScriptTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
