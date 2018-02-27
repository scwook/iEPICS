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
        
        var autoAddressList = "NO"
        
        if UserDefaults.standard.bool(forKey: "CAEnvAutoAddressEnable") {
            autoAddressList = "YES"
        }
        
        let addressList = UserDefaults.standard.string(forKey: "CAEnvAddressList")
        
        caObject.channelAccessSetEnvironment("EPICS_CA_AUTO_ADDR_LIST", key: autoAddressList)
        caObject.channelAccessSetEnvironment("EPICS_CA_ADDR_LIST", key: addressList)
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
