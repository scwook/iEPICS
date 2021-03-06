//
//  MotionViewController.swift
//  iEPICS
//
//  Created by ctrl user on 04/04/2018.
//  Copyright © 2018 scwook. All rights reserved.
//

import UIKit

class MotionViewController: UIViewController, ChangeElementDataDelegate {
    
    @IBOutlet var moveButtons: [UIButton]!
    @IBOutlet var positionTextLabel: [UILabel]!
    @IBOutlet var limitImageView: [UIImageView]!
    @IBOutlet var positionImageView: [UIImageView]!
    
//    var leftMoveTextField: UITextField?
//    var rightMoveTextField: UITextField?
//    var upMoveTextField: UITextField?
//    var downMoveTextField: UITextField?
//
//    var leftLimitTextField: UITextField?
//    var rightLimitTextField: UITextField?
//    var upMoveLimitField: UITextField?
//    var downLimitTextField: UITextField?
    
    var isPVEditing = false
    var editImageName = "Edit_black"
    var checkImageName = "Check_black"
    
    let positionHorizontalIndex = 0
    let positionVerticalIndex = 1
    
    let leftButtonIndex = 0
    let rightButtonIndex = 1
    let upButtonIndex = 2
    let downButtonIndex = 3
    let stopButtonIndex = 4
    
    let leftLimitImageIndex = 0
    let rightLimitImageIndex = 1
    let upLimitImageIndex = 2
    let downLimitImageIndex = 3
    
    var positionImageSize: CGFloat = 90
    var positionImageName = ["Position_horizontal_black", "Position_vertical_black"]
    
    var buttonSize: CGFloat = 90
    var marginBetweenButton: CGFloat = 100
    var marginFromBottom: CGFloat = 200
    var moveButtonImageName = ["Motion_left_black", "Motion_right_black", "Motion_up_black", "Motion_down_black", "Motion_stop_black"]
    
    var limitImageSizeH: CGFloat = 38
    var limitImageSizeV: CGFloat = 182
    var marginBetweenLimit: CGFloat = 150
    var limitImageName = ["Shield_left_balck", "Shield_right_black", "Shield_up_black", "Shield_down_black"]
    
    var lelftPVName = "scwook:Init@"
    var rightPVName = "scwook:Init@"
    var upPVName = "scwook:Init@"
    var downPVName = "scwook:Init@"
    var stopPVName = "scwook:Init@"
    var position1PVName = "scwook:Init@"
    var position2PVName = "scwook:Init@"
    var leftLimitPVName = "scwook:Init@"
    var rightLimitPVName = "scwook:Init@"
    var upLimitPVName = "scwook:Init@"
    var downLimitPVName = "scwook:Init@"
    
    let keyNameforAxis1 = ["MotionPosition1", "MotionLeftPV", "MotionRightPV", "MotionLeftLimitPV", "MotionRightLimitPV"]
    let keyNameforAxis2 = ["MotionPosition2", "MotionUpPV", "MotionDownPV", "MotionUpLimitPV", "MotionDownLimitPV"]
    let keyNameforStop = "MotionStopPV"
    
    var keyNameforSegue: String?
    
    var textFieldWidth: CGFloat = 110.0
    var textFieldHeight: CGFloat = 30
    
