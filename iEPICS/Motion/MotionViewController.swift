//
//  MotionViewController.swift
//  iEPICS
//
//  Created by ctrl user on 04/04/2018.
//  Copyright © 2018 scwook. All rights reserved.
//

import UIKit

class MotionViewController: UIViewController {
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet var moveButtons: [UIButton]!
    @IBOutlet weak var positionTextLabel: UILabel!
    
    let leftButtonIndex = 0
    let rightButtonIndex = 1
    let upButtonIndex = 2
    let downButtonIndex = 3
    
    var buttonSize: CGFloat = 70
    var marginBetweenButton: CGFloat = 200
    var marginFromBottom: CGFloat = 200
    var moveButtonImageName = "Motion_left_black"
    var stopButtonImageName = "Motion_stop_black"
    
    let leftPVname = "ECR11-PCU:SMO:SEQ:JCW"
    let rightPVname = "ECR11-PCU:SMO:SEQ:JCCW"
    let position = "ECR11-PCU:SMO:SEQ:Pcur"

    @IBAction func moveButtonToucUp(_ sender: UIButton) {
        print("move up")
        sender.isHighlighted = false

        let index = moveButtons.index(of: sender)!
        switch index {
        case leftButtonIndex:
            caObject.channelAccessPut(leftPVname, putValue: 0)
            break
            
        case rightButtonIndex:
            caObject.channelAccessPut(rightPVname, putValue: 0)
            break
            
        case upButtonIndex:
            caObject.channelAccessPut("up", putValue: 0)
            break
            
        case downButtonIndex:
            caObject.channelAccessPut("down", putValue: 0)
            break
        default:
            break
        }
        
//        moveButtons[index].tintColor = UIColor.black
    }
    
    @IBAction func moveButtonTouchDown(_ sender: UIButton) {
        print("move down")
        sender.isHighlighted = false

        let index = moveButtons.index(of: sender)!
        switch index {
        case leftButtonIndex:
            caObject.channelAccessPut(leftPVname, putValue: 1)
            break
            
        case rightButtonIndex:
            caObject.channelAccessPut(rightPVname, putValue: 1)
            break
            
        case upButtonIndex:
            caObject.channelAccessPut("up", putValue: 1)
            break
            
        case downButtonIndex:
            caObject.channelAccessPut("down", putValue: 1)
            break
        default:
            break
        }
        
//        moveButtons[index].tintColor = UIColor(red:0.0, green: 0.5, blue: 0.0, alpha: 1.0)
    }
    
