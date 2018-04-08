//
//  MotionViewController.swift
//  iEPICS
//
//  Created by ctrl user on 04/04/2018.
//  Copyright © 2018 scwook. All rights reserved.
//

import UIKit

class MotionViewController: UIViewController {
    
    @IBOutlet var moveButtons: [UIButton]!
    @IBOutlet var positionTextLabel: [UILabel]!
    @IBOutlet var limitImageView: [UIImageView]!
    
    let leftButtonIndex = 0
    let rightButtonIndex = 1
    let upButtonIndex = 2
    let downButtonIndex = 3
    let stopButtonIndex = 4
    
    let leftLimitImageIndex = 0
    let rightLimitImageIndex = 1
    let upLimitImageIndex = 2
    let downLimitImageIndex = 3
    
    var buttonSize: CGFloat = 90
    var marginBetweenButton: CGFloat = 200
    var marginFromBottom: CGFloat = 200
//    var leftMoveButtonImageName = "Motion_left_black"
//    var rightMoveButtonImageName = "Motion_right_black"
//    var upMoveButtonImageName = "Motion_up_black"
//    var downMoveButtonImageName = "Motion_down_black"
//    var stopButtonImageName = "Motion_stop_black"
    var moveButtonImageName = ["Motion_left_black", "Motion_right_black", "Motion_up_black", "Motion_down_black", "Motion_stop_black"]
    
    var limitImageSizeH: CGFloat = 58
    var limitImageSizeV: CGFloat = 242
    var marginBetweenLimit: CGFloat = 141
//    var leftLimitImageName = "Shield_left_balck"
//    var rightLimitImageName = "Shield_right_black"
//    var upLimitImageName = "Shield_up_black"
//    var downLimitImageName = "Shield_down_black"
    var limitImageName = ["Shield_left_balck", "Shield_right_black", "Shield_up_black", "Shield_down_black"]
    
    let lelftPVName = "ECR11-PCU:SMO:SEQ:JCW"
    let rightPVName = "ECR11-PCU:SMO:SEQ:JCCW"
    let upPVName = "ECR11-PCU:SMO:SEQ:UP"
    let downPVName = "ECR11-PCU:SMO:SEQ:DN"
    let stopPVName = "ECR11-PCU:SMO:SEQ:STOP"
    let position1PVName = "ECR11-PCU:SMO:SEQ:Pcur"
    let position2PVName = "ECR11-PCU:SMO:SEQ:Pang"
    let leftLimitPVName = "ECR11-PCU:SMO:SEQ:Fmin"
    let rightLimitPVName = "ECR11-PCU:SMO:SEQ:Fmax"