    @IBAction func moveButtonToucUp(_ sender: UIButton) {
        if isPVEditing {

        }
        else {
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
                caObject.channelAccessPut(upPVName, putValue: 0)
                break
                
            case downButtonIndex:
                caObject.channelAccessPut(downPVName, putValue: 0)
                break
            default:
                break
            }
        }
    }
    
    @IBAction func moveButtonTouchDown(_ sender: UIButton) {
        if isPVEditing {
            let buttonIndex = moveButtons.index(of: sender)!
            var buttonPV: String?
            var buttonName: String?
            switch buttonIndex {
            case leftButtonIndex:
                buttonName = "Left"
                keyNameforSegue = keyNameforAxis1[1]
                buttonPV = UserDefaults.standard.string(forKey: keyNameforSegue!)
                break
                
            case rightButtonIndex:
                buttonName = "Right"
                keyNameforSegue = keyNameforAxis1[2]
                buttonPV = UserDefaults.standard.string(forKey: keyNameforSegue!)
                break
                
            case upButtonIndex:
                buttonName = "Up"
                keyNameforSegue = keyNameforAxis2[1]
                buttonPV = UserDefaults.standard.string(forKey: keyNameforSegue!)
                break
                
            case downButtonIndex:
                buttonName = "Down"
                keyNameforSegue = keyNameforAxis2[2]
                buttonPV = UserDefaults.standard.string(forKey: keyNameforSegue!)
                break
            default:
                buttonName = ""
                buttonPV = ""
                keyNameforSegue = nil
                break
            }
            
            let buttonInfoArray: [String?] = [buttonName, buttonPV]
            performSegue(withIdentifier: "changeElementViewController", sender: buttonInfoArray)
        }
        else {
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
                caObject.channelAccessPut(upPVName, putValue: 1)
                break
                
            case downButtonIndex:
                caObject.channelAccessPut(downPVName, putValue: 1)
                break
            default:
                break
            }
        }
    }
    
    @IBAction func stopButtonTouchDown(_ sender: UIButton) {
        if isPVEditing {
            let buttonName = "Stop"
            keyNameforSegue = keyNameforStop
            let buttonPV: String? = UserDefaults.standard.string(forKey: keyNameforSegue!)

            let buttonInfoArray: [String?] = [buttonName, buttonPV]
            performSegue(withIdentifier: "changeElementViewController", sender: buttonInfoArray)
        }
        else {
            if let stopStateString = caObject.channelAccessGet(stopPVName) {
                let stopState = Int(stopStateString)
                if stopState != 0 {
                    caObject.channelAccessPut(stopPVName, putValue: 0)
                }
                else {
                    caObject.channelAccessPut(stopPVName, putValue: 1)
                }
            }
            
            UIView.animate(withDuration: 0.3, animations: ({
                sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                }
            ))
        }
    }

    @IBAction func stopButtonTouchUp(_ sender: UIButton) {
        if isPVEditing {
            
        }
        else {
            UIView.animate(withDuration: 0.3, animations: ({
                sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            ))
        }
    }
    
    
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        if !isPVEditing {
            editingMode1(sender)
        }
        else {
            caObject.channelAccessAllClear()

            motionMode(sender)
            
            createProcessVariable()
        }
        
//        editingMode2(sender)
    }
    
    private func editingMode1(_ sender: UIBarButtonItem) {
        let yOffset: CGFloat = buttonSize * 0.6
        let viewCenterY = view.frame.height / 2 + yOffset
        
        // Position Image Editing Mode
        for i in 0 ..< positionImageView.count {
            var translatedX: CGFloat = 0.0
            var translatedY: CGFloat = 0.0
            let scale: CGFloat = 0.75
            
            switch i {
            case positionHorizontalIndex:
                translatedX = -buttonSize
                translatedY = viewCenterY - positionImageView[positionHorizontalIndex].center.y - buttonSize * 2.5
                
            case positionVerticalIndex:
                translatedX = buttonSize
                translatedY = viewCenterY - positionImageView[positionVerticalIndex].center.y - buttonSize * 2.5
            default:
                break
            }
            
            let positionTransform = positionImageView[i].transform.translatedBy(x: translatedX, y: translatedY)
            let positionScale = positionTransform.scaledBy(x: scale, y: scale)
            
            UIView.animate(withDuration: 0.5, delay: Double(i) * 0.1, options: .curveEaseInOut, animations: {
                self.positionImageView[i].transform = positionScale
                self.positionImageView[i].tintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                
            }, completion: nil)
        }
        
        for i in 0 ..< positionTextLabel.count {
            UIView.animate(withDuration: 0.5, delay: Double(i) * 0.1, options: .curveEaseInOut, animations: {
                self.positionTextLabel[i].textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
                
            }, completion: nil)
        }
        
        // Move Button Editing Mode
        for i in 0 ..< moveButtons.count {
            var translatedX: CGFloat = 0.0
            var translatedY: CGFloat = 0.0
            let scale: CGFloat = 0.75
            
            moveButtons[i].isHidden = false
            moveButtons[i].isEnabled = true
            
            switch i {
            case leftButtonIndex:
                translatedX = marginBetweenButton - buttonSize
                translatedY = viewCenterY - moveButtons[leftButtonIndex].center.y - buttonSize * 1.5
                
            case rightButtonIndex:
                translatedX = -marginBetweenButton - buttonSize
                translatedY = viewCenterY - moveButtons[rightButtonIndex].center.y - buttonSize / 2
                
            case upButtonIndex:
                translatedX = -buttonSize
                translatedY = viewCenterY - moveButtons[upButtonIndex].center.y + buttonSize / 2
                
            case downButtonIndex:
                translatedX = -buttonSize
                translatedY = viewCenterY - moveButtons[downButtonIndex].center.y + buttonSize * 1.5
                
            case stopButtonIndex:
                translatedX = 0.0
                translatedY = viewCenterY - moveButtons[stopButtonIndex].center.y + buttonSize * 2.5
                
            default:
                break
            }
            
            let buttonTransform = moveButtons[i].transform.translatedBy(x: translatedX, y: translatedY)
            let buttonScale = buttonTransform.scaledBy(x: scale, y:scale)
            
            UIView.animate(withDuration: 0.5, delay: Double(i) * 0.1, options: .curveEaseInOut, animations: {
                self.moveButtons[i].transform = buttonScale
                
            }, completion: nil)
        }
        
        // Limit Image Editing Mode
        for i in 0 ..< limitImageView.count {
            var translatedX: CGFloat = 0.0
            var translatedY: CGFloat = 0.0
            var scaleX: CGFloat = 0.5
            var scaleY: CGFloat = 0.4
            
            switch i {
            case leftLimitImageIndex:
                translatedX = marginBetweenLimit + buttonSize
                translatedY = viewCenterY - limitImageView[leftLimitImageIndex].center.y - buttonSize * 1.5
                
            case rightLimitImageIndex:
                translatedX = -marginBetweenLimit + buttonSize
                translatedY = viewCenterY - limitImageView[rightLimitImageIndex].center.y - buttonSize / 2
                
            case upLimitImageIndex:
                translatedX = buttonSize
                translatedY = viewCenterY - limitImageView[upLimitImageIndex].center.y + buttonSize / 2
                scaleX = 0.4
                scaleY = 0.5
                
            case downLimitImageIndex:
                translatedX = buttonSize
                translatedY = viewCenterY - limitImageView[downLimitImageIndex].center.y + buttonSize * 1.5
                scaleX = 0.4
                scaleY = 0.5
                
            default:
                break
            }
            
            let limitTransform = limitImageView[i].transform.translatedBy(x: translatedX, y: translatedY)
            let limitScale = limitTransform.scaledBy(x: scaleX, y: scaleY)
            
            UIView.animate(withDuration: 0.5, delay: Double(i) * 0.1, options: .curveEaseInOut, animations: {
                self.limitImageView[i].transform = limitScale
                self.limitImageView[i].tintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)

            }, completion: nil)
        }
        
        let barButtonImageName = checkImageName
        sender.image = UIImage(named: barButtonImageName)
        isPVEditing = true
    }
    
    private func motionMode(_ sender: UIBarButtonItem) {
        
        for i in 0 ..< positionImageView.count {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.positionImageView[i].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.positionImageView[i].tintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
                
            }, completion: nil)
        }
        
        for i in 0 ..< positionTextLabel.count {
            UIView.animate(withDuration: 0.5, delay: Double(i) * 0.1, options: .curveEaseInOut, animations: {
                self.positionTextLabel[i].textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                
            }, completion: nil)
        }
        
        for i in 0 ..< moveButtons.count {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.moveButtons[i].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
            }, completion: nil)
        }
        
        for i in 0 ..< limitImageView.count {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.limitImageView[i].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.limitImageView[i].tintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
            }, completion: nil)
        }
        
        let barButtonImageName = editImageName
        sender.image = UIImage(named: barButtonImageName)

        isPVEditing = false
    }
    
