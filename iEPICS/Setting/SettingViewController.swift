//
//  SettingViewController.swift
//  iEPICS
//
//  Created by ctrl user on 01/11/2017.
//  Copyright © 2017 scwook. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var CAEnvironmentView: UIView!
    @IBOutlet weak var CAAddressListTextField: UITextField! {
        didSet {
            print(CAAddressListTextField.text)
            UserDefaults.standard.set(CAAddressListTextField.text, forKey: "CAEnvAddressList")
        }
    }
    
    @IBAction func CAAutoListSwitchAction(_ sender: UISwitch) {
        print(sender.isOn)

        UserDefaults.standard.set(sender.isOn, forKey: "CAEnvAutoAddressEnable")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        CAEnvironmentView.layer.cornerRadius = 5
        CAEnvironmentView.layer.borderWidth = 1
        CAEnvironmentView.layer.borderColor = UIColor.black.cgColor
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
