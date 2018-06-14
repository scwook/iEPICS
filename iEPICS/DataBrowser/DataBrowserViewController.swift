//
//  DataBrowserViewController.swift
//  iEPICS
//
//  Created by ctrl user on 23/11/2017.
//  Copyright © 2017 scwook. All rights reserved.
//

import UIKit

class DataBrowserViewController: UIViewController, NewElementDataDelegate, retrieveDataDelegate {

    let caObject = ChannelAccessClient.sharedObject()!
    var pvValueArray = NSMutableArray()
    var drawTimer: Timer?
    
    let maxArraySize = 1000
    var pv: String? = nil
    var startDrawing = false
    
//    var isArchiveEnabled = false
    var archiveServerURL: String?
    let archiveURLSessionConfig = URLSessionConfiguration.default
    var archiveURLSeesion: URLSession?
    
    let getData = "/data/getData.json"
    
    var retrievedData = [Dictionary<String, Any>]()
    var fromDate: Date?
    var toDate: Date?
    
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
    
    
    @IBAction func calendarBarButtonAction(_ sender: UIBarButtonItem) {
        createDatePopUpView()
    }
    
    private func createDatePopUpView() {
        let archiveDatePopUp: ArchiveDatePopUpView = UINib(nibName: "ArchiveDatePopUpView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! ArchiveDatePopUpView
        archiveDatePopUp.delegate = self
        
        // Init pop up view
        archiveDatePopUp.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        archiveDatePopUp.frame = self.view.frame
        archiveDatePopUp.center.y = self.view.frame.height + 100
        
        archiveDatePopUp.childView.backgroundColor = UIColor.white
        archiveDatePopUp.childView.layer.cornerRadius = 12.0
        
        // Init date
        archiveDatePopUp.fromDate = fromDate
        archiveDatePopUp.toDate = toDate
        
        archiveDatePopUp.datePicker.date = Date()
        
        self.view.addSubview(archiveDatePopUp)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 5.0, initialSpringVelocity: 10.0, options: UIViewAnimationOptions.curveEaseOut, animations: ({
            archiveDatePopUp.center.y = self.view.frame.height / 2
            
        }), completion: nil)
    }
    
    func retrieveDataFromDate(from: Date?, to: Date?) {
        if let pvName = pv, let fromDate = from, let toDate = to {
            retrieveArchiveData(pvName: pvName, from: fromDate, to: toDate)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        archiveURLSessionConfig.timeoutIntervalForResource = 5
        archiveURLSessionConfig.timeoutIntervalForRequest = 5
        archiveURLSeesion = URLSession(configuration: archiveURLSessionConfig)
        
        archiveServerURL = UserDefaults.standard.string(forKey: "ArchiveDataRetrievalURL")

//        if archiveServerURL != nil {
//            let url = URL(string: archiveServerURL!)
//            do {
//                _ = try String(contentsOf: url!)
//                isArchiveEnabled = true
//            } catch {
////                errorMessage(message: "Can Not Access to Server")
//            }
//        }
        
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

                drawTimer = Timer.scheduledTimer(withTimeInterval: drawTimeInterval, repeats: true) { timer in
                    if( self.startDrawing ) {
                        
                            if( self.dataDrawView.data.count == 2) {
                                dataBrowserModel.setAutoViewSize(self.dataDrawView.data)
                            }
                        
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

        let currentDate = Date()
        let startedTimeStamp =  currentDate.timeIntervalSince1970
        dataBrowserModel.timeOffset = startedTimeStamp
        
        let initTimeRange = TimeInterval(dataBrowserModel.timeRange)
        retrieveArchiveData(pvName: pvName, from: Date().addingTimeInterval(-initTimeRange), to: currentDate)
        
        dataBrowserModel.startedDrawTime = startedTimeStamp
        
        startDataBrowser(pvName: pvName)
    }
    
    private func retrieveArchiveData(pvName: String, from: Date, to: Date) -> Void {
        if let serverURL = archiveServerURL {
            let getDataFrom = dateFormatter.string(from: from)
            let getDataTo = dateFormatter.string(from: to)

//            print(getDataFrom, getDataTo)
            
            let getDataFromURLEncode = getDataFrom.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserved)
            let getDataToURLEncode = getDataTo.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserved)
            let pvNameEncode = pvName.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserved)
            
            let searchingName = serverURL + getData + "?pv=" + pvNameEncode! + "&from=" + getDataFromURLEncode! + "&to=" + getDataToURLEncode!

            if let getDataURL = URL(string: searchingName) {
                //                archiveActivityIndicator.startAnimating()
                
                let archiveURLTask = archiveURLSeesion?.dataTask(with: getDataURL) {
                    (data, response, error) in
                    guard let archiveData = data, error == nil else {
                        DispatchQueue.main.async {
//                            self.errorMessage(message: "Can not connect to server")
                            //                            self.archiveActivityIndicator.stopAnimating()
                        }
                        
                        return
                    }
                    
                    do {
                        let jsonRawData = try JSONSerialization.jsonObject(with: data! , options: .allowFragments) as! [Dictionary<String, Any>]
                        let jsonParsing = jsonRawData[0]
                        let dictionaryDataFromJson = jsonParsing["data"] as! [[String : Any]]
//                        self.retrievedData = dictionaryDataFromJson
 
                        DispatchQueue.main.sync {
                            self.dataDrawView.archiveData.removeAll()
                            self.dataDrawView.archiveTime.removeAll()
                            self.dataDrawView.archiveNSecTime.removeAll()
                            
                            for i in 0..<dictionaryDataFromJson.count {
                                //                            let data = self.retrievedData
                                self.dataDrawView.archiveData.append(dictionaryDataFromJson[i]["val"] as! Double)
                                self.dataDrawView.archiveTime.append(dictionaryDataFromJson[i]["secs"] as! Int)
                                self.dataDrawView.archiveNSecTime.append((dictionaryDataFromJson[i]["nanos"] as! CGFloat) / 1000000000)
                            }
                            
                            self.dataDrawView.setNeedsDisplay()
                        }
                    } catch {
                        //
                    }
                }
                archiveURLTask?.resume()
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
        
        if let timer = drawTimer {
            timer.invalidate()
        }
        
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
                if let pvName = pv {
                    var getDataOffsetTo = Double(dataBrowserModel.timeOffset)
                    
                    
                    if getDataOffsetTo >= dataBrowserModel.startedDrawTime {
                        getDataOffsetTo = dataBrowserModel.startedDrawTime
                    }
                    
                    let retrivealToDate = Date(timeIntervalSince1970: getDataOffsetTo)
                    let retrievalFromDate = Date(timeIntervalSince1970: getDataOffsetTo - Double(dataBrowserModel.timeRange))
                    
                    retrieveArchiveData(pvName: pvName, from: retrievalFromDate, to: retrivealToDate)
                    
                    if dataBrowserModel.timeOffset >= Date().timeIntervalSince1970 {
                        startDataBrowser(pvName: pvName)
                    }
                }
                
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
                    
                    if(self.dataDrawView.data.count > self.maxArraySize) {
                        
                        self.dataDrawView.data.remove(at: 0)
                        self.dataDrawView.time.remove(at: 0)
                        self.dataDrawView.nSecTime.remove(at: 0)
                        
                        dataBrowserModel.startedDrawTime = Double(self.dataDrawView.time[0]) + Double(self.dataDrawView.nSecTime[0])

//                        let overCount = self.dataDrawView.data.count - self.maxArraySize
//                        for _ in 0 ..< overCount {
//                            self.dataDrawView.data.remove(at: 0)
//                            self.dataDrawView.time.remove(at: 0)
//                        }
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