//    private func editingMode2(_ sender: UIBarButtonItem) {
//        let durationTime = 0.4
//        let delayTime = 0.0
//        let yOffset: CGFloat = 100
//        if !isPVEditing {
//            // Move Button Editing Mode
//            for i in 0 ..< moveButtons.count {
//                var translatedX: CGFloat = 0.0
//                var translatedY: CGFloat = 0.0
//                let scale: CGFloat = 0.75
//
//                switch i {
//                case leftButtonIndex:
//                    translatedX = marginBetweenButton - buttonSize * scale
//                    translatedY = -yOffset
//
//                case rightButtonIndex:
//                    translatedX = -marginBetweenButton + buttonSize * scale
//                    translatedY = -yOffset
//
//                case upButtonIndex:
////                    translatedX = buttonSize / 2
//                    translatedY = marginBetweenButton - buttonSize * scale - yOffset
//
//                case downButtonIndex:
////                    translatedX = (buttonSize / 2) + buttonSize
//                    translatedY = -marginBetweenButton + buttonSize * scale - yOffset
//
//                case stopButtonIndex:
//                    translatedX = 0.0
//                    translatedY = -yOffset
//
//                default:
//                    break
//                }
//                moveButtons[i].isHidden = false
//
//                let buttonTransform = moveButtons[i].transform.translatedBy(x: translatedX, y: translatedY)
//                let buttonScale = buttonTransform.scaledBy(x: scale, y:scale)
//
//                UIView.animate(withDuration: durationTime, delay: delayTime, options: .curveEaseOut, animations: {
//                    self.moveButtons[i].transform = buttonScale
//
//                }, completion: nil)
//            }
//
//            // Limit Image Editing Mode
//            for i in 0 ..< limitImageView.count {
//                var translatedX: CGFloat = 0.0
//                var translatedY: CGFloat = 0.0
//                let scale: CGFloat = 0.75
//                let firstTranslatedScale: CGFloat = 0.6
//
//                switch i {
//                case leftLimitImageIndex:
//                    translatedX = marginBetweenLimit - limitImageSizeV * firstTranslatedScale
//                    translatedY = -yOffset
//
//                case rightLimitImageIndex:
//                    translatedX = -marginBetweenLimit + limitImageSizeV * firstTranslatedScale
//                    translatedY = -yOffset
//
//                case upLimitImageIndex:
////                    translatedX = 45
//                    translatedY = marginBetweenLimit - limitImageSizeV * firstTranslatedScale - yOffset
//
//                case downLimitImageIndex:
////                    translatedX = 45 + 90
//                    translatedY = -marginBetweenLimit + limitImageSizeV * firstTranslatedScale - yOffset
//
//                default:
//                    break
//                }
//
//                limitImageView[i].tintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
//                let limitTransform = limitImageView[i].transform.translatedBy(x: translatedX, y: translatedY)
//                let limitScale = limitTransform.scaledBy(x: scale, y: scale)
//
//                UIView.animate(withDuration: durationTime, delay: delayTime, options: .curveEaseOut, animations: {
//                    self.limitImageView[i].transform = limitScale
//
//                }, completion: nil)
//
////                let secondTransform = limitImageView[i].transform.translatedBy(x: 0.0, y: -yOffset)
////                let secondScale = secondTransform.scaledBy(x: 1.0, y: 1.0)
////
////                UIView.animate(withDuration: durationTime + 0.2, delay: durationTime + 0.3, options: .curveLinear, animations: {
////                    self.limitImageView[i].transform = secondScale
////
////                }, completion: nil)
//
//            }
//
//            sender.title = "Done"
//            isPVEditing = true
//        }
//        else {
//            for i in 0 ..< moveButtons.count {
//                UIView.animate(withDuration: durationTime, delay: delayTime, options: .curveEaseInOut, animations: {
//                    self.moveButtons[i].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//
//                }, completion: nil)
//            }
//
//            for i in 0 ..< limitImageView.count {
//                UIView.animate(withDuration: durationTime, delay: delayTime, options: .curveEaseInOut, animations: {
//                    self.limitImageView[i].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//
//                }, completion: nil)
//            }
//            sender.title = "➕"
//            isPVEditing = false
//        }
//    }
    
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

        var horizontalPositionFontSize: CGFloat = 40.0
        var verticalPositionFontSize: CGFloat = 35.0
        
        let height = UIScreen.main.bounds.height
        switch height {
        case 480.0: // 480x320pt 3.5inch (iPhone4s) Not Supported in iEPICS
            editImageName = "Edit_black_4inch"
            checkImageName = "Check_balck_4inch"
            
            horizontalPositionFontSize = 35.0
            verticalPositionFontSize = 30.0
            positionImageSize = 77
            positionImageName = ["Position_horizontal_black_4inch", "Position_vertical_black_4inch"]

            buttonSize = 77
            marginBetweenButton = 85
            marginFromBottom = 170
            moveButtonImageName = ["Motion_left_black_4inch", "Motion_right_black_4inch", "Motion_up_black_4inch", "Motion_down_black_4inch", "Motion_stop_black_4inch"]
            
            limitImageSizeH = 32
            limitImageSizeV = 150
            marginBetweenLimit = 128
            limitImageName = ["Shield_left_black_4inch", "Shield_right_black_4inch", "Shield_up_black_4inch", "Shield_down_black_4inch"]
            
        case 568.0: // 568x320pt 4inch (iPhone5, 5c, 5s, SE)
            editImageName = "Edit_black_4inch"
            checkImageName = "Check_balck_4inch"
            
            horizontalPositionFontSize = 35.0
            verticalPositionFontSize = 30.0
            
            positionImageSize = 77
            positionImageName = ["Position_horizontal_black_4inch", "Position_vertical_black_4inch"]

            buttonSize = 77
            marginBetweenButton = 85
            marginFromBottom = 170
            moveButtonImageName = ["Motion_left_black_4inch", "Motion_right_black_4inch", "Motion_up_black_4inch", "Motion_down_black_4inch", "Motion_stop_black_4inch"]
            
            limitImageSizeH = 32
            limitImageSizeV = 150
            marginBetweenLimit = 128
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
        
        let margins = view.layoutMarginsGuide
        
        positionTextLabel[positionHorizontalIndex].translatesAutoresizingMaskIntoConstraints = false
        positionTextLabel[positionHorizontalIndex].font = UIFont.systemFont(ofSize: horizontalPositionFontSize)
        positionTextLabel[positionHorizontalIndex].centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        positionTextLabel[positionHorizontalIndex].centerYAnchor.constraint(equalTo: margins.topAnchor, constant: 30).isActive = true


        positionTextLabel[positionVerticalIndex].translatesAutoresizingMaskIntoConstraints = false
        positionTextLabel[positionVerticalIndex].font = UIFont.systemFont(ofSize: verticalPositionFontSize)
        positionTextLabel[positionVerticalIndex].centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        positionTextLabel[positionVerticalIndex].centerYAnchor.constraint(equalTo: positionTextLabel[positionHorizontalIndex].bottomAnchor, constant: 30).isActive = true

        for i in 0 ..< positionImageView.count {
            positionImageView[i].image = UIImage(named: positionImageName[i])
            positionImageView[i].image = positionImageView[i].image?.withRenderingMode(.alwaysTemplate)
            positionImageView[i].translatesAutoresizingMaskIntoConstraints = false
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.positionImageViewTapped(sender:)))
            positionImageView[i].isUserInteractionEnabled = true
            positionImageView[i].addGestureRecognizer(tapGesture)
            positionImageView[i].tintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }
        
        positionImageView[positionHorizontalIndex].widthAnchor.constraint(equalToConstant: positionImageSize).isActive = true
        positionImageView[positionHorizontalIndex].heightAnchor.constraint(equalToConstant: positionImageSize).isActive = true
        positionImageView[positionHorizontalIndex].centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: 0).isActive = true
        positionImageView[positionHorizontalIndex].centerYAnchor.constraint(equalTo: positionTextLabel[positionHorizontalIndex].bottomAnchor, constant: 10).isActive = true

        positionImageView[positionVerticalIndex].widthAnchor.constraint(equalToConstant: positionImageSize).isActive = true
        positionImageView[positionVerticalIndex].heightAnchor.constraint(equalToConstant: positionImageSize).isActive = true
        positionImageView[positionVerticalIndex].centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: 0).isActive = true
        positionImageView[positionVerticalIndex].centerYAnchor.constraint(equalTo: positionTextLabel[positionHorizontalIndex].bottomAnchor , constant: 10).isActive = true
        
        for i in 0 ..< moveButtons.count {
            moveButtons[i].setTitle(nil, for: .normal)
            moveButtons[i].setImage(UIImage(named: moveButtonImageName[i])?.withRenderingMode(.alwaysTemplate), for: .normal)
            moveButtons[i].translatesAutoresizingMaskIntoConstraints = false
            moveButtons[i].isEnabled = false
        }
        

        moveButtons[stopButtonIndex].widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[stopButtonIndex].heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[stopButtonIndex].centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: 0).isActive = true
        moveButtons[stopButtonIndex].centerYAnchor.constraint(equalTo: margins.bottomAnchor, constant: -marginFromBottom).isActive = true

        moveButtons[leftButtonIndex].widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[leftButtonIndex].heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[leftButtonIndex].centerXAnchor.constraint(equalTo: moveButtons[stopButtonIndex].centerXAnchor, constant: -marginBetweenButton).isActive = true
        moveButtons[leftButtonIndex].centerYAnchor.constraint(equalTo: moveButtons[stopButtonIndex].centerYAnchor, constant: 0).isActive = true
        
        moveButtons[rightButtonIndex].widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[rightButtonIndex].heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[rightButtonIndex].centerXAnchor.constraint(equalTo: moveButtons[stopButtonIndex].centerXAnchor, constant: marginBetweenButton).isActive = true
        moveButtons[rightButtonIndex].centerYAnchor.constraint(equalTo: moveButtons[stopButtonIndex].centerYAnchor, constant: 0).isActive = true
        
        moveButtons[upButtonIndex].widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[upButtonIndex].heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[upButtonIndex].centerXAnchor.constraint(equalTo: moveButtons[stopButtonIndex].centerXAnchor, constant: 0).isActive = true
        moveButtons[upButtonIndex].centerYAnchor.constraint(equalTo: moveButtons[stopButtonIndex].centerYAnchor, constant: -marginBetweenButton).isActive = true
        
        moveButtons[downButtonIndex].widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[downButtonIndex].heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        moveButtons[downButtonIndex].centerXAnchor.constraint(equalTo: moveButtons[stopButtonIndex].centerXAnchor, constant: 0).isActive = true
        moveButtons[downButtonIndex].centerYAnchor.constraint(equalTo: moveButtons[stopButtonIndex].centerYAnchor, constant: marginBetweenButton).isActive = true


        for i in 0 ..< limitImageView.count {
            limitImageView[i].image = UIImage(named: limitImageName[i])
            limitImageView[i].image = limitImageView[i].image?.withRenderingMode(.alwaysTemplate)
            limitImageView[i].translatesAutoresizingMaskIntoConstraints = false
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.limitImageViewTapped(sender:)))
            limitImageView[i].isUserInteractionEnabled = true
            limitImageView[i].addGestureRecognizer(tapGesture)
            
            limitImageView[i].tintColor = UIColor(red: 0.0, green: 64/255, blue: 125/255, alpha: 0.0)
        }
        
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
        createProcessVariable()
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
    
    private func createProcessVariable() {
        for i in 0 ..< moveButtons.count {
                moveButtons[i].isEnabled = false
        }
        
        let axisEnable1 = UserDefaults.standard.bool(forKey: "MotionHorizontalAxisEnable")
        let axisEnable2 = UserDefaults.standard.bool(forKey: "MotionVerticalAxisEnable")
        
        if axisEnable1 {
            positionTextLabel[0].isHidden = false
            moveButtons[leftButtonIndex].isHidden = false
            moveButtons[rightButtonIndex].isHidden = false
            
            if let position1Name = UserDefaults.standard.string(forKey: keyNameforAxis1[0]) {
                caObject.channelAccessAddProcessVariable(position1Name)
                position1PVName = position1Name
            }
            
            if let leftMoveName = UserDefaults.standard.string(forKey: keyNameforAxis1[1]) {
                caObject.channelAccessAddProcessVariable(leftMoveName)
                lelftPVName = leftMoveName
            }
            
            if let rightMoveName = UserDefaults.standard.string(forKey: keyNameforAxis1[2]) {
                caObject.channelAccessAddProcessVariable(rightMoveName)
                rightPVName = rightMoveName
            }
            
            if let leftLimitName = UserDefaults.standard.string(forKey: keyNameforAxis1[3]) {
                caObject.channelAccessAddProcessVariable(leftLimitName)
                leftLimitPVName = leftLimitName
            }
            
            if let rightLimitName = UserDefaults.standard.string(forKey: keyNameforAxis1[4]) {
                caObject.channelAccessAddProcessVariable(rightLimitName)
                rightLimitPVName = rightLimitName
            }
        }
        else {
            positionTextLabel[0].isHidden = true
            moveButtons[leftButtonIndex].isHidden = true
            moveButtons[rightButtonIndex].isHidden = true
        }
        
        if axisEnable2 {
            positionTextLabel[1].isHidden = false
            moveButtons[upButtonIndex].isHidden = false
            moveButtons[downButtonIndex].isHidden = false
            
            if let position2Name = UserDefaults.standard.string(forKey: keyNameforAxis2[0]) {
                caObject.channelAccessAddProcessVariable(position2Name)
                position2PVName = position2Name
            }
            
            if let upMoveName = UserDefaults.standard.string(forKey: keyNameforAxis2[1]) {
                caObject.channelAccessAddProcessVariable(upMoveName)
                upPVName = upMoveName
            }
            
            if let downMoveName = UserDefaults.standard.string(forKey: keyNameforAxis2[2]) {
                caObject.channelAccessAddProcessVariable(downMoveName)
                downPVName = downMoveName
            }
            
            if let upLimitName = UserDefaults.standard.string(forKey: keyNameforAxis2[3]) {
                caObject.channelAccessAddProcessVariable(upLimitName)
                upLimitPVName = upLimitName
            }
            
            if let downLimitName = UserDefaults.standard.string(forKey: keyNameforAxis2[4]) {
                caObject.channelAccessAddProcessVariable(downLimitName)
                downLimitPVName = downLimitName
            }
        }
        else {
            positionTextLabel[1].isHidden = true
            moveButtons[upButtonIndex].isHidden = true
            moveButtons[downButtonIndex].isHidden = true
        }
        
        if axisEnable1 || axisEnable2 {
            moveButtons[stopButtonIndex].isHidden = false

            if let stopMovePVName = UserDefaults.standard.string(forKey: keyNameforStop) {
                caObject.channelAccessAddProcessVariable(stopMovePVName)
                stopPVName = stopMovePVName
            }
        }
        else {
            moveButtons[stopButtonIndex].isHidden = true
        }
    }
    
    @objc private func positionImageViewTapped(sender: UITapGestureRecognizer) {
        if isPVEditing {
            if let positionImageViewFromSender = sender.view as? UIImageView {
                let positionViewIndex = positionImageView.index(of: positionImageViewFromSender)
                var positionPV: String?
                var positionName: String?
                switch positionViewIndex {
                case positionHorizontalIndex:
                    positionName = "Horizontal Position"
                    keyNameforSegue = keyNameforAxis1[0]
                    positionPV = UserDefaults.standard.string(forKey: keyNameforSegue!)
                    
                case positionVerticalIndex:
                    positionName = "Vertical Position"
                    keyNameforSegue = keyNameforAxis2[0]
                    positionPV = UserDefaults.standard.string(forKey: keyNameforSegue!)
                    
                default:
                    break
                }
                
                let positionInfoArray: [String?] = [positionName, positionPV]
                performSegue(withIdentifier: "changeElementViewController", sender: positionInfoArray)
            }
        }
    }
    
    @objc private func limitImageViewTapped(sender: UITapGestureRecognizer) {
        if isPVEditing {
            if let limitImageViewFromSender = sender.view as? UIImageView {
                let imageViewIndex = limitImageView.index(of: limitImageViewFromSender)
                var limitPV: String?
                var limitName: String?
                switch imageViewIndex {
                case leftLimitImageIndex:
                    limitName = "Limit Left"
                    keyNameforSegue = keyNameforAxis1[3]
                    limitPV = UserDefaults.standard.string(forKey: keyNameforSegue!)
                    
                case rightLimitImageIndex:
                    limitName = "Limit Right"
                    keyNameforSegue = keyNameforAxis1[4]
                    limitPV = UserDefaults.standard.string(forKey: keyNameforSegue!)
                    
                case upLimitImageIndex:
                    limitName = "Limit Up"
                    keyNameforSegue = keyNameforAxis2[3]
                    limitPV = UserDefaults.standard.string(forKey: keyNameforSegue!)
                    
                case downLimitImageIndex:
                    limitName = "Limit Down"
                    keyNameforSegue = keyNameforAxis2[4]
                    limitPV = UserDefaults.standard.string(forKey: keyNameforSegue!)
                    
                default:
                    limitName = ""
                    limitPV = ""
                    keyNameforSegue = nil
                    break
                }
                
                let limitInfoArray: [String?] = [limitName, limitPV]
                performSegue(withIdentifier: "changeElementViewController", sender: limitInfoArray)
            }
        }
        else {
            
        }
    }
    
