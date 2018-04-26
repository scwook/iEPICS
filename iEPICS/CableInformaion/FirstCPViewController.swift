//
//  FirstCPViewController.swift
//  iEPICS
//
//  Created by ctrluser on 17/02/2018.
//  Copyright © 2018 scwook. All rights reserved.
//

import UIKit

class FirstCPViewController: UIViewController {

    @IBOutlet weak var rj45_T568A_Standard_ImageView: UIImageView!
    @IBOutlet weak var rj45_T568B_Standard_ImageView: UIImageView!
    @IBOutlet weak var rj45_T568A_Crossover_ImageView: UIImageView!
    @IBOutlet weak var rj45_T568B_Crossover_ImageView: UIImageView!
    @IBOutlet weak var standardTextLabel: UILabel!
    @IBOutlet weak var crossoverTextLabel: UILabel!
    
    var imageSizeWidth: CGFloat = 104
    var imageSizeHeight: CGFloat = 187
    var marginHorizontal: CGFloat = 80
    var marginVertical: CGFloat = 200
    var marginVerticalOffset: CGFloat = 100
    var marginTextLabel: CGFloat = 20
    var rj45_T568A_Standard_ImageName = "RJ45_T568A_ST"
    var rj45_T568B_Standard_ImageName = "RJ45_T568B_ST"
    var rj45_T568A_Crossover_ImageName = "RJ45_T568A_CR"
    var rj45_T568B_Crossover_ImageName = "RJ45_T568B_CR"
    var standardTextSize: CGFloat = 20.0
    var crossoverTextSize: CGFloat = 20.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        rj45_T568A_Standard_ImageView.translatesAutoresizingMaskIntoConstraints = false
        rj45_T568B_Standard_ImageView.translatesAutoresizingMaskIntoConstraints = false
        rj45_T568A_Crossover_ImageView.translatesAutoresizingMaskIntoConstraints = false
        rj45_T568B_Crossover_ImageView.translatesAutoresizingMaskIntoConstraints = false
        standardTextLabel.translatesAutoresizingMaskIntoConstraints = false
        crossoverTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let height = UIScreen.main.bounds.height
        let margins = view.layoutMarginsGuide
        switch height {
        case 480.0: // 480x320pt 3.5inch (iPhone4s) Not Supported in iEPICS
            imageSizeWidth = 88
            imageSizeHeight = 159
            marginHorizontal = 68
            marginVertical = 100
            marginVerticalOffset = 30
            marginTextLabel = 10
            rj45_T568A_Standard_ImageName = "RJ45_T568A_ST_4inch"
            rj45_T568B_Standard_ImageName = "RJ45_T568B_ST_4inch"
            rj45_T568A_Crossover_ImageName = "RJ45_T568A_CR_4inch"
            rj45_T568B_Crossover_ImageName = "RJ45_T568B_CR_4inch"
            standardTextSize = 12.0
            crossoverTextSize = 12.0
            
        case 568.0:
            imageSizeWidth = 88
            imageSizeHeight = 159
            marginHorizontal = 68
            marginVertical = 120
            marginVerticalOffset = 40
            marginTextLabel = 18
            rj45_T568A_Standard_ImageName = "RJ45_T568A_ST_4inch"
            rj45_T568B_Standard_ImageName = "RJ45_T568B_ST_4inch"
            rj45_T568A_Crossover_ImageName = "RJ45_T568A_CR_4inch"
            rj45_T568B_Crossover_ImageName = "RJ45_T568B_CR_4inch"
            standardTextSize = 17.0
            crossoverTextSize = 17.0
            
        default:
            imageSizeWidth = 104
            imageSizeHeight = 187
            marginHorizontal = 80
            marginVertical = 150
            marginVerticalOffset = 50
            marginTextLabel = 20
            rj45_T568A_Standard_ImageName = "RJ45_T568A_ST"
            rj45_T568B_Standard_ImageName = "RJ45_T568B_ST"
            rj45_T568A_Crossover_ImageName = "RJ45_T568A_CR"
            rj45_T568B_Crossover_ImageName = "RJ45_T568B_CR"
            standardTextSize = 20.0
            crossoverTextSize = 20.0
 
            break
        }
        
        rj45_T568A_Standard_ImageView.image = UIImage(named: rj45_T568A_Standard_ImageName)
        rj45_T568B_Standard_ImageView.image = UIImage(named: rj45_T568B_Standard_ImageName)
        rj45_T568A_Crossover_ImageView.image = UIImage(named: rj45_T568A_Crossover_ImageName)
        rj45_T568B_Crossover_ImageView.image = UIImage(named: rj45_T568B_Crossover_ImageName)
        
        rj45_T568A_Standard_ImageView.widthAnchor.constraint(equalToConstant: imageSizeWidth).isActive = true
        rj45_T568A_Standard_ImageView.heightAnchor.constraint(equalToConstant: imageSizeHeight).isActive = true
        rj45_T568A_Standard_ImageView.centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: -marginHorizontal).isActive = true
        rj45_T568A_Standard_ImageView.centerYAnchor.constraint(equalTo: margins.centerYAnchor, constant: -marginVertical - marginVerticalOffset).isActive = true
        
        rj45_T568B_Standard_ImageView.widthAnchor.constraint(equalToConstant: imageSizeWidth).isActive = true
        rj45_T568B_Standard_ImageView.heightAnchor.constraint(equalToConstant: imageSizeHeight).isActive = true
        rj45_T568B_Standard_ImageView.centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: marginHorizontal).isActive = true
        rj45_T568B_Standard_ImageView.centerYAnchor.constraint(equalTo: margins.centerYAnchor, constant: -marginVertical - marginVerticalOffset).isActive = true
        
        rj45_T568A_Crossover_ImageView.widthAnchor.constraint(equalToConstant: imageSizeWidth).isActive = true
        rj45_T568A_Crossover_ImageView.heightAnchor.constraint(equalToConstant: imageSizeHeight).isActive = true
        rj45_T568A_Crossover_ImageView.centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: -marginHorizontal).isActive = true
        rj45_T568A_Crossover_ImageView.centerYAnchor.constraint(equalTo: margins.centerYAnchor, constant: marginVertical - marginVerticalOffset).isActive = true
        
        rj45_T568B_Crossover_ImageView.widthAnchor.constraint(equalToConstant: imageSizeWidth).isActive = true
        rj45_T568B_Crossover_ImageView.heightAnchor.constraint(equalToConstant: imageSizeHeight).isActive = true
        rj45_T568B_Crossover_ImageView.centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: marginHorizontal).isActive = true
        rj45_T568B_Crossover_ImageView.centerYAnchor.constraint(equalTo: margins.centerYAnchor, constant: marginVertical - marginVerticalOffset).isActive = true
        
        standardTextLabel.font = UIFont.systemFont(ofSize: standardTextSize)
        crossoverTextLabel.font = UIFont.systemFont(ofSize: crossoverTextSize)
        
        standardTextLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        standardTextLabel.topAnchor.constraint(equalTo: rj45_T568A_Standard_ImageView.bottomAnchor, constant: marginTextLabel).isActive = true
        
        crossoverTextLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        crossoverTextLabel.topAnchor.constraint(equalTo: rj45_T568A_Crossover_ImageView.bottomAnchor, constant: marginTextLabel).isActive = true
        
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