    @IBAction func moveButtonToucUp(_ sender: UIButton) {

        let buttonIndex = moveButtons.index(of: sender)!
        UIView.animate(withDuration: 0.3, animations: ({
            self.moveButtons[buttonIndex].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        ))

        switch buttonIndex {
        case leftButtonIndex:
            caObject.channelAccessPut(lelftPVName, putValue: 0)
            break
            
        case rightButtonIndex:
            caObject.channelAccessPut(rightPVName, putValue: 0)
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
    }
    
    
    @IBAction func moveButtonTouchDown(_ sender: UIButton) {
        let buttonIndex = moveButtons.index(of: sender)!
        UIView.animate(withDuration: 0.3, animations: ({
            self.moveButtons[buttonIndex].transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
        ))

        switch buttonIndex {
        case leftButtonIndex:
            caObject.channelAccessPut(lelftPVName, putValue: 1)
            break
            
        case rightButtonIndex:
            caObject.channelAccessPut(rightPVName, putValue: 1)
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
    }
    
    @IBAction func stopButtonTouchDown(_ sender: UIButton) {
//        let stopState = caObject.channelAccessGetValue(stopPVName)

        caObject.channelAccessPut(stopPVName, putValue: 1)
    }

    @IBAction func editButton(_ sender: UIBarButtonItem) {
        let buttonTransform1 = moveButtons[0].transform.translatedBy(x: -100, y: -100)
        let buttonScale1 = buttonTransform1.scaledBy(x: 0.5, y: 0.5)
        let buttonTransform2 = moveButtons[1].transform.translatedBy(x: -100, y: -50)
        let buttonScale2 = buttonTransform2.scaledBy(x: 0.5, y: 0.5)
        let buttonTransform3 = moveButtons[2].transform.translatedBy(x: -100, y: -40)
        let buttonScale3 = buttonTransform3.scaledBy(x: 0.5, y: 0.5)
        let buttonTransform4 = moveButtons[3].transform.translatedBy(x: -100, y: -10)
        let buttonScale4 = buttonTransform4.scaledBy(x: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.5, animations: ({
            self.moveButtons[0].transform = buttonScale1
            self.moveButtons[1].transform = buttonScale2
            self.moveButtons[2].transform = buttonScale3
            self.moveButtons[3].transform = buttonScale4

        }))
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

        let height = UIScreen.main.bounds.height
        switch height {
        case 480.0: // 480x320pt 3.5inch (iPhone4s) Not Supported in iEPICS
            buttonSize = 77
            marginBetweenButton = 120
            marginFromBottom = 80
//            leftMoveButtonImageName = "Motion_left_black_4inch"
//            rightMoveButtonImageName = "Motion_right_black_4inch"
//            upMoveButtonImageName = "Motion_up_black_4inch"
//            downMoveButtonImageName = "Motion_down_black_4inch"
//            stopButtonImageName = "Motion_stop_black_4inch"
            
            moveButtonImageName = ["Motion_left_black_4inch", "Motion_right_black_4inch", "Motion_up_black_4inch", "Motion_down_black_4inch", "Motion_stop_black_4inch"]

//            leftLimitImageName = "Shield_left_black_4inch"
//            rightLimitImageName = "Shield_right_black_4inch"
//            upLimitImageName = "Shield_up_black_4inch"
//            downLimitImageName = "Shield_down_black_4inch"
            
            limitImageName = ["Shield_left_black_4inch", "Shield_right_black_4inch", "Shield_up_black_4inch", "Shield_down_black_4inch"]
            
        case 568.0: // 568x320pt 4inch (iPhone5, 5c, 5s, SE)
            buttonSize = 77
            marginBetweenButton = 150
            marginFromBottom = 100
//            leftMoveButtonImageName = "Motion_left_black"
//            rightMoveButtonImageName = "Motion_right_black"
//            upMoveButtonImageName = "Motion_up_black"
//            downMoveButtonImageName = "Motion_down_black"
//            stopButtonImageName = "Motion_stop_black"
            moveButtonImageName = ["Motion_left_black_4inch", "Motion_right_black_4inch", "Motion_up_black_4inch", "Motion_down_black_4inch", "Motion_stop_black_4inch"]

//            leftLimitImageName = "Shield_left_black_4inch"
//            rightLimitImageName = "Shield_right_black_4inch"
//            upLimitImageName = "Shield_up_black_4inch"
//            downLimitImageName = "Shield_down_black_4inch"
            
            limitImageName = ["Shield_left_black_4inch", "Shield_right_black_4inch", "Shield_up_black_4inch", "Shield_down_black_4inch"]

            
        case 667.0: // 375x337pt 4,7inch (iPhone6, 6s, 7, 8)
            break
            
        case 736.0: // 414x736pt 5.5inch (iPhone 6 Plus, 6s Plus, 7 Plus, 8 Plus)
            break
            
        case 812.0: // 375x812pt 5.8inch (iPhone X)
            break
            
        default:
            break
        }
        
//        let moveButtonImage = UIImage(named: moveButtonImageName)?.withRenderingMode(.alwaysTemplate)
        
        for i in 0 ..< moveButtons.count {
            moveButtons[i].setTitle(nil, for: .normal)
            moveButtons[i].setImage(UIImage(named: moveButtonImageName[i])?.withRenderingMode(.alwaysTemplate), for: .normal)
            moveButtons[i].translatesAutoresizingMaskIntoConstraints = false
            moveButtons[i].isEnabled = false
        }
        
//        moveButtons[leftButtonIndex].setTitle(nil, for: .normal)
//        moveButtons[rightButtonIndex].setTitle(nil, for: .normal)
//        moveButtons[upButtonIndex].setTitle(nil, for: .normal)
//        moveButtons[downButtonIndex].setTitle(nil, for: .normal)
//        moveButtons[stopButtonIndex].setTitle(nil, for: .normal)
        
//        moveButtons[leftButtonIndex].setImage(UIImage(named: leftMoveButtonImageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
//        moveButtons[rightButtonIndex].setImage(UIImage(named: rightMoveButtonImageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
//        moveButtons[upButtonIndex].setImage(UIImage(named: upMoveButtonImageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
//        moveButtons[downButtonIndex].setImage(UIImage(named: downMoveButtonImageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
//        moveButtons[stopButtonIndex].setImage(UIImage(named: stopButtonImageName)?.withRenderingMode(.alwaysTemplate), for: .normal)

//        moveButtons[rightButtonIndex].transform = CGAffineTransform(rotationAngle: CGFloat.pi)
//        moveButtons[upButtonIndex].transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2.0)
//        moveButtons[downButtonIndex].transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2.0)
        
//        moveButtons[leftButtonIndex].translatesAutoresizingMaskIntoConstraints = false
//        moveButtons[rightButtonIndex].translatesAutoresizingMaskIntoConstraints = false
//        moveButtons[upButtonIndex].translatesAutoresizingMaskIntoConstraints = false
//        moveButtons[downButtonIndex].translatesAutoresizingMaskIntoConstraints = false
//        moveButtons[stopButtonIndex].translatesAutoresizingMaskIntoConstraints = false
        
        let margins = view.layoutMarginsGuide

        moveButtons[stopButtonIndex].widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[stopButtonIndex].heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[stopButtonIndex].centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: 0).isActive = true
        moveButtons[stopButtonIndex].centerYAnchor.constraint(equalTo: margins.bottomAnchor, constant: -marginFromBottom).isActive = true

        moveButtons[leftButtonIndex].widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[leftButtonIndex].heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[leftButtonIndex].centerXAnchor.constraint(equalTo: moveButtons[stopButtonIndex].centerXAnchor, constant: -marginBetweenButton / 2).isActive = true
        moveButtons[leftButtonIndex].centerYAnchor.constraint(equalTo: moveButtons[stopButtonIndex].centerYAnchor, constant: 0).isActive = true
        
        moveButtons[rightButtonIndex].widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[rightButtonIndex].heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[rightButtonIndex].centerXAnchor.constraint(equalTo: moveButtons[stopButtonIndex].centerXAnchor, constant: marginBetweenButton / 2).isActive = true
        moveButtons[rightButtonIndex].centerYAnchor.constraint(equalTo: moveButtons[stopButtonIndex].centerYAnchor, constant: 0).isActive = true
        
        moveButtons[upButtonIndex].widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[upButtonIndex].heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[upButtonIndex].centerXAnchor.constraint(equalTo: moveButtons[stopButtonIndex].centerXAnchor, constant: 0).isActive = true
        moveButtons[upButtonIndex].centerYAnchor.constraint(equalTo: moveButtons[stopButtonIndex].centerYAnchor, constant: -marginBetweenButton / 2).isActive = true
        
        moveButtons[downButtonIndex].widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[downButtonIndex].heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[downButtonIndex].centerXAnchor.constraint(equalTo: moveButtons[stopButtonIndex].centerXAnchor, constant: 0).isActive = true
        moveButtons[downButtonIndex].centerYAnchor.constraint(equalTo: moveButtons[stopButtonIndex].centerYAnchor, constant: marginBetweenButton / 2).isActive = true

//        moveButtons[leftButtonIndex].isEnabled = false
//        moveButtons[rightButtonIndex].isEnabled = false
//        moveButtons[upButtonIndex].isEnabled = false
//        moveButtons[downButtonIndex].isEnabled = false
//        moveButtons[stopButtonIndex].isEnabled = false
        
        for i in 0 ..< limitImageView.count {
            limitImageView[i].image = UIImage(named: limitImageName[i])
            limitImageView[i].image = limitImageView[i].image?.withRenderingMode(.alwaysTemplate)
            limitImageView[i].translatesAutoresizingMaskIntoConstraints = false

            limitImageView[i].isHidden = true
            limitImageView[i].tintColor = UIColor(red: 0.0, green: 64/255, blue: 125/255, alpha: 1.0)
        }
        
//        limitImageView[leftLimitImageIndex].image = UIImage(named: leftLimitImageName)
//        limitImageView[rightLimitImageIndex].image = UIImage(named: rightLimitImageName)
//        limitImageView[upLimitImageIndex].image = UIImage(named: upLimitImageName)
//        limitImageView[downLimitImageIndex].image = UIImage(named: downLimitImageName)
//
//        limitImageView[leftLimitImageIndex].image = limitImageView[leftLimitImageIndex].image?.withRenderingMode(.alwaysTemplate)
//        limitImageView[rightLimitImageIndex].image = limitImageView[rightLimitImageIndex].image?.withRenderingMode(.alwaysTemplate)
//        limitImageView[upLimitImageIndex].image = limitImageView[upLimitImageIndex].image?.withRenderingMode(.alwaysTemplate)
//        limitImageView[downLimitImageIndex].image = limitImageView[downLimitImageIndex].image?.withRenderingMode(.alwaysTemplate)

//        limitImageView[leftLimitImageIndex].translatesAutoresizingMaskIntoConstraints = false
//        limitImageView[rightLimitImageIndex].translatesAutoresizingMaskIntoConstraints = false
//        limitImageView[upLimitImageIndex].translatesAutoresizingMaskIntoConstraints = false
//        limitImageView[downLimitImageIndex].translatesAutoresizingMaskIntoConstraints = false
        
        limitImageView[leftLimitImageIndex].widthAnchor.constraint(equalToConstant: limitImageSizeH).isActive = true
        limitImageView[leftLimitImageIndex].heightAnchor.constraint(equalToConstant: limitImageSizeV).isActive = true
        limitImageView[leftLimitImageIndex].centerXAnchor.constraint(equalTo: moveButtons[stopButtonIndex].centerXAnchor, constant: -marginBetweenLimit).isActive = true
        limitImageView[leftLimitImageIndex].centerYAnchor.constraint(equalTo: moveButtons[stopButtonIndex].centerYAnchor, constant: 0).isActive = true

        limitImageView[rightLimitImageIndex].widthAnchor.constraint(equalToConstant: limitImageSizeH).isActive = true
        limitImageView[rightLimitImageIndex].heightAnchor.constraint(equalToConstant: limitImageSizeV).isActive = true
        limitImageView[rightLimitImageIndex].centerXAnchor.constraint(equalTo: moveButtons[stopButtonIndex].centerXAnchor, constant: marginBetweenLimit).isActive = true
        limitImageView[rightLimitImageIndex].centerYAnchor.constraint(equalTo: moveButtons[stopButtonIndex].centerYAnchor, constant: 0).isActive = true
        
        limitImageView[upLimitImageIndex].widthAnchor.constraint(equalToConstant: limitImageSizeV).isActive = true
        limitImageView[upLimitImageIndex].heightAnchor.constraint(equalToConstant: limitImageSizeH).isActive = true
        limitImageView[upLimitImageIndex].centerXAnchor.constraint(equalTo: moveButtons[stopButtonIndex].centerXAnchor, constant: 0).isActive = true
        limitImageView[upLimitImageIndex].centerYAnchor.constraint(equalTo: moveButtons[stopButtonIndex].centerYAnchor, constant: -marginBetweenLimit).isActive = true
       
        limitImageView[downLimitImageIndex].widthAnchor.constraint(equalToConstant: limitImageSizeV).isActive = true
        limitImageView[downLimitImageIndex].heightAnchor.constraint(equalToConstant: limitImageSizeH).isActive = true
        limitImageView[downLimitImageIndex].centerXAnchor.constraint(equalTo: moveButtons[stopButtonIndex].centerXAnchor, constant: 0).isActive = true
        limitImageView[downLimitImageIndex].centerYAnchor.constraint(equalTo: moveButtons[stopButtonIndex].centerYAnchor, constant: marginBetweenLimit).isActive = true
        
        
//        limitImageView[leftLimitImageIndex].isHidden = true
//        limitImageView[rightLimitImageIndex].isHidden = true
//        limitImageView[upLimitImageIndex].isHidden = true
//        limitImageView[downLimitImageIndex].isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        let sampleTextField =  UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
//        sampleTextField.placeholder = "Enter text here"
//        sampleTextField.font = UIFont.systemFont(ofSize: 15)
//        sampleTextField.borderStyle = UITextBorderStyle.roundedRect
//        sampleTextField.autocorrectionType = UITextAutocorrectionType.no
//        sampleTextField.keyboardType = UIKeyboardType.default
//        sampleTextField.returnKeyType = UIReturnKeyType.done
//        sampleTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
//        sampleTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
//        sampleTextField.delegate = self
//        self.view.addSubview(sampleTextField)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        caEventNotificationProtocol = NotificationCenter.default.addObserver(forName: caEventNotification, object: nil, queue: nil, using: catchEventNotification)
        caConnectionNotificationProtocol = NotificationCenter.default.addObserver(forName: caConnectionNotification, object: nil, queue: nil, using: catchConnectionNotification)
        caErrorNotificationProtocol = NotificationCenter.default.addObserver(forName: caErrorNotification, object: nil, queue: nil, using: catchErrorNotification)
        appDidEnterBackgroundProtocol = NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationDidEnterBackground, object: nil, queue: OperationQueue.main, using: applicationDidEnterBackground)
        appWillEnterForegroundProtocol = NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.main, using: applicationWillEnterForeground)
        
        caObject.channelAccessContextCreate()
        caObject.channelAccessAddProcessVariable(lelftPVName)
        caObject.channelAccessAddProcessVariable(rightPVName)
        caObject.channelAccessAddProcessVariable(upPVName)
        caObject.channelAccessAddProcessVariable(downPVName)
        caObject.channelAccessAddProcessVariable(stopPVName)
        caObject.channelAccessAddProcessVariable(position1PVName)
        caObject.channelAccessAddProcessVariable(position2PVName)
        caObject.channelAccessAddProcessVariable(leftLimitPVName)
        caObject.channelAccessAddProcessVariable(rightLimitPVName)
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
            var positionLabelIndex: Int?
            var limitImageIndex: Int?
            switch pvNameFromNotification {
            case lelftPVName:
                moveButtonIndex = 0
            case rightPVName:
                moveButtonIndex = 1
            case upPVName:
                moveButtonIndex = 2
            case downPVName:
                moveButtonIndex = 3
            case stopPVName:
                moveButtonIndex = 4
            case position1PVName:
                positionLabelIndex = 0
                break
            case position2PVName:
                positionLabelIndex = 1
            case leftLimitPVName:
                limitImageIndex = 0
            case rightLimitPVName:
                limitImageIndex = 1
            default:
                break
            }
            
            let currentValue = (moveData.value[0] as? NSString)?.integerValue
            DispatchQueue.main.async {
                if let buttonIndex = moveButtonIndex {
                    self.moveButtons[buttonIndex].adjustsImageWhenHighlighted = false
                    
                    if currentValue != 0 {
                        self.moveButtons[buttonIndex].tintColor = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
                    }
                    else {
                        self.moveButtons[buttonIndex].tintColor = UIColor.black
                    }
                }
                else if let positionIndex = positionLabelIndex {
                    let value = moveData.value as NSMutableArray
                    if value.count != 0 {
                        self.positionTextLabel[positionIndex].text = String(describing: value[0])
                    }
                }
                else if let limitIndex = limitImageIndex {
                    let value = moveData.value as NSMutableArray
                    if value.count != 0, let isEnabled = Int(String(describing: value[0])) {
                        if isEnabled == 0 {
                            self.limitImageView[limitIndex].isHidden = true

                        }
                        else {
                            self.limitImageView[limitIndex].isHidden = false
                        }
                    }
                }
            }
        }
    }
    
