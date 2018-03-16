//
//  ChannelAccessNotification.swift
//  iEPICS
//
//  Created by ctrl user on 01/11/2017.
//  Copyright © 2017 scwook. All rights reserved.
//

import Foundation

class ChannelAccessNotification: NSObject {
    @objc func EventCallbackToSwift(pvName: NSString) {
        NotificationCenter.default.post(name: Notification.Name("EventCallbackNotification"), object: pvName)
    }
    
    @objc func ConnectionCallbackToSwift(message: NSString) {
        NotificationCenter.default.post(name: Notification.Name("ConnectionCallbackNotification"), object: message)
    }
    
    @objc func ErrorCallbackToSwift(message: NSString) {
        NotificationCenter.default.post(name: Notification.Name("ErrorCallbackNotification"), object: message)
    }
    
    @objc func MaxPVCallbackToSwift(message: NSString) {
        NotificationCenter.default.post(name: Notification.Name("MaxPVCallbackNotification"), object: message)
    }
}
