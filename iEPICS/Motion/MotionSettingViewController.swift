//
//  MotionSettingViewController.swift
//  iEPICS
//
//  Created by ctrl user on 11/04/2018.
//  Copyright © 2018 scwook. All rights reserved.
//

import UIKit

class MotionSettingViewController: UIViewController, UITextFieldDelegate {
    
    let keyNameforAxis1 = ["MotionPosition1", "MotionLeftPV", "MotionRightPV", "MotionLeftLimitPV", "MotionRightLimitPV"]
    let keyNameforAxis2 = ["MotionPosition2", "MotionUpPV", "MotionDownPV", "MotionUpLimitPV", "MotionDownLimitPV"]
    
    @IBOutlet weak var axisSettingView1: UIView!
    @IBOutlet weak var axisEnableSwitch1: UISwitch! {
        didSet {
            axisEnableSwitch1.setOn(UserDefaults.standard.bool(forKey: "MotionAxisEnable1"), animated: false)
        }
    }
    
    @IBOutlet var axisPVTextField1: [UITextField]! {
        didSet {
            for i in 0 ..< axisPVTextField1.count {
                axisPVTextField1[i].delegate = self
                axisPVTextField1[i].text = UserDefaults.standard.string(forKey: keyNameforAxis1[i])
            }
        }
    }
    
    @IBOutlet weak var axisSettingView2: UIView!
    @IBOutlet weak var axisEnableSwitch2: UISwitch! {
        didSet {
            axisEnableSwitch2.setOn(UserDefaults.standard.bool(forKey: "MotionAxisEnable2"), animated: false)
        }
    }
    
    @IBOutlet var axisPVTextField2: [UITextField]! {
        didSet {
            for i in 0 ..< axisPVTextField2.count {
                axisPVTextField2[i].delegate = self
                axisPVTextField2[i].text = UserDefaults.standard.string(forKey: keyNameforAxis2[i])
            }
        }
    }
    
    @IBAction func axisEnableAction1(_ sender: UISwitch) {
        if axisEnableSwitch1.isOn {
            for i in 0 ..< axisPVTextField1.count {
                axisPVTextField1[i].isEnabled = true
            }
        }
        else {
            for i in 0 ..< axisPVTextField1.count {
                axisPVTextField1[i].isEnabled = false
            }
        }
        
        UserDefaults.standard.set(axisEnableSwitch1.isOn, forKey: "MotionAxisEnable1")
    }
    
    @IBAction func axisEnableAction2(_ sender: UISwitch) {
        if axisEnableSwitch2.isOn {
            for i in 0 ..< axisPVTextField2.count {
                axisPVTextField2[i].isEnabled = true
            }
        }
        else {
            for i in 0 ..< axisPVTextField2.count {
                axisPVTextField2[i].isEnabled = false
            }
        }

        UserDefaults.standard.set(axisEnableSwitch2.isOn, forKey: "MotionAxisEnable2")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        axisSettingView1.layer.cornerRadius = 5
        axisSettingView1.layer.borderWidth = 1
        axisSettingView1.layer.borderColor = UIColor.black.cgColor
        
        axisSettingView2.layer.cornerRadius = 5
        axisSettingView2.layer.borderWidth = 1
        axisSettingView2.layer.borderColor = UIColor.black.cgColor
        
        // Do any additional setup after loading the view.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let pvName = textField.text
        var keyName: String?
        
        switch textField {
        case axisPVTextField1[0]:
            keyName = keyNameforAxis1[0]
            
        case axisPVTextField1[1]:
            keyName = keyNameforAxis1[1]

        case axisPVTextField1[2]:
            keyName = keyNameforAxis1[2]

        case axisPVTextField1[3]:
            keyName = keyNameforAxis1[3]

        case axisPVTextField1[4]:
            keyName = keyNameforAxis1[4]

        case axisPVTextField2[0]:
            keyName = keyNameforAxis2[0]

        case axisPVTextField2[1]:
            keyName = keyNameforAxis2[1]

        case axisPVTextField2[2]:
            keyName = keyNameforAxis2[2]

        case axisPVTextField2[3]:
            keyName = keyNameforAxis2[3]

        case axisPVTextField2[4]:
            keyName = keyNameforAxis2[4]

        default:
            break
        }
        
        UserDefaults.standard.set(pvName, forKey: keyName!)
        
        self.view.endEditing(true)
        return true
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
