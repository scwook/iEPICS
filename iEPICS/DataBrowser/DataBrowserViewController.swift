//
//  DataBrowserViewController.swift
//  iEPICS
//
//  Created by ctrl user on 23/11/2017.
//  Copyright © 2017 scwook. All rights reserved.
//

import UIKit

class DataBrowserViewController: UIViewController, NewElementDataDelegate {
    
    let caObject = ChannelAccessClient.sharedObject()!
    var pvValueArray = NSMutableArray()
    var drawTimer: Timer?
    
    let maxArraySize = 1000
    var pv: String? = nil
    var startDrawing = false
    
    var isArchiveEnabled = false
    var archiveServerURL: String?
    let getData = "/retrieval/data/getData"
    let getAllPVs = "/mgmt/bpl/getAllPVs"
    let getPVState = "/mgmt/bpl/getPVStatus"
    
    let caConnectionNotification = Notification.Name("ConnectionCallbackNotification")
    let caEventNotification = Notification.Name("EventCallbackNotification")
    
    var caEventNotificationProtocol: NSObjectProtocol?
    var caConnectionNotificationProtocol: NSObjectProtocol?
    var appOrientationDidChangeProtocol: NSObjectProtocol?
    var appDidEnterBackgroundProtocol: NSObjectProtocol?
    var appWillEnterForegroundProtocol: NSObjectProtocol?
    
    let dateFormatter = DateFormatter()
    
    let drawTimeInterval: TimeInterval = 1.0
    
    @IBOutlet weak var dataDrawView: DataDrawView!
    @IBOutlet weak var axisDrawView: AxisDrawView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        archiveServerURL = UserDefaults.standard.string(forKey: "ArchiveServerURL")

        if archiveServerURL != nil {
            let url = URL(string: archiveServerURL!)
            do {
                _ = try String(contentsOf: url!)
                isArchiveEnabled = true
            } catch {
//                errorMessage(message: "Can Not Access to Server")
            }
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        print("DataBrowser ViewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {

        print("DataBrowser ViewWillAppear")

    }
    override func viewDidAppear(_ animated: Bool) {
        caEventNotificationProtocol = NotificationCenter.default.addObserver(forName: caEventNotification, object: nil, queue: nil, using: catchEventNotification)
        caConnectionNotificationProtocol = NotificationCenter.default.addObserver(forName: caConnectionNotification, object: nil, queue: nil, using: catchConnectionNotification)
        appOrientationDidChangeProtocol = NotificationCenter.default.addObserver(forName: Notification.Name.UIDeviceOrientationDidChange, object: nil, queue: OperationQueue.main, using: rotated)
        appDidEnterBackgroundProtocol = NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationDidEnterBackground, object: nil, queue: OperationQueue.main, using: applicationDidEnterBackground)
        appWillEnterForegroundProtocol = NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.main, using: applicationWillEnterForeground)
        
        caObject.channelAccessContextCreate()
        
        if let pvName = pv {
            self.title = pvName
            addNewProcessVariable(pvName: pvName)
        }
        
        print("DataBrowser ViewDidAppear")

    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(self)
        if let timer = drawTimer {
            timer.invalidate()
        }
        
        if let eventNotificationProtocol = caEventNotificationProtocol {
            NotificationCenter.default.removeObserver(eventNotificationProtocol)
        }
        
        if let connectionNotificationProtocol = caConnectionNotificationProtocol {
            NotificationCenter.default.removeObserver(connectionNotificationProtocol)
        }
        
        if let orientationDidChangeProtocol = appOrientationDidChangeProtocol {
            NotificationCenter.default.removeObserver(orientationDidChangeProtocol)
        }
        
        if let enterBackgroundProtocol = appDidEnterBackgroundProtocol {
            NotificationCenter.default.removeObserver(enterBackgroundProtocol)
        }
        
        if let foregroundProtocol = appWillEnterForegroundProtocol {
            NotificationCenter.default.removeObserver(foregroundProtocol)
        }
        
        caObject.channelAccessAllClear()
        caObject.channelAccessContexDestroy()

        print("DataBrowser ViewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        print("DataBrowser ViewDidDisappear")

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon

        //dataDrawView.frame.size.width = axisDrawView.frame.size.width
        dataDrawView.frame.size.height = axisDrawView.frame.size.height - 26
        dataBrowserModel.drawViewSize = dataDrawView.frame
    }

