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
//    @IBOutlet weak var manuView: UIView!
//    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var currentIPAddress: UILabel!
//    let blurFilter = CIFilter(name: "CIGaussianBlur", withInputParameters: [kCIInputRadiusKey: 10])
    
    let caObject = ChannelAccessClient.sharedObject()!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        monitoringButton.setTitle(nil, for: .normal)
        monitoringButton.setImage(UIImage(named: "Monitoring"), for: .normal)
        
        databroserButton.setTitle(nil, for: .normal)
        databroserButton.setImage(UIImage(named: "Chart"), for: .normal)
        
        cableInfoButton.setTitle(nil, for: .normal)
        cableInfoButton.setImage(UIImage(named: "CableInfo"), for: .normal)
        
        settingButton.setTitle(nil, for: .normal)
        settingButton.setImage(UIImage(named: "Setting"), for: .normal)
        

        
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
