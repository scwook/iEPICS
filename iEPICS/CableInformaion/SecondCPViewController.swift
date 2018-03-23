//
//  SecondCPViewController.swift
//  iEPICS
//
//  Created by ctrluser on 17/02/2018.
//  Copyright © 2018 scwook. All rights reserved.
//

import UIKit

class SecondCPViewController: UIViewController {

    @IBOutlet weak var dSub9_Male_ImageView: UIImageView!
    @IBOutlet weak var dSub9_Female_ImageView: UIImageView!
    @IBOutlet weak var maleTextLabel: UILabel!
    @IBOutlet weak var femaleTextLabel: UILabel!
    
    
    var imageSizeWidth: CGFloat = 193
    var imageSizeHeight: CGFloat = 92
    var marginHorizontal: CGFloat = 0
    var marginVertical: CGFloat = 130
    var marginVerticalOffset: CGFloat = 40
    var marginTextLabel: CGFloat = 20
    var maleTextSize: CGFloat = 20.0
    var femaleTextSize: CGFloat = 20.0
    var dSub9_Male_ImageName = "Dsub9_male"
    var dSub9_Female_ImageName = "Dsub9_female"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dSub9_Male_ImageView.translatesAutoresizingMaskIntoConstraints = false
        dSub9_Female_ImageView.translatesAutoresizingMaskIntoConstraints = false
        maleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        femaleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let height = UIScreen.main.bounds.height
        let margins = view.layoutMarginsGuide
        switch height {
        case 568.0:
            imageSizeWidth = 164
            imageSizeHeight = 78
            marginHorizontal = 0
            marginVertical = 100
            marginVerticalOffset = 30
            marginTextLabel = 18
            maleTextSize = 18.0
            femaleTextSize = 18.0
            
        default:
            imageSizeWidth = 193
            imageSizeHeight = 92
            marginHorizontal = 0
            marginVertical = 130
            marginVerticalOffset = 40
            marginTextLabel = 20
            maleTextSize = 20.0
            femaleTextSize = 20.0
            
            break
        }
        
        dSub9_Male_ImageView.image = UIImage(named: dSub9_Male_ImageName)
        dSub9_Female_ImageView.image = UIImage(named: dSub9_Female_ImageName)
        
        dSub9_Male_ImageView.widthAnchor.constraint(equalToConstant: imageSizeWidth).isActive = true
        dSub9_Male_ImageView.heightAnchor.constraint(equalToConstant: imageSizeHeight).isActive = true
        dSub9_Male_ImageView.centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: -marginHorizontal).isActive = true
        dSub9_Male_ImageView.centerYAnchor.constraint(equalTo: margins.centerYAnchor, constant: -marginVertical - marginVerticalOffset).isActive = true
        
        dSub9_Female_ImageView.widthAnchor.constraint(equalToConstant: imageSizeWidth).isActive = true
        dSub9_Female_ImageView.heightAnchor.constraint(equalToConstant: imageSizeHeight).isActive = true
        dSub9_Female_ImageView.centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: marginHorizontal).isActive = true
        dSub9_Female_ImageView.centerYAnchor.constraint(equalTo: margins.centerYAnchor, constant: marginVertical - marginVerticalOffset).isActive = true
        
        maleTextLabel.font = UIFont.systemFont(ofSize: maleTextSize)
        femaleTextLabel.font = UIFont.systemFont(ofSize: femaleTextSize)
        
        maleTextLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        maleTextLabel.topAnchor.constraint(equalTo: dSub9_Male_ImageView.bottomAnchor, constant: marginTextLabel).isActive = true
        
        femaleTextLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        femaleTextLabel.topAnchor.constraint(equalTo: dSub9_Female_ImageView.bottomAnchor, constant: marginTextLabel).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