    private func startDataBrowser(pvName: String) -> Void {
        let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon

//        Timer Method
        if let pvNameDictionary = caObject.channelAccessGetDictionary() {
            if pvNameDictionary.count != 0 {
//                let myData = pvNameDictionary[pvName] as! ChannelAccessData
//                let value = myData.value as NSMutableArray
                
//  Because element count of data at first is always 0, Following line will cause waveform drawing at first time.
//                dataBrowserModel.elementCount = value.count

                drawTimer = Timer.scheduledTimer(withTimeInterval: drawTimeInterval, repeats: true) { timer in
                    if( self.startDrawing ) {
                        // In case of array
//                        if (value.count > 1) {
//                            dataBrowserModel.elementCount = value.count
//                            let arrayValue = value.map{ ($0 as! NSString).doubleValue }
//
//                            self.dataDrawView.data = arrayValue
//                        }
                        // In case of single value
//                        else {
//                            dataBrowserModel.elementCount = value.count
//
//                            let currentValue = (value[0] as? NSString)?.doubleValue
//                            let currentTimestamp = Int(myData.timeStampSince1990 + 631152000) // Convert to Timestamp Since 1970

//                            if let lastValue = self.dataDrawView.data.last, let lastTimestamp = self.dataDrawView.time.last {
//                                let timeDiff = currentTimestamp - lastTimestamp
//                                if( timeDiff > 1 ) {
//                                    for i in 1..<timeDiff {
//                                        self.dataDrawView.data.append(lastValue)
//                                        self.dataDrawView.time.append(lastTimestamp + i)
//                                    }
//                                }
//                            }
                        
//                            if(self.dataDrawView.data.count > self.maxArraySize) {
//                                let overCount = self.dataDrawView.data.count - self.maxArraySize
//                                for _ in 0 ..< overCount {
//                                    self.dataDrawView.data.remove(at: 0)
//                                    self.dataDrawView.time.remove(at: 0)
//                                }
//                            }
                        
//                            self.dataDrawView.data.append(currentValue!)
//                            self.dataDrawView.time.append(currentTimestamp)
                        
                            if( self.dataDrawView.data.count == 2) {
                                dataBrowserModel.setAutoViewSize(self.dataDrawView.data)
                            }
//                        }
                        
                        dataBrowserModel.timeOffset += self.drawTimeInterval
                        
                        self.dataDrawView.setNeedsDisplay()
                        self.axisDrawView.setNeedsDisplay()
                    }
                }
            }
        }
    }
    
    //***********
    func addNewProcessVariable(pvName: String) {
        
        if startDrawing {
            startDrawing = false
        }
        
        if let timer = drawTimer {
            timer.invalidate()
        }
        
        caObject.channelAccessAllClear()
        
        if let drawView = dataDrawView {
            drawView.data.removeAll()
            drawView.time.removeAll()
        }
        
        pvValueArray.removeAllObjects()
        
        pv = pvName
        caObject.channelAccessAddProcessVariable(pvName)
        self.title = pvName
        
        let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon
        dataBrowserModel.timeOffset = Date().timeIntervalSince1970
        
//        if isArchiveEnabled {
//            let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon
//            let initArchiveTimeRange = TimeInterval(dataBrowserModel.timeRange)
//            retrieveArchiveData(pvName: pv!, from: -initArchiveTimeRange, to: 0)
//        }
        
        startDataBrowser(pvName: pvName)
    }
    
    private func retrieveArchiveData(pvName: String, from: TimeInterval, to: TimeInterval) -> Void {
        if let serverURL = archiveServerURL {
            let getDataFrom = dateFormatter.string(from: Date().addingTimeInterval(from))
            let getDataTo = dateFormatter.string(from: Date().addingTimeInterval(to))
            
            let getDataFromURLEncode = getDataFrom.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserved)
            let getDataToURLEncode = getDataTo.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserved)
            
            let pvNameURLEncode = pvName.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserved)
            
            let searchingName = serverURL + getData + ".csv" + "?pv=" + pvNameURLEncode! + "&from=" + getDataFromURLEncode! + "&to=" + getDataToURLEncode!
