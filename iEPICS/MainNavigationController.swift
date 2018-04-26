//
//  MainNavigationController.swift
//  iEPICS
//
//  Created by ctrluser on 21/02/2018.
//  Copyright © 2018 scwook. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    let caObject = ChannelAccessClient.sharedObject()!

    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view.
        let epicsEnv_AutoAddressList = "EPICS_CA_AUTO_ADDR_LIST"
        let epicsEnv_AddressList = "EPICS_CA_ADDR_LIST"

        var appLaunchedBefore = false

        if UserDefaults.standard.bool(forKey: "AppLaunchedBefore") {
            
            // Auto Address Init Settings
            let autoAddressListEnable = UserDefaults.standard.bool(forKey: "CAEnvAutoAddressEnable")
            var autoAddressListEPICS = "YES"
            
            if !autoAddressListEnable {
                autoAddressListEPICS = "NO"
            }
        
            UserDefaults.standard.set(autoAddressListEnable, forKey: "CAEnvAutoAddressEnable")
            caObject.channelAccessSetEnvironment(epicsEnv_AutoAddressList, key: autoAddressListEPICS)

            if let addressList = UserDefaults.standard.string(forKey: "CAEnvAddressList") {
                caObject.channelAccessSetEnvironment(epicsEnv_AddressList, key: addressList)
            }
            
            // Motion Init Settings
            let motionHorizontalAxisEnable = UserDefaults.standard.bool(forKey: "MotionHorizontalAxisEnable")
            let motionVerticalAxisEnable = UserDefaults.standard.bool(forKey: "MotionVerticalAxisEnable")
            
            UserDefaults.standard.set(motionHorizontalAxisEnable, forKey: "MotionHorizontalAxisEnable")
            UserDefaults.standard.set(motionVerticalAxisEnable, forKey: "MotionVerticalAxisEnable")
        }
        else {
            print("First Lanch")
            
            // Auto Address Init Settings
            let autoAddressListEnable = true
            let autoAddressListEPICS = "YES"

            UserDefaults.standard.set(autoAddressListEnable, forKey: "CAEnvAutoAddressEnable")
            caObject.channelAccessSetEnvironment(epicsEnv_AutoAddressList, key: autoAddressListEPICS)
            caObject.channelAccessSetEnvironment(epicsEnv_AddressList, key: "")

            // Motion Init Settings
            let motionHorizontalAxisEnable = true
            let motionVerticalAxisEnable = true
            
            UserDefaults.standard.set(motionHorizontalAxisEnable, forKey: "MotionHorizontalAxisEnable")
            UserDefaults.standard.set(motionVerticalAxisEnable, forKey: "MotionVerticalAxisEnable")

            // Disable First Launch
            appLaunchedBefore = true
            UserDefaults.standard.set(appLaunchedBefore, forKey: "AppLaunchedBefore")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var shouldAutorotate: Bool {
        return (self.topViewController?.shouldAutorotate)!
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return (self.topViewController?.supportedInterfaceOrientations)!
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