//    private func createMoveTextField(_ index: Int, _ xPosition: CGFloat, _ yPosition: CGFloat) {
//        switch index {
//        case 0:
//            leftMoveTextField = UITextField(frame: CGRect(x: xPosition, y: yPosition, width: textFieldWidth, height: textFieldHeight))
//            leftMoveTextField?.font = UIFont.systemFont(ofSize: 14)
//            leftMoveTextField?.borderStyle = UITextBorderStyle.roundedRect
//            leftMoveTextField?.autocorrectionType = UITextAutocorrectionType.no
//            leftMoveTextField?.keyboardType = UIKeyboardType.default
//            leftMoveTextField?.returnKeyType = UIReturnKeyType.done
//            leftMoveTextField?.clearButtonMode = UITextFieldViewMode.whileEditing;
//            leftMoveTextField?.contentVerticalAlignment = UIControlContentVerticalAlignment.center
//            leftMoveTextField?.delegate = self
//            view.addSubview(leftMoveTextField!)
//        case 1:
//            rightMoveTextField = UITextField(frame: CGRect(x: xPosition, y: yPosition, width: textFieldWidth, height: textFieldHeight))
//            rightMoveTextField?.font = UIFont.systemFont(ofSize: 14)
//            rightMoveTextField?.borderStyle = UITextBorderStyle.roundedRect
//            rightMoveTextField?.autocorrectionType = UITextAutocorrectionType.no
//            rightMoveTextField?.keyboardType = UIKeyboardType.default
//            rightMoveTextField?.returnKeyType = UIReturnKeyType.done
//            rightMoveTextField?.clearButtonMode = UITextFieldViewMode.whileEditing;
//            rightMoveTextField?.contentVerticalAlignment = UIControlContentVerticalAlignment.center
//            rightMoveTextField?.delegate = self
//            view.addSubview(rightMoveTextField!)
//        case 2:
//            upMoveTextField = UITextField(frame: CGRect(x: xPosition, y: yPosition, width: textFieldWidth, height: textFieldHeight))
//            upMoveTextField?.font = UIFont.systemFont(ofSize: 14)
//            upMoveTextField?.borderStyle = UITextBorderStyle.roundedRect
//            upMoveTextField?.autocorrectionType = UITextAutocorrectionType.no
//            upMoveTextField?.keyboardType = UIKeyboardType.default
//            upMoveTextField?.returnKeyType = UIReturnKeyType.done
//            upMoveTextField?.clearButtonMode = UITextFieldViewMode.whileEditing;
//            upMoveTextField?.contentVerticalAlignment = UIControlContentVerticalAlignment.center
//            upMoveTextField?.delegate = self
//            view.addSubview(upMoveTextField!)
//        case 3:
//            downMoveTextField = UITextField(frame: CGRect(x: xPosition, y: yPosition, width: textFieldWidth, height: textFieldHeight))
//            downMoveTextField?.font = UIFont.systemFont(ofSize: 14)
//            downMoveTextField?.borderStyle = UITextBorderStyle.roundedRect
//            downMoveTextField?.autocorrectionType = UITextAutocorrectionType.no
//            downMoveTextField?.keyboardType = UIKeyboardType.default
//            downMoveTextField?.returnKeyType = UIReturnKeyType.done
//            downMoveTextField?.clearButtonMode = UITextFieldViewMode.whileEditing;
//            downMoveTextField?.contentVerticalAlignment = UIControlContentVerticalAlignment.center
//            downMoveTextField?.delegate = self
//            view.addSubview(downMoveTextField!)
//        default:
//            break
//        }
//    }
    