//            var time = [Int]()
//            var value = [Double]()
            
            if let url = URL(string: searchingName) {
                do {
                    let rawData = try String(contentsOf: url)
                    
                    if let drawView = dataDrawView {
                        drawView.data.removeAll()
                        drawView.time.removeAll()
                    }
                    
                    let split = rawData.split(separator: "\n")
                    for i in 0 ..< split.count {
                        let spliteData = split[i].split(separator: ",")
                        if Int(spliteData[0]) != dataDrawView.time.last {
                            dataDrawView.time.append(Int(spliteData[0])!)
                            dataDrawView.data.append(Double(spliteData[1])!)
                        }
                    }
                } catch {
                    print("Cannot load contents")
                }
            }
        }
    }
    
    private func rotated(notification:Notification) -> Void {
        let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon
        
        dataBrowserModel.drawViewSize = dataDrawView.frame
        dataBrowserModel.axisViewSize = axisDrawView.frame
        
        dataDrawView.setNeedsDisplay()
        axisDrawView.setNeedsDisplay()
        
    }

    @IBAction func pinchGestureRecognizer(_ sender: UIPinchGestureRecognizer) {
        let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon

        if( dataBrowserModel.elementCount > 1 ) {
            
        }
        else {
            if sender.view != nil {
                let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon
                let deltaY = abs(dataBrowserModel.value2 - dataBrowserModel.value1)
                let const = deltaY / dataBrowserModel.timeRange
                
                if( sender.scale > 1) {
                    
                    let dT = 4 * sender.scale
                    let secondForOnMinute: CGFloat = 60
                    dataBrowserModel.timeRange -= dT
                    
                    if( dataBrowserModel.timeRange <= secondForOnMinute ) {
                        dataBrowserModel.timeRange = CGFloat(secondForOnMinute)
                    }
                    
                    let dY = -(const * dataBrowserModel.timeRange - deltaY) / 2
                    
                    dataBrowserModel.value1 += dY
                    dataBrowserModel.value2 -= dY
                }
                else {
                    let dT = 4 / sender.scale
                    let secondForOneDay: CGFloat = 60.0 * 60.0
                    
                    dataBrowserModel.timeRange += dT
                    
                    if( dataBrowserModel.timeRange >= secondForOneDay ) {
                        dataBrowserModel.timeRange = CGFloat(secondForOneDay)
                    }
                    
                    let dY = (const * dataBrowserModel.timeRange - deltaY) / 2
                    
                    dataBrowserModel.value1 -= dY
                    dataBrowserModel.value2 += dY
                }
                
//                if isArchiveEnabled {
//                    let getDataOffsetTo = dataBrowserModel.timeOffset
//                    let getDataOffsetFrom = getDataOffsetTo - TimeInterval(dataBrowserModel.timeRange)
//                    retrieveArchiveData(pvName: pv!, from: getDataOffsetFrom, to: getDataOffsetTo)
//                    drawTimer?.invalidate()
//
//                    print(dataDrawView.time.count)
//                }
                
                dataDrawView.setNeedsDisplay()
                axisDrawView.setNeedsDisplay()
                
                sender.scale = 1
            }
        }
    }
    
    @IBAction func panGestureRecognizer(_ sender: UIPanGestureRecognizer) {
        let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon
        
        if( dataBrowserModel.elementCount > 1 ) {
            
        }
        else {
            let translation = sender.translation(in: self.view)
            //let velocity = sender.velocity(in: self.view)
            
            switch sender.state {
            case .began, .changed:
                if let timer = drawTimer {
                    timer.invalidate()
                }
                
                dataBrowserModel.value1 += (translation.y / dataBrowserModel.getDyInfoValue().dy)
                dataBrowserModel.value2 += (translation.y / dataBrowserModel.getDyInfoValue().dy)
                
                dataBrowserModel.timeOffset -= TimeInterval(translation.x / dataBrowserModel.getDxInfoValue().dx)
                
                sender.setTranslation(CGPoint.zero, in: self.view)
                
            case .ended:
                sender.setTranslation(CGPoint.zero, in: self.view)
                if let pvName = pv {
                    startDataBrowser(pvName: pvName)
                }
                
            //print(velocityScale)
            default:
                break
            }
            
//            if isArchiveEnabled {
//                let getDataOffsetTo = dataBrowserModel.timeOffset
//                let getDataOffsetFrom = getDataOffsetTo - TimeInterval(dataBrowserModel.timeRange)
//                retrieveArchiveData(pvName: pv!, from: getDataOffsetFrom, to: getDataOffsetTo)
//                drawTimer?.invalidate()
//            }
            
            dataDrawView.setNeedsDisplay()
            axisDrawView.setNeedsDisplay()
        }
    }
    
    @IBAction func longPressGestureRecognizer(_ sender: UILongPressGestureRecognizer) {
        let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon
        
        if( dataBrowserModel.elementCount > 1 ) {
            
        }
        else {
            switch sender.state {
            case .began:
                dataBrowserModel.isLongPressed = true
                dataBrowserModel.longPressedLocation = sender.location(in: dataDrawView)
                
            case .changed:
                dataBrowserModel.longPressedLocation = sender.location(in: dataDrawView)

            case .ended:
                dataBrowserModel.isLongPressed = false
                dataDrawView.probeIndex = nil
                
            default:
                break
            }
            
            dataDrawView.setNeedsDisplay()
            axisDrawView.setNeedsDisplay()
        }
    }
    
    @IBAction func tapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        sender.numberOfTapsRequired = 2
        let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon
        dataBrowserModel.setAutoViewSize(self.dataDrawView.data)

