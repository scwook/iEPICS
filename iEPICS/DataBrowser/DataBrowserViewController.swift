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
    var pv: String? = "Data Browser" {
        didSet {
            addNewProcessVariable(pvName: pv!)
        }
    }
    
    @IBOutlet weak var dataDrawView: DataDrawView!
    @IBOutlet weak var axisDrawView: AxisDrawView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        caObject.channelAccessContextCreate()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.shouldRotate = true
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIDeviceOrientationDidChange, object: nil, queue: OperationQueue.main, using: rotated)
        
        let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon
        
        dataBrowserModel.drawViewSize = dataDrawView.frame
        dataBrowserModel.axisViewSize = axisDrawView.frame
        
        self.title = pv
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func startDataBrowser(pvName: String) -> Void {
        let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon
        
        if let timer = drawTimer {
            timer.invalidate()
        }
        
       // DispatchQueue.global().async {

            let elementCount = self.caObject.channelAccessCreateChannel(pvName)
            dataBrowserModel.elementCount = elementCount
            
            if( elementCount > 1 ) {
//                while true {
                drawTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    self.dataDrawView.arrayData = self.caObject.channelAccessGetArray() as! [Double]
                    
//                    DispatchQueue.main.async {
                        self.dataDrawView.setNeedsDisplay()
                        self.axisDrawView.setNeedsDisplay()
//                    }
                }
//                    sleep(dataBrowserModel.refreshRate)
//                }
            }
            else {
//                while true {
                drawTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in

                self.caObject.channelAccessGet()
                    //                let value = Int(arc4random_uniform(100000))
                    //                let timeStamp = Date()
                    
                    if(self.dataDrawView.data.count > self.maxArraySize) {
                        self.dataDrawView.data.remove(at: 0)
                        self.dataDrawView.time.remove(at: 0)
                        
                    }
                    
                    self.dataDrawView.data.append(self.pvValueArray[0] as! Double)
                    //self.dataDrawView.time.append(Int(timeStamp.timeIntervalSince1970))
                    self.dataDrawView.time.append(self.pvValueArray[1] as! Int + 631152000)
                    
                    if( self.dataDrawView.data.count == 2) {
                        dataBrowserModel.setAutoViewSize(self.dataDrawView.data)
                    }
                    
                    //DispatchQueue.main.async {
                        self.dataDrawView.setNeedsDisplay()
                        self.axisDrawView.setNeedsDisplay()
                    //}
                }
//                    sleep(dataBrowserModel.refreshRate)
//                }
            }
       // }
    }
    
    private func rotated(notification:Notification) -> Void {
        let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon
        
        dataBrowserModel.drawViewSize = dataDrawView.frame
        dataBrowserModel.axisViewSize = axisDrawView.frame
        
        dataDrawView.setNeedsDisplay()
        axisDrawView.setNeedsDisplay()    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pinchGestureRecognizer(_ sender: UIPinchGestureRecognizer) {
        let dataBrowserModel = DataBrowserModel.DataBrowserModelSingleTon

        if( dataBrowserModel.elementCount > 1 ) {
            
        }
        else {
            if let pinch = sender.view {
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
                dataBrowserModel.value1 += (translation.y / dataBrowserModel.getDyInfoValue().dy)
                dataBrowserModel.value2 += (translation.y / dataBrowserModel.getDyInfoValue().dy)
                
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
        
        if( dataBrowserModel.elementCount > 1 ) {
            dataBrowserModel.setAutoViewSize(self.dataDrawView.arrayData)
        }
        else {
            dataBrowserModel.setAutoViewSize(self.dataDrawView.data)
        }
    }
    
    func addNewProcessVariable(pvName: String) {

        if let drawView = dataDrawView {
            drawView.data.removeAll()
            drawView.time.removeAll()
        }
        
        pvValueArray.removeAllObjects()
        
        caObject.channelAccessSetGet(pvValueArray)
        
        self.title = pvName
        
        startDataBrowser(pvName: pvName)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newElementViewController" {
            let newElementView: NewElementViewController = segue.destination as! NewElementViewController
            newElementView.delegate = self
        }
    }
}