    @IBAction func stopButtonTouchDown(_ sender: UIButton) {
        sender.isHighlighted = false
        sender.tintColor = UIColor(red:0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        print("down")
    }

    let caEventNotification = Notification.Name("EventCallbackNotification")
    let caConnectionNotification = Notification.Name("ConnectionCallbackNotification")
    let caErrorNotification = Notification.Name("ErrorCallbackNotification")
    
    var caEventNotificationProtocol: NSObjectProtocol?
    var caConnectionNotificationProtocol: NSObjectProtocol?
    var caErrorNotificationProtocol: NSObjectProtocol?
    var appDidEnterBackgroundProtocol: NSObjectProtocol?
    var appWillEnterForegroundProtocol: NSObjectProtocol?
    
    let caObject = ChannelAccessClient.sharedObject()!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        moveButtons[leftButtonIndex].setTitle(nil, for: .normal)
        moveButtons[rightButtonIndex].setTitle(nil, for: .normal)
        moveButtons[upButtonIndex].setTitle(nil, for: .normal)
        moveButtons[downButtonIndex].setTitle(nil, for: .normal)
        stopButton.setTitle(nil, for: .normal)
        
//        moveButtons[0].translatesAutoresizingMaskIntoConstraints = false
//        moveButtons[1].translatesAutoresizingMaskIntoConstraints = false
//        moveButtons[2].translatesAutoresizingMaskIntoConstraints = false
//        moveButtons[3].translatesAutoresizingMaskIntoConstraints = false

        let height = UIScreen.main.bounds.height
        switch height {
        case 480.0: // 480x320pt 3.5inch (iPhone4s) Not Supported in iEPICS
            buttonSize = 40
            marginBetweenButton = 100
            marginFromBottom = 80
            moveButtonImageName = "Motion_left_black_4inch"
            stopButtonImageName = "Motion_stop_black_4inch"
            
        case 568.0: // 568x320pt 4inch (iPhone5, 5c, 5s, SE)
            buttonSize = 60
            marginBetweenButton = 130
            marginFromBottom = 100
            moveButtonImageName = "Motion_left_black"
            stopButtonImageName = "Motion_stop_black"
            
        case 667.0: // 375x337pt 4,7inch (iPhone6, 6s, 7, 8)
            break
            
        case 736.0: // 414x736pt 5.5inch (iPhone 6 Plus, 6s Plus, 7 Plus, 8 Plus)
            break
            
        case 812.0: // 375x812pt 5.8inch (iPhone X)
            break
            
        default:
            break
        }
        
        moveButtons[leftButtonIndex].setImage(UIImage(named: moveButtonImageName), for: .normal)
        moveButtons[rightButtonIndex].setImage(UIImage(named: moveButtonImageName), for: .normal)
        moveButtons[upButtonIndex].setImage(UIImage(named: moveButtonImageName), for: .normal)
        moveButtons[downButtonIndex].setImage(UIImage(named: moveButtonImageName), for: .normal)
        stopButton.setImage(UIImage(named: stopButtonImageName), for: .normal)
    
        moveButtons[rightButtonIndex].transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        moveButtons[upButtonIndex].transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2.0)
        moveButtons[downButtonIndex].transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2.0)
        
        let margins = view.layoutMarginsGuide

        moveButtons[leftButtonIndex].translatesAutoresizingMaskIntoConstraints = false
        moveButtons[rightButtonIndex].translatesAutoresizingMaskIntoConstraints = false
        moveButtons[upButtonIndex].translatesAutoresizingMaskIntoConstraints = false
        moveButtons[downButtonIndex].translatesAutoresizingMaskIntoConstraints = false
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        
        stopButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        stopButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        stopButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: 0).isActive = true
        stopButton.centerYAnchor.constraint(equalTo: margins.bottomAnchor, constant: -marginFromBottom).isActive = true

        moveButtons[leftButtonIndex].widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[leftButtonIndex].heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[leftButtonIndex].centerXAnchor.constraint(equalTo: stopButton.centerXAnchor, constant: -marginBetweenButton / 2).isActive = true
        moveButtons[leftButtonIndex].centerYAnchor.constraint(equalTo: stopButton.centerYAnchor, constant: 0).isActive = true
        
        moveButtons[rightButtonIndex].widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[rightButtonIndex].heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[rightButtonIndex].centerXAnchor.constraint(equalTo: stopButton.centerXAnchor, constant: marginBetweenButton / 2).isActive = true
        moveButtons[rightButtonIndex].centerYAnchor.constraint(equalTo: stopButton.centerYAnchor, constant: 0).isActive = true
        
        moveButtons[upButtonIndex].widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[upButtonIndex].heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[upButtonIndex].centerXAnchor.constraint(equalTo: stopButton.centerXAnchor, constant: 0).isActive = true
        moveButtons[upButtonIndex].centerYAnchor.constraint(equalTo: stopButton.centerYAnchor, constant: -marginBetweenButton / 2).isActive = true
        
        moveButtons[downButtonIndex].widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[downButtonIndex].heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[downButtonIndex].centerXAnchor.constraint(equalTo: stopButton.centerXAnchor, constant: 0).isActive = true
        moveButtons[downButtonIndex].centerYAnchor.constraint(equalTo: stopButton.centerYAnchor, constant: marginBetweenButton / 2).isActive = true

        moveButtons[leftButtonIndex].isEnabled = false
        moveButtons[rightButtonIndex].isEnabled = false
        moveButtons[upButtonIndex].isEnabled = false
        moveButtons[downButtonIndex].isEnabled = false

        //        let value: Any = 2345