//        if( dataBrowserModel.elementCount > 1 ) {
//            dataBrowserModel.setAutoViewSize(self.dataDrawView.arrayData)
//        }
//        else {
//            dataBrowserModel.setAutoViewSize(self.dataDrawView.data)
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newElementViewController" {
            let newElementView: NewElementViewController = segue.destination as! NewElementViewController
            newElementView.delegate = self
            newElementView.lastPVName = self.title
        }
    }
    
    //********* Notification *************
    private func catchEventNotification(notification:Notification) -> Void {
        if let pvNameDictionary = caObject.channelAccessGetDictionary(), let pvName = pv {
            if pvNameDictionary.count != 0 {
                let myData = pvNameDictionary[pvName] as! ChannelAccessData
                let value = myData.value as NSMutableArray
                let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon

                if (value.count > 1) {
                    dataBrowserModel.elementCount = value.count
                    let arrayValue = value.map{ ($0 as! NSString).doubleValue }
                    
                    self.dataDrawView.data = arrayValue
                }
                
                else {
                    dataBrowserModel.elementCount = value.count
                    
                    let currentValue = (value[0] as? NSString)?.doubleValue
                    let currentTimestamp = Int(myData.timeStampSince1990 + 631152000) // Convert to Timestamp Since 1970
                    let nSecTime = CGFloat(myData.timeStampNanoSec) / 1000000000
                    
//                    if let lastValue = self.dataDrawView.data.last, let lastTimestamp = self.dataDrawView.time.last {
//                        let timeDiff = currentTimestamp - lastTimestamp
//                        if( timeDiff > 1 ) {
//                            for i in 1..<timeDiff {
//                                self.dataDrawView.data.append(lastValue)
//                                self.dataDrawView.time.append(lastTimestamp + i)
//                            }
//                        }
//                    }
                    
                    if(self.dataDrawView.data.count > self.maxArraySize) {
                        let overCount = self.dataDrawView.data.count - self.maxArraySize
                        for _ in 0 ..< overCount {
                            self.dataDrawView.data.remove(at: 0)
                            self.dataDrawView.time.remove(at: 0)
                        }
                    }
                    
                    self.dataDrawView.data.append(currentValue!)
                    self.dataDrawView.time.append(currentTimestamp)
                    self.dataDrawView.nSecTime.append(nSecTime)
                }
            }
        }
    }
    
    private func catchConnectionNotification(notification:Notification) -> Void {
        if let caMessage = notification.object as? String {
            if caMessage == pv {
                startDrawing = true
                self.title = pv
            }
            else {
                startDrawing = false
                self.title = "Disconnected"
            }
        }
    }
    
    private func applicationDidEnterBackground(notification:Notification) -> Void {
        print("DidEnterBackground")
        //        self.viewWillDisappear(false)
        if let timer = drawTimer {
            timer.invalidate()
        }
        
        caObject.channelAccessAllClear()
        caObject.channelAccessContexDestroy()
    }
    
    private func applicationWillEnterForeground(notification:Notification) -> Void {
        print("WillenterForeground")
        //        self.viewWillAppear(false)
        
        caObject.channelAccessContextCreate()
        
        if let pvName = pv {
            self.title = pvName
            addNewProcessVariable(pvName: pvName)
        }
    }
    
    //********* Rotation *************
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscape]
    }
}

extension CharacterSet {
    static let rfc3986Unreserved = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
}
