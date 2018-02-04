//
//  ArrayTableViewCell.swift
//  iEPICS
//
//  Created by ctrl user on 30/11/2017.
//  Copyright © 2017 scwook. All rights reserved.
//

import UIKit

class ArrayTableViewCell: UITableViewCell {

    @IBOutlet weak var arrayIndexLabel: UILabel!
    @IBOutlet weak var arrayValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
