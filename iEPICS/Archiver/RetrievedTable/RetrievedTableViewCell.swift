//
//  RetrievedTableViewCell.swift
//  iEPICS
//
//  Created by ctrl user on 14/05/2018.
//  Copyright © 2018 scwook. All rights reserved.
//

import UIKit

class RetrievedTableViewCell: UITableViewCell {
    @IBOutlet weak var dateTextLabel: UILabel!
    @IBOutlet weak var valueTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