//    private func createLimitTextField(_ index: Int, _ xPosition: CGFloat, _ yPosition: CGFloat) {
//        switch index {
//        case 0:
//            leftLimitTextField = UITextField(frame: CGRect(x: xPosition, y: yPosition, width: textFieldWidth, height: textFieldHeight))
//            leftLimitTextField?.font = UIFont.systemFont(ofSize: 14)
//            leftLimitTextField?.borderStyle = UITextBorderStyle.roundedRect
//            leftLimitTextField?.autocorrectionType = UITextAutocorrectionType.no
//            leftLimitTextField?.keyboardType = UIKeyboardType.default
//            leftLimitTextField?.returnKeyType = UIReturnKeyType.done
//            leftLimitTextField?.clearButtonMode = UITextFieldViewMode.whileEditing;
//            leftLimitTextField?.contentVerticalAlignment = UIControlContentVerticalAlignment.center
//            leftLimitTextField?.delegate = self
//            view.addSubview(leftLimitTextField!)
//        case 1:
//            rightLimitTextField = UITextField(frame: CGRect(x: xPosition, y: yPosition, width: textFieldWidth, height: textFieldHeight))
//            rightLimitTextField?.font = UIFont.systemFont(ofSize: 14)
//            rightLimitTextField?.borderStyle = UITextBorderStyle.roundedRect
//            rightLimitTextField?.autocorrectionType = UITextAutocorrectionType.no
//            rightLimitTextField?.keyboardType = UIKeyboardType.default
//            rightLimitTextField?.returnKeyType = UIReturnKeyType.done
//            rightLimitTextField?.clearButtonMode = UITextFieldViewMode.whileEditing;
//            rightLimitTextField?.contentVerticalAlignment = UIControlContentVerticalAlignment.center
//            rightLimitTextField?.delegate = self
//            view.addSubview(rightLimitTextField!)
//        case 2:
//            upMoveLimitField = UITextField(frame: CGRect(x: xPosition, y: yPosition, width: textFieldWidth, height: textFieldHeight))
//            upMoveLimitField?.font = UIFont.systemFont(ofSize: 14)
//            upMoveLimitField?.borderStyle = UITextBorderStyle.roundedRect
//            upMoveLimitField?.autocorrectionType = UITextAutocorrectionType.no
//            upMoveLimitField?.keyboardType = UIKeyboardType.default
//            upMoveLimitField?.returnKeyType = UIReturnKeyType.done
//            upMoveLimitField?.clearButtonMode = UITextFieldViewMode.whileEditing;
//            upMoveLimitField?.contentVerticalAlignment = UIControlContentVerticalAlignment.center
//            upMoveLimitField?.delegate = self
//            view.addSubview(upMoveLimitField!)
//        case 3:
//            downLimitTextField = UITextField(frame: CGRect(x: xPosition, y: yPosition, width: textFieldWidth, height: textFieldHeight))
//            downLimitTextField?.font = UIFont.systemFont(ofSize: 14)
//            downLimitTextField?.borderStyle = UITextBorderStyle.roundedRect
//            downLimitTextField?.autocorrectionType = UITextAutocorrectionType.no
//            downLimitTextField?.keyboardType = UIKeyboardType.default
//            downLimitTextField?.returnKeyType = UIReturnKeyType.done
//            downLimitTextField?.clearButtonMode = UITextFieldViewMode.whileEditing;
//            downLimitTextField?.contentVerticalAlignment = UIControlContentVerticalAlignment.center
//            downLimitTextField?.delegate = self
//            view.addSubview(downLimitTextField!)
//        default:
//            break
//        }
//    }
    

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
            case upLimitPVName:
                limitImageIndex = 2
            case downLimitPVName:
                limitImageIndex = 3
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
                            UIView.animate(withDuration: 0.3, animations: ({
                                self.limitImageView[limitIndex].tintColor = UIColor(red: 0.0, green: 100/255, blue: 180/255, alpha: 0.0)
                            }))
                        }
                        else {
                            UIView.animate(withDuration: 0.3, animations: ({
                                self.limitImageView[limitIndex].tintColor = UIColor(red: 0.0, green: 100/255, blue: 180/255, alpha: 1.0)
                                }))

                            self.moveButtons[limitIndex].shake(duration: 0.4, values: [-12.0, 12.0, -12.0, 12.0, -6.0, 6.0, -3.0, 3.0, 0.0])
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
//                            self.positionTextLabel[positionIndex].text = "Connected"
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
        createProcessVariable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeElementViewController" {
            let changeElementView: ChangeElementViewController = segue.destination as! ChangeElementViewController
            changeElementView.delegate = self
            
            let changePVInfoArray: [String?] = sender as! [String?]
            changeElementView.changePVTitle = changePVInfoArray[0] // selected button or limit image
            changeElementView.currentPVName = changePVInfoArray[1] // current PV name that is selected
        }
    }
    
    func changeProcessVariable(oldPVName: String?, newPVName: String?) {
        if oldPVName != newPVName, let keyName = keyNameforSegue {
            UserDefaults.standard.set(newPVName, forKey: keyName)
            keyNameforSegue = nil
        }
    }
}

