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
        
        let height = UIScreen.main.bounds.height
        switch height {
        case 480.0: // 480x320pt 3.5inch (iPhone4s) Not Supported in iEPICS
            break
            
        case 568.0: // 568x320pt 4inch (iPhone5, C, S, SE)
            arrayIndexLabel.font = UIFont.systemFont(ofSize: 15.0)
            arrayValueLabel.font = UIFont.systemFont(ofSize: 15.0)
            
        case 667.0: // 375x337pt 4,7inch (iPhone8, 7, 6s Plus, 6 Plus, 6s, 6)
            break
            
        case 736.0: // 414x736pt 5.5inch (iPhone8 Plus, 7 Plus)
            break
            
        case 812.0: // 375x812pt 5.8inch (iPhone X)
            break
            
        default:
            arrayIndexLabel.font = UIFont.systemFont(ofSize: 17.0)
            arrayValueLabel.font = UIFont.systemFont(ofSize: 17.0)
            break
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
