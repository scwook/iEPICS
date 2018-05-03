//
//  ArchiverTableViewCell.swift
//  iEPICS
//
//  Created by ctrl user on 03/05/2018.
//  Copyright © 2018 scwook. All rights reserved.
//

import UIKit

class ArchiveTableViewCell: UITableViewCell {
    @IBOutlet weak var pvNameTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