extension UIView {
    
    // Using CAMediaTimingFunction
    func shake(duration: TimeInterval = 0.5, values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = duration // You can set fix duration
        animation.values = values  // You can set fix values here also
        self.layer.add(animation, forKey: "shake")
    }
    
    
    // Using SpringWithDamping
    func shake(duration: TimeInterval = 0.5, xValue: CGFloat = 12, yValue: CGFloat = 0) {
        self.transform = CGAffineTransform(translationX: xValue, y: yValue)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
        
    }
    
    // Using CABasicAnimation
    func shake(duration: TimeInterval = 0.05, shakeCount: Float = 6, xValue: CGFloat = 12, yValue: CGFloat = 0){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = shakeCount
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - xValue, y: self.center.y - yValue))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + xValue, y: self.center.y - yValue))
        self.layer.add(animation, forKey: "shake")
    }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        switch textField {
//        case leftMoveTextField:
//            print("Left Move PV Nmae")
//        case rightMoveTextField:
//            print("right Move PV Nmae")
//        case upMoveTextField:
//            print("up Move PV Nmae")
//        case downMoveTextField:
//            print("down Move PV Nmae")
//        default:
//            break;
//        }
        print("TextField did enter return")
        self.view.endEditing(true)
        return true
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // return NO to not change text
//        print("While entering the characters this method gets called")
//        return true
//    }
}

