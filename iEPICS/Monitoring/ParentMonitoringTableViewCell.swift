//
//  ParentMonitoringTableViewCell.swift
//  iEPICS
//
//  Created by ctrl user on 01/11/2017.
//  Copyright © 2017 scwook. All rights reserved.
//

import UIKit

class ParentMonitoringTableViewCell: UITableViewCell {

    @IBOutlet weak var pvNameLabel: UILabel!
    @IBOutlet weak var pvValueLabel: UILabel!
    @IBOutlet weak var arrayImageView: UIImageView!
    @IBOutlet weak var clockImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
