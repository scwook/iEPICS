//
//  SettingViewController.swift
//  iEPICS
//
//  Created by ctrl user on 01/11/2017.
//  Copyright © 2017 scwook. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITextFieldDelegate {

    let caObject = ChannelAccessClient.sharedObject()!

    // Channel Access Environment
    @IBOutlet weak var CAEnvironmentView: UIView!
    @IBOutlet weak var autoAddrListSwitch: UISwitch! {
        didSet{
            autoAddrListSwitch.setOn(UserDefaults.standard.bool(forKey: "CAEnvAutoAddressEnable"), animated: false)
        }
    }
    
    @IBOutlet weak var CAAddressListTextField: UITextField! {
        didSet {
            CAAddressListTextField.delegate = self
            CAAddressListTextField.text = UserDefaults.standard.string(forKey: "CAEnvAddressList")
        }
    }
 
    @IBAction func CAAutoListSwitchAction(_ sender: UISwitch) {
        var autoAddressList = "NO"
        
        if autoAddrListSwitch.isOn {
            autoAddressList = "YES"
        }
        
        UserDefaults.standard.set(autoAddrListSwitch.isOn, forKey: "CAEnvAutoAddressEnable")
        caObject.channelAccessSetEnvironment("EPICS_CA_AUTO_ADDR_LIST", key: autoAddressList)
    }
    
    // Motion Settings
    @IBOutlet weak var motionSettingView: UIView!
    @IBOutlet weak var motionHorizontalAxisSwitch: UISwitch! {
        didSet {
            motionHorizontalAxisSwitch.setOn(UserDefaults.standard.bool(forKey: "MotionHorizontalAxisEnable"), animated: false)
        }
    }
    @IBOutlet weak var motionVerticalAxisSwitch: UISwitch! {
        didSet {
            motionVerticalAxisSwitch.setOn(UserDefaults.standard.bool(forKey: "MotionVerticalAxisEnable"), animated: false)
        }
    }
    
    @IBAction func motionHorizontalAxisSwitchAction(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "MotionHorizontalAxisEnable")
    }
    
    @IBAction func motionVerticalAxisSwitchAction(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "MotionVerticalAxisEnable")
    }
    
    // Archiver Appliance Settings
    let archiveURLSessionConfig = URLSessionConfiguration.default
    var archiveURLSeesion: URLSession?
    
    @IBOutlet weak var archiveSettingView: UIView!
    @IBOutlet weak var archiveURLTextField: UITextField! {
        didSet {
            archiveURLTextField.delegate = self
            archiveURLTextField.text = UserDefaults.standard.string(forKey: "ArchiveServerURL")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let viewCornerRadius: CGFloat = 10
        
        CAEnvironmentView.layer.cornerRadius = viewCornerRadius
        CAEnvironmentView.layer.borderWidth = 1
        CAEnvironmentView.layer.borderColor = UIColor.black.cgColor
        
        motionSettingView.layer.cornerRadius = viewCornerRadius
        motionSettingView.layer.borderWidth = 1
        motionSettingView.layer.borderColor = UIColor.black.cgColor
        
        archiveSettingView.layer.cornerRadius = viewCornerRadius
        archiveSettingView.layer.borderWidth = 1
        archiveSettingView.layer.borderColor = UIColor.black.cgColor
        
        archiveURLSessionConfig.timeoutIntervalForResource = 5
        archiveURLSessionConfig.timeoutIntervalForRequest = 5
        archiveURLSeesion = URLSession(configuration: archiveURLSessionConfig)
        
//        let autoAddressEnalbeState = UserDefaults.standard.bool(forKey: "CAEnvAutoAddressEnable")
//        let autoAddressList = UserDefaults.standard.string(forKey: "CAEnvAddressList")
        
//        autoAddrListSwitch.setOn(autoAddressEnalbeState, animated: false)
//        CAAddressListTextField.text = autoAddressList
        
//        caObject.channelAccessSetEnvironment("EPICS_CA_AUTO_ADDR_LIST", key: "false")
//        caObject.channelAccessSetEnvironment("EPICS_CA_ADDR_LIST", key: "10.1.4.63")
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == CAAddressListTextField {
            let caAddressList = textField.text
            UserDefaults.standard.set(caAddressList, forKey: "CAEnvAddressList")
            caObject.channelAccessSetEnvironment("EPICS_CA_ADDR_LIST", key: caAddressList)
        }
        else if textField == archiveURLTextField {
            let archiveURL = textField.text
            getArchiveServerInfo(archiveURL)
            
        }
        else {
            
        }
        
        self.view.endEditing(true)
        return true
    }
    
    func getArchiveServerInfo(_ mgmtURL: String?) {
        if let serverURL = mgmtURL {
            let searchingName = serverURL + "/bpl/getApplianceInfo"
            
            if let getDataURL = URL(string: searchingName) {
                
                let archiveURLTask = archiveURLSeesion?.dataTask(with: getDataURL) {
                    (data, response, error) in
                    guard let archiveData = data, error == nil else {
                        UserDefaults.standard.set(nil, forKey: "ArchiveDataRetrievalURL")
                        self.errorMessage(message: "Can not connect to server")

                        return
                    }
                    
                    do {
                        let jsonRawData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : String]
                        UserDefaults.standard.set(jsonRawData["dataRetrievalURL"], forKey: "ArchiveDataRetrievalURL")
                        
                    } catch {
                        UserDefaults.standard.set(nil, forKey: "ArchiveDataRetrievalURL")
                        self.errorMessage(message: "Invalide server address")
                    }

                }
                archiveURLTask?.resume()
            }
        }
        
        UserDefaults.standard.set(mgmtURL, forKey: "ArchiveServerURL")
    }

    private func errorMessage(message: String) -> Void {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
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
