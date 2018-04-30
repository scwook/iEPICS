//
//  MainMenuViewController.swift
//  iEPICS
//
//  Created by ctrl user on 01/11/2017.
//  Copyright © 2017 scwook. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    @IBOutlet weak var monitoringButton: UIButton!
    @IBOutlet weak var databroserButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var cableInfoButton: UIButton!
    @IBOutlet weak var motionButton: UIButton!
    //    @IBOutlet weak var manuView: UIView!
//    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var currentIPAddress: UILabel!
//    let blurFilter = CIFilter(name: "CIGaussianBlur", withInputParameters: [kCIInputRadiusKey: 10])
    
    let caObject = ChannelAccessClient.sharedObject()!

    var buttonSize: CGFloat = 60
    var marginBetweenButton: CGFloat = 60
    var marginFromBottom: CGFloat = 120
    var monitoringButtonImageName = "Monitoring"
    var chartButtonImageName = "Chart"
    var motionButtonImageName = "Motion"
    var cableInfoButtonImageName = "CableInfo"
    var settingButtonImageName = "Setting"
    var scwookMarginFromBottom: CGFloat = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        monitoringButton.setTitle(nil, for: .normal)
        databroserButton.setTitle(nil, for: .normal)
        motionButton.setTitle(nil, for: .normal)
        cableInfoButton.setTitle(nil, for: .normal)
        settingButton.setTitle(nil, for: .normal)

        monitoringButton.translatesAutoresizingMaskIntoConstraints = false
        databroserButton.translatesAutoresizingMaskIntoConstraints = false
        motionButton.translatesAutoresizingMaskIntoConstraints = false
        cableInfoButton.translatesAutoresizingMaskIntoConstraints = false
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        
        let height = UIScreen.main.bounds.height
        let margins = view.layoutMarginsGuide
        switch height {
        case 480.0: // 480x320pt 3.5inch (iPhone4s) Not Supported in iEPICS
            buttonSize = 40
            marginBetweenButton = 43
            marginFromBottom = 90
            monitoringButtonImageName = "Monitoring_4inch"
            chartButtonImageName = "Chart_4inch"
            motionButtonImageName = "Motion_4inch"
            cableInfoButtonImageName = "CableInfo_4inch"
            settingButtonImageName = "Setting_4inch"
            
        case 568.0: // 568x320pt 4inch (iPhone5, 5c, 5s, SE)
            buttonSize = 51
            marginBetweenButton = 51
            marginFromBottom = 110
            monitoringButtonImageName = "Monitoring_4inch"
            chartButtonImageName = "Chart_4inch"
            motionButtonImageName = "Motion_4inch"
            cableInfoButtonImageName = "CableInfo_4inch"
            settingButtonImageName = "Setting_4inch"

        case 667.0: // 375x337pt 4,7inch (iPhone6, 6s, 7, 8)
            break
            
        case 736.0: // 414x736pt 5.5inch (iPhone 6 Plus, 6s Plus, 7 Plus, 8 Plus)
            buttonSize = 60
            marginBetweenButton = 60
            marginFromBottom = 130
            monitoringButtonImageName = "Monitoring"
            chartButtonImageName = "Chart"
            motionButtonImageName = "Motion"
            cableInfoButtonImageName = "CableInfo"
            settingButtonImageName = "Setting"
            
        case 812.0: // 375x812pt 5.8inch (iPhone X)
            buttonSize = 60
            marginBetweenButton = 60
            marginFromBottom = 130
            monitoringButtonImageName = "Monitoring"
            chartButtonImageName = "Chart"
            motionButtonImageName = "Motion"
            cableInfoButtonImageName = "CableInfo"
            settingButtonImageName = "Setting"
            scwookMarginFromBottom = 5
            
        default:
            buttonSize = 60
            marginBetweenButton = 60
            marginFromBottom = 118
            monitoringButtonImageName = "Monitoring"
            chartButtonImageName = "Chart"
            motionButtonImageName = "Motion"
            cableInfoButtonImageName = "CableInfo"
            settingButtonImageName = "Setting"
            break
        }
        
        monitoringButton.setImage(UIImage(named: monitoringButtonImageName), for: .normal)
        databroserButton.setImage(UIImage(named: chartButtonImageName), for: .normal)
        motionButton.setImage(UIImage(named: motionButtonImageName), for: .normal)
        cableInfoButton.setImage(UIImage(named: cableInfoButtonImageName), for: .normal)
        settingButton.setImage(UIImage(named: settingButtonImageName), for: .normal)

        monitoringButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        monitoringButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        monitoringButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: -marginBetweenButton * 2).isActive = true
        monitoringButton.centerYAnchor.constraint(equalTo: cableInfoButton.centerYAnchor, constant: -marginBetweenButton * 2).isActive = true

        databroserButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        databroserButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        databroserButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: 0).isActive = true
        databroserButton.centerYAnchor.constraint(equalTo: settingButton.centerYAnchor, constant: -marginBetweenButton * 2).isActive = true
        
        motionButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        motionButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        motionButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: marginBetweenButton * 2).isActive = true
        motionButton.centerYAnchor.constraint(equalTo: cableInfoButton.centerYAnchor, constant: -marginBetweenButton * 2).isActive = true
        
        cableInfoButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        cableInfoButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        cableInfoButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: -marginBetweenButton).isActive = true
        cableInfoButton.centerYAnchor.constraint(equalTo: margins.bottomAnchor, constant: -marginFromBottom).isActive = true
        
        settingButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        settingButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        settingButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: marginBetweenButton).isActive = true
        settingButton.centerYAnchor.constraint(equalTo: margins.bottomAnchor, constant: -marginFromBottom).isActive = true
        


        //        let backgroundImage = UIImage(named: "background3")!