    private func catchConnectionNotification(notification:Notification) -> Void {
        if let pvNameFromNotification = notification.object as? String, let pvNameDictionary = caObject.channelAccessGetDictionary() {
            let moveData = pvNameDictionary[pvNameFromNotification] as! ChannelAccessData
            var moveButtonIndex: Int?
            var positionLabelIndex: Int?
            switch pvNameFromNotification {
            case lelftPVName:
                moveButtonIndex = 0
            case rightPVName:
                moveButtonIndex = 1
            case upPVName:
                moveButtonIndex = 2
            case downPVName:
                moveButtonIndex = 3
            case stopPVName:
                moveButtonIndex = 4
            case position1PVName:
                positionLabelIndex = 0
                break
            case position2PVName:
                positionLabelIndex = 1
                break
            default:
                break
            }
            
            DispatchQueue.main.async {
                
                if let buttonIndex = moveButtonIndex {
                    if moveData.connected {
                        self.moveButtons[buttonIndex].isEnabled = true
                    }
                    else {
                        self.moveButtons[buttonIndex].isEnabled = false
                    }
                }
                else {
                    if let positionIndex = positionLabelIndex {
                        if moveData.connected {
                            self.positionTextLabel[positionIndex].text = "Connected"
                        }
                        else  {
                            self.positionTextLabel[positionIndex].text = "Disconnected"
                        }
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


extension MotionViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // return NO to disallow editing.
        print("TextField should begin editing method called")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
        print("TextField did begin editing method called")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        print("TextField should snd editing method called")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        print("TextField did end editing method called")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        // if implemented, called in place of textFieldDidEndEditing:
        print("TextField did end editing with reason method called")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // return NO to not change text
        print("While entering the characters this method gets called")
        return true
    }
}

