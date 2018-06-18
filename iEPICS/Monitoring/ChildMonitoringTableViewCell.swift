//
//  ChildMonitoringTableViewCell.swift
//  iEPICS
//
//  Created by ctrl user on 01/11/2017.
//  Copyright © 2017 scwook. All rights reserved.
//

import UIKit

class ChildMonitoringTableViewCell: UITableViewCell {

    @IBOutlet weak var detailElementNameLabel: UILabel!
    @IBOutlet weak var detailElementValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let height = UIScreen.main.bounds.height
        switch height {
        case 480.0:
            break
        case 568.0:
            detailElementNameLabel.font = UIFont.systemFont(ofSize: 13.0)
            detailElementValueLabel.font = UIFont.systemFont(ofSize: 13.0)
        case 667.0:
            break
        case 736.0:
            break
        default:
            break
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