//        caObject.channelAccessPut("left", putValue: value)
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }

    override func viewDidAppear(_ animated: Bool) {
        caEventNotificationProtocol = NotificationCenter.default.addObserver(forName: caEventNotification, object: nil, queue: nil, using: catchEventNotification)
        caConnectionNotificationProtocol = NotificationCenter.default.addObserver(forName: caConnectionNotification, object: nil, queue: nil, using: catchConnectionNotification)
        caErrorNotificationProtocol = NotificationCenter.default.addObserver(forName: caErrorNotification, object: nil, queue: nil, using: catchErrorNotification)
        appDidEnterBackgroundProtocol = NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationDidEnterBackground, object: nil, queue: OperationQueue.main, using: applicationDidEnterBackground)
        appWillEnterForegroundProtocol = NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.main, using: applicationWillEnterForeground)
        
        caObject.channelAccessContextCreate()
        caObject.channelAccessAddProcessVariable(leftPVname)
        caObject.channelAccessAddProcessVariable(rightPVname)
        caObject.channelAccessAddProcessVariable("up")
        caObject.channelAccessAddProcessVariable("down")
        
        caObject.channelAccessAddProcessVariable(position)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let eventNotificationProtocol = caEventNotificationProtocol {
            NotificationCenter.default.removeObserver(eventNotificationProtocol)
        }
        
        if let connectionNotificationProtocol = caConnectionNotificationProtocol {
            NotificationCenter.default.removeObserver(connectionNotificationProtocol)
        }
        
        if let errorNotificationProtocol = caErrorNotificationProtocol {
            NotificationCenter.default.removeObserver(errorNotificationProtocol)
        }
        
        if let enterBackgroundProtocol = appDidEnterBackgroundProtocol {
            NotificationCenter.default.removeObserver(enterBackgroundProtocol)
        }
        
        if let foregroundProtocol = appWillEnterForegroundProtocol {
            NotificationCenter.default.removeObserver(foregroundProtocol)
        }
        
        caObject.channelAccessAllClear()
        caObject.channelAccessContexDestroy()
    }
    
    
    //********* Notification *************
    private func catchEventNotification(notification:Notification) -> Void {
        if let pvNameFromNotification = notification.object as? String, let pvNameDictionary = caObject.channelAccessGetDictionary() {
            let moveData = pvNameDictionary[pvNameFromNotification] as! ChannelAccessData

            var moveButtonIndex: Int?
            switch pvNameFromNotification {
            case leftPVname:
                moveButtonIndex = 0
            case rightPVname:
                moveButtonIndex = 1
            default:
                break
            }
            
            let currentValue = (moveData.value[0] as? NSString)?.integerValue

            DispatchQueue.main.async {
                if let buttonIndex = moveButtonIndex {
                    if currentValue != 0 {
                        self.moveButtons[buttonIndex].tintColor = UIColor(red:0.0, green: 0.5, blue: 0.0, alpha: 1.0)
                    }
                    else {
                        self.moveButtons[buttonIndex].tintColor = UIColor.black
                    }
                }
                else {
                    let value = moveData.value as NSMutableArray
                    if value.count != 0 {
                        self.positionTextLabel.text = String(describing: value[0])
                    }
                }
            }
        }
        
//        if let pvNameDictionary = caObject.channelAccessGetDictionary() {
//            let moveLeftData = pvNameDictionary[leftPVname] as! ChannelAccessData
//            let moveRightData = pvNameDictionary[rightPVname] as! ChannelAccessData
//            let moveUpData = pvNameDictionary["up"] as! ChannelAccessData
//            let moveDownData = pvNameDictionary["down"] as! ChannelAccessData
//
//            let leftDataValue = (moveLeftData.value[0] as? NSString)?.integerValue
//            let rightDataValue = (moveRightData.value[0] as? NSString)?.integerValue
//            let upDataValue = (moveUpData.value[0] as? NSString)?.integerValue
//            let downDataValue = (moveDownData.value[0] as? NSString)?.integerValue
//
//
//            DispatchQueue.main.async {
//                if leftDataValue != 0 {
//                    self.moveButtons[0].tintColor = UIColor(red:0.0, green: 0.5, blue: 0.0, alpha: 1.0)
//                }
//                else {
//                    self.moveButtons[0].tintColor = UIColor.black
//                }
//
//                if rightDataValue != 0 {
//                    self.moveButtons[1].tintColor = UIColor(red:0.0, green: 0.5, blue: 0.0, alpha: 1.0)
//                }
//                else {
//                    self.moveButtons[1].tintColor = UIColor.black
//                }
//
//                if upDataValue != 0 {
//                    self.moveButtons[2].tintColor = UIColor(red:0.0, green: 0.5, blue: 0.0, alpha: 1.0)
//                }
//                else {
//                    self.moveButtons[2].tintColor = UIColor.black
//                }
//
//                if downDataValue != 0 {
//                    self.moveButtons[3].tintColor = UIColor(red:0.0, green: 0.5, blue: 0.0, alpha: 1.0)
//                }
//                else {
//                    self.moveButtons[3].tintColor = UIColor.black
//                }
//            }
//        }
    }
    
    private func catchConnectionNotification(notification:Notification) -> Void {
        if let pvNameFromNotification = notification.object as? String, let pvNameDictionary = caObject.channelAccessGetDictionary() {
            let moveData = pvNameDictionary[pvNameFromNotification] as! ChannelAccessData
            var moveButtonIndex: Int?
            switch pvNameFromNotification {
            case leftPVname:
                moveButtonIndex = 0
            case rightPVname:
                moveButtonIndex = 1
            default:
                break
            }
            
            if let buttonIndex = moveButtonIndex {
                DispatchQueue.main.async {
                    if moveData.connected {
                        self.moveButtons[buttonIndex].tintColor = UIColor.black
                        self.moveButtons[buttonIndex].isEnabled = true
                    }
                    else {
                        //                        self.moveButtons[0].tintColor = UIColor.gray
                        self.moveButtons[buttonIndex].isEnabled = false
                    }
                }
            }
        }
    }
    
    private func catchErrorNotification(notification:Notification) -> Void {
        
        if let caMessage = notification.object as? String {
            let alert = UIAlertController(title: "CA Message", message: caMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(alert, animated: true)
        }
    }
    
    private func applicationDidEnterBackground(notification:Notification) -> Void {
        caObject.channelAccessAllClear()
        
        caObject.channelAccessContexDestroy()
    }
    
    private func applicationWillEnterForeground(notification:Notification) -> Void {

        
        caObject.channelAccessContextCreate()
        
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
