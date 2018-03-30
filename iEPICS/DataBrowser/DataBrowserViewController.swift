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
    
    let maxArraySize = 100
    var pv: String? = nil
    var startDrawing = false
    
    let caConnectionNotification = Notification.Name("ConnectionCallbackNotification")

    var caConnectionNotificationProtocol: NSObjectProtocol?
    var appOrientationDidChangeProtocol: NSObjectProtocol?
    var appDidEnterBackgroundProtocol: NSObjectProtocol?
    var appWillEnterForegroundProtocol: NSObjectProtocol?
    
    @IBOutlet weak var dataDrawView: DataDrawView!
    @IBOutlet weak var axisDrawView: AxisDrawView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.shouldRotate = true
        
        
//        self.title = pv
        
        // Do any additional setup after loading the view, typically from a nib.
        print("DataBrowser ViewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {

        print("DataBrowser ViewWillAppear")

    }
    override func viewDidAppear(_ animated: Bool) {
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
                let myData = pvNameDictionary[pvName] as! ChannelAccessData
                let value = myData.value as NSMutableArray
                
//  Because element count of data at first is always 0, Following line will cause waveform drawing at first time.
//                dataBrowserModel.elementCount = value.count

                drawTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    if( self.startDrawing ) {
                        if (value.count > 1) {
                            dataBrowserModel.elementCount = value.count
                            let arrayValue = value.map{ ($0 as! NSString).doubleValue }
                            
//                            self.dataDrawView.arrayData = arrayValue
                            self.dataDrawView.data = arrayValue
                        }
                        else {
                            dataBrowserModel.elementCount = value.count

                            let currentValue = (value[0] as? NSString)?.doubleValue
                            let currentTimestamp = Int(myData.timeStampSince1990 + 631152000)
                            
                            if let lastValue = self.dataDrawView.data.last, let lastTimestamp = self.dataDrawView.time.last {
                                let timeDiff = currentTimestamp - lastTimestamp
                                if( timeDiff > 1 ) {
                                    for i in 1..<timeDiff {
                                        self.dataDrawView.data.append(lastValue)
                                        self.dataDrawView.time.append(lastTimestamp + i)
                                    }
                                }
                            }
                            
                            if(self.dataDrawView.data.count > self.maxArraySize) {
                                let overCount = self.dataDrawView.data.count - self.maxArraySize
                                for _ in 0 ..< overCount {
                                    self.dataDrawView.data.remove(at: 0)
                                    self.dataDrawView.time.remove(at: 0)
                                }
                            }
                            
                            self.dataDrawView.data.append(currentValue!)
                            self.dataDrawView.time.append(currentTimestamp)
                            
                            if( self.dataDrawView.data.count == 2) {
                                dataBrowserModel.setAutoViewSize(self.dataDrawView.data)
                            }
                        }
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
            //            drawView.arrayData.removeAll()
        }
        
        pvValueArray.removeAllObjects()
        
        //        caObject.channelAccessSetGet(pvValueArray)
        pv = pvName
        caObject.channelAccessAddProcessVariable(pvName)
        self.title = pvName
        
        //        self.title = pvName
        startDataBrowser(pvName: pvName)
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
//                dataBrowserModel.value1 += (translation.y / dataBrowserModel.getDyInfoValue().dy)
//                dataBrowserModel.value2 += (translation.y / dataBrowserModel.getDyInfoValue().dy)
                dataBrowserModel.value1 += (translation.y / dataBrowserModel.test().dy)
                dataBrowserModel.value2 += (translation.y / dataBrowserModel.test().dy)
                
                dataBrowserModel.timeOffset -= TimeInterval(translation.x / dataBrowserModel.getDxInfoValue().dx)
                
                sender.setTranslation(CGPoint.zero, in: self.view)
                
            case .ended:
                sender.setTranslation(CGPoint.zero, in: self.view)
            //print(velocityScale)
            default:
                break
            }
            
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
                dataDrawView.setNeedsDisplay()
                
            case .changed:
                dataBrowserModel.longPressedLocation = sender.location(in: dataDrawView)
                dataDrawView.setNeedsDisplay()
                
            case .ended:
                dataBrowserModel.isLongPressed = false
                dataDrawView.probeIndex = nil
                dataDrawView.setNeedsDisplay()
                
            default:
                break
            }
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
    private func catchConnectionNotification(notification:Notification) -> Void {
        if let caMessage = notification.object as? String {
            if caMessage == "Connected" {
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