//        
//        if let ciImage = CIImage.init(image: backgroundImage) {
//            
//            blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
//            
//            let uiImage = UIImage.init(ciImage: (blurFilter?.outputImage!)!)
//            
//            backgroundImageView.image = uiImage
//        }
        
        
//        backgroundView.backgroundColor = UIColor(patternImage: backgroundImage)
//
//        let blurLayer = CALayer()
//        blurLayer.frame = backgroundView.bounds
//        blurLayer.contents = backgroundImage
//
//        if let blurFilter = CIFilter(name: "CIGaussianBlur", withInputParameters: [kCIInputRadiusKey: 5]) {
//            blurLayer.backgroundFilters = [blurFilter]
//        }
//        backgroundView.layer.addSublayer(blurLayer)
        

            
//            blurFilter.setValue(ciImage, forKey: kCIInputImageKey)
//            blurFilter.setValue(2, forKey: kCIInputRadiusKey)
            
//            if let outputImage = blurFilter.outputImage {
//                let uiImage = UIImage.init(ciImage: outputImage)
//                backgroundView.backgroundColor = UIColor(patternImage: uiImage)
//            }

        //.image = UIImage(ciImage: outputImage)

        //view.backgroundColor = UIColor(patternImage: backgroundImage!)
//        view.layer.addSublayer(foreground)


        //manuView.layer.cornerRadius = 20
        
//        navigationController?.navigationBar.tintColor = UIColor.red
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = UIColor.clear
        
//        monitoringButton.layer.borderWidth = 0.5
//        monitoringButton.layer.borderColor = UIColor.black.cgColor
//
//        monitoringButton.layer.shadowColor = UIColor.black.cgColor
//        monitoringButton.layer.shadowOffset = CGSize(width: 0, height: 3)
//        monitoringButton.layer.shadowOpacity = 0.5
//        monitoringButton.layer.shadowRadius = 5
        
//        monitoringButton.layer.cornerRadius = 10
//        databroserButton.layer.cornerRadius = 10
//        settingButton.layer.cornerRadius = 10
        
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = view.bounds
//
//        let colorOne = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
//        let colorTwo = UIColor(red: 0.0, green: 0.0, blue: 255.0/128.0, alpha: 1.0)
//        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
//        gradientLayer.locations = [0.0, 10.0]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        //gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        
//        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var ipAddress: String?
        ipAddress = caObject.channelAccessGetIPAddress()
        
        currentIPAddress.text = ipAddress
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
  f  // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
