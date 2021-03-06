//
//  MonitoringViewController.swift
//  iEPICS
//
//  Created by ctrl user on 01/11/2017.
//  Copyright © 2017 scwook. All rights reserved.
//

import UIKit

class MonitoringViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewElementDataDelegate, ChangeElementDataDelegate {

    @IBOutlet weak var monitoringTableView: UITableView!
    
    let caObject = ChannelAccessClient.sharedObject()!
    
    let caEventNotification = Notification.Name("EventCallbackNotification")
    let caConnectionNotification = Notification.Name("ConnectionCallbackNotification")
    let caErrorNotification = Notification.Name("ErrorCallbackNotification")
    
    var caEventNotificationProtocol: NSObjectProtocol?
    var caConnectionNotificationProtocol: NSObjectProtocol?
    var caErrorNotificationProtocol: NSObjectProtocol?
    var appDidEnterBackgroundProtocol: NSObjectProtocol?
    var appWillEnterForegroundProtocol: NSObjectProtocol?
    
    var pvNameDictionary = NSMutableDictionary()
//    var pvNameDictionaryIndex = NSMutableDictionary()
    var pvNameDicKeyCopyArray = [String?]()
//    var pvDataArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationWillTerminate, object: nil, queue: OperationQueue.main, using: savePVListToFile)

        
        print("Monitoring ViewdidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        caObject.channelAccessContextCreate()
        
        loadPVListFromFile()
        
        //        for i in 1 ... 100 {
        //            let name = "PI1:ai" + String(i)
        //            addNewProcessVariable(pvName: name)
        //        }
        //
        //        monitoringTableView.reloadData()
        print("Monitoring ViewWillAppear")
        //
        //        let state = UIApplication.shared.applicationState
        //
        //        switch state {
        //        case .background:
        //            print("App State is background")
        //
        //        case .active:
        //            print("App state is active")
        //
        //        case .inactive:
        //            print("App state is inactive")
        //
        //        default:
        //            print("App state is default")
        //        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        caEventNotificationProtocol = NotificationCenter.default.addObserver(forName: caEventNotification, object: nil, queue: nil, using: catchEventNotification)
        caConnectionNotificationProtocol = NotificationCenter.default.addObserver(forName: caConnectionNotification, object: nil, queue: nil, using: catchConnectionNotification)
        caErrorNotificationProtocol = NotificationCenter.default.addObserver(forName: caErrorNotification, object: nil, queue: nil, using: catchErrorNotification)
        appDidEnterBackgroundProtocol = NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationDidEnterBackground, object: nil, queue: OperationQueue.main, using: applicationDidEnterBackground)
        appWillEnterForegroundProtocol = NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.main, using: applicationWillEnterForeground)
        
        print("Monitoring ViewDidAppear")
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
        
        savePVListFromTable()

        caObject.channelAccessAllClear()
        pvNameDicKeyCopyArray.removeAll()
        
        caObject.channelAccessContexDestroy()
        
        print("Monitoring ViewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //UserDefaults.standard.set(pvNameDicKeyCopyArray.flatMap({ $0 }), forKey: "PVNameList")
        //NotificationCenter.default.post(name: Notification.Name.UIApplicationWillTerminate, object: nil)
        //viewWillSwitch()
        
        //        fvor i in 0 ..< pvNameDicKeyCopyArray.count {
        //            removeProcessVariable(pvName: pvNameDicKeyCopyArray[i]!)
        //        }
        //
        
        print("Monitoring ViewDidDisappear")
    }
    
    //******** Table View *************
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pvNameDicKeyCopyArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight: CGFloat = 40.0
        let height = UIScreen.main.bounds.height
        switch height {
        case 568.0:
            rowHeight = 35.0

        default:
            rowHeight = 40.0
            break
        }

        if pvNameDicKeyCopyArray[indexPath.row] == nil {
            rowHeight -= 5.0
        }
        
        return rowHeight

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let rowData = pvNameDicKeyCopyArray[indexPath.row] {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ParentCell", for: indexPath) as? ParentMonitoringTableViewCell
            {
                if let pvNameDictionary = caObject.channelAccessGetDictionary() {
                    if pvNameDictionary.count != 0 {
                        let title = rowData

                        let myData = pvNameDictionary[title] as! ChannelAccessData
                        let value = myData.value as NSMutableArray
                        
                        let alarmStatus = myData.alarmStatus
                        if(alarmStatus == "HIHI" || alarmStatus == "LOLO") {
                            cell.pvValueLabel.textColor = UIColor.red
                        }
                        else if(alarmStatus == "HIGH" || alarmStatus == "LOW") {
                            cell.pvValueLabel.textColor = UIColor.orange
                        }
                        else {
                            cell.pvValueLabel.textColor = UIColor.black
                        }

                        cell.pvNameLabel.text = title
                        cell.pvValueLabel.text = "Invalid"
                        
                        if( value.count != 0 ) {
                            cell.pvValueLabel.text = String(describing: value[0])
                        }
                       
                        let elementCount = myData.elementCount
                        if(elementCount > 1) {
                            cell.arrayImageView.image = UIImage(named: "Wave_black")
                        }
                        else {
                            cell.arrayImageView.image = nil
                        }
                    
                        let currentDate = Date()
                        let currentTimeOffset = Int32(currentDate.timeIntervalSince1970) - myData.timeStampSince1990 - 631152000
                        if( abs(currentTimeOffset) > 5 ) {
                            cell.clockImageView.image = UIImage(named: "Clock")
                        }
                        else {
                            cell.clockImageView.image = nil
                        }
                    }
                    
                    return cell

                }
                else {
                    fatalError("The cell is not an instance of MyTableViewCell")
                }
            }

        }
        else {
            let parentCellIndex = getParentCellIndex(expansionIndex: indexPath.row)
            if let rowData = pvNameDicKeyCopyArray[parentCellIndex] {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "ChildCell", for: indexPath) as? ChildMonitoringTableViewCell
                {
                    if let pvNameDictionary = caObject.channelAccessGetDictionary() {
                        let title = rowData
                        let myData = pvNameDictionary[title] as! ChannelAccessData
                        let cellIndex = indexPath.row - parentCellIndex
                        var valueString: String?
                        var nameString: String?
                        
                        cell.detailElementValueLabel.textColor = UIColor.black

                        switch cellIndex {
                        case 1:
                            nameString = "Host Name"
                            valueString = myData.host as String
                        case 2:
                            nameString = "Element Count"
                            valueString = String(describing: myData.elementCount)
                        case 3:
                            nameString = "Alarm Status"
                            valueString = myData.alarmStatus as String
                            if(valueString == "HIHI" || valueString == "LOLO") {
                                cell.detailElementValueLabel.textColor = UIColor.red
                            }
                            else if(valueString == "HIGH" || valueString == "LOW") {
                                cell.detailElementValueLabel.textColor = UIColor.orange
                            }
                        case 4:
                            nameString = "Alarm Severity"
                            valueString = myData.alarmSeverity as String
                        case 5:
                            nameString = "Time Stamp"
                            valueString = myData.timeStamp as String
                            cell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
                        default:
                            valueString = ""
                            nameString = "Undefined"
                        }

                        cell.detailElementNameLabel.text = nameString
                        cell.detailElementValueLabel.text = valueString

                        return cell
                    }
                    //cell.separatorInset = UIEdgeInsetsMake(0.0, cell.bounds.size.width, 0.0, -cell.bounds.size.width)
                }
            }
        }
        return UITableViewCell()
        // Configure the cell...
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if pvNameDicKeyCopyArray[indexPath.row] != nil {
            if(indexPath.row + 1 >= pvNameDicKeyCopyArray.count) {
                expandCell(tableView: tableView, index: indexPath.row)
            }
            else {
                if(pvNameDicKeyCopyArray[indexPath.row + 1] != nil) {
                    expandCell(tableView: tableView, index: indexPath.row)
                }
                else {
                    contractCell(tableView: tableView, index: indexPath.row)
                }
            }
        }
        else {
            let parentCellIndex = getParentCellIndex(expansionIndex: indexPath.row)
            let selectedPVName = pvNameDicKeyCopyArray[parentCellIndex]
            
            if let pvNameDictionary = caObject.channelAccessGetDictionary() {
                let pvName = selectedPVName
                let myData = pvNameDictionary[pvName!] as! ChannelAccessData
                let cellIndex = indexPath.row - parentCellIndex
                
                switch cellIndex {
                case 1:
                    break;
                case 2:
                    let elementNumber = myData.elementCount
                    if( elementNumber > 1 ) {
                        self.performSegue(withIdentifier: "arrayTableViewController", sender: myData)
                    }
                case 3:
                    break;
                case 4:
                    break;
                case 5:
                    break;
                default:
                    break;
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete", handler: { (action: UIContextualAction, view: UIView, success:(Bool) -> Void) in
            
            if self.pvNameDicKeyCopyArray[indexPath.row] != nil {
                
                // Delete the row from the data source
                if let cell = tableView.cellForRow(at: indexPath) as? ParentMonitoringTableViewCell {
                    
                    if (indexPath.row + 1 != self.pvNameDicKeyCopyArray.count) {
                        if (self.pvNameDicKeyCopyArray[indexPath.row + 1] == nil){
                            self.contractCell(tableView: tableView, index: indexPath.row)
                        }
                    }
                    
                    if let pvName = cell.pvNameLabel.text {
                        self.removeProcessVariable(pvName: pvName)
                    }
                    //self.caObject.channelAccessRemoveProcessVariable(pvName)
                    //self.deletePVNameFromKeyArray(pvName: pvName)
                    tableView.reloadData()
                }
            }
            success(true)
        })
        
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addChartAction = UIContextualAction(style: .normal, title: "Add Chart", handler: { (action: UIContextualAction, view: UIView, success:(Bool) -> Void) in
            
            if let rowData = self.pvNameDicKeyCopyArray[indexPath.row] {
                //UserDefaults.standard.set(self.pvNameDicKeyCopyArray.flatMap({ $0 }), forKey: "PVNameList")
                //self.viewWillSwitch()
                self.performSegue(withIdentifier: "dataBrowser", sender: rowData)
            }
            
            success(true)
        })
        
        addChartAction.backgroundColor = .green
        
        return UISwipeActionsConfiguration(actions: [addChartAction])
    }
    
    private func expandCell(tableView: UITableView, index: Int) {
        for i in 1...5 {
            pvNameDicKeyCopyArray.insert(nil, at: index + i)
            tableView.insertRows(at: [NSIndexPath(row: index + i, section: 0) as IndexPath], with: .top)
        }
    }
    
    private func contractCell(tableView: UITableView, index:Int) {
        for _ in 1...5 {
            pvNameDicKeyCopyArray.remove(at: index + 1)
            tableView.deleteRows(at: [NSIndexPath(row: index + 1, section: 0) as IndexPath], with: .top)
        }
    }
    
    private func getParentCellIndex(expansionIndex: Int) -> Int {
        var selectedCellIndex = expansionIndex
        var selectedCell = pvNameDicKeyCopyArray[selectedCellIndex]
        
        while( selectedCell == nil && selectedCellIndex >= 0 ) {
            selectedCellIndex -= 1
            selectedCell = pvNameDicKeyCopyArray[selectedCellIndex]
        }
        
        return selectedCellIndex
    }
 
    
    private func viewWillSwitch() {

        //caObject.channelAccessSetDictionary(pvNameDictionary)
        //caObject.channelAccessSetDictionaryIndex(pvNameDictionaryIndex)
        
//        for i in 0 ..< pvNameDicKeyCopyArray.count {
//            removeProcessVariable(pvName: pvNameDicKeyCopyArray[i]!)
//        }

        //caObject.channelAccessRemoveAll()
        
//        pvNameDicKeyCopyArray.removeAll()
    }
    
    //********* Add and Remove Process Variable **********
    private func addNewPVNameToKeyArray(pvName: String, index: Int) -> Void {
        pvNameDicKeyCopyArray.insert(pvName, at: index)
    }
    
    private func deletePVNameFromKeyArray(pvName: String) -> Void {
        for i in 0 ..< pvNameDicKeyCopyArray.count {
            if( pvNameDicKeyCopyArray[i] == pvName ) {
                pvNameDicKeyCopyArray.remove(at: i)
                break;
            }
        }
    }
 
    public func addNewProcessVariable(pvName: String) {
        if( caObject.channelAccessAddProcessVariable(pvName) ) {
            addNewPVNameToKeyArray(pvName: pvName, index: 0)
            savePVListFromTable()
        }
        
        monitoringTableView.reloadData()
    }
    
    private func removeProcessVariable(pvName: String) {
        caObject.channelAccessRemoveProcessVariable(pvName)
        deletePVNameFromKeyArray(pvName: pvName)
    }
    
    func changeProcessVariable(oldPVName: String?, newPVName: String?) {
        if let newName = newPVName, let oldName = oldPVName {
            if( caObject.channelAccessAddProcessVariable(newName) ) {
                for i in 0 ..< pvNameDicKeyCopyArray.count {
                    if( pvNameDicKeyCopyArray[i] == oldName ) {
                        pvNameDicKeyCopyArray[i] = newName
                        removeProcessVariable(pvName: oldName)
                        savePVListFromTable()
                        
                        monitoringTableView.reloadData()
                        break;
                    }
                }
            }
        }
    }
    
    //********* Save and Load ************
    private func loadPVListFromFile() {
        //let pvList = UserDefaults.standard.object(forKey: "PVNameList") as? [String] ?? [String]()
        if let pvList = UserDefaults.standard.object(forKey: "PVNameList") as? [String] {
            for i in 0 ..< pvList.count {
                addNewProcessVariable(pvName: pvList[i])
                //caObject.channelAccessAddProcessVariable(pvList[i])
                //addNewPVNameToKeyArray(pvName: pvList[i], index: i)
            }
        }
    }
    
    private func savePVListFromTable() {
        let reversedList = pvNameDicKeyCopyArray.reversed()
        UserDefaults.standard.set(reversedList.compactMap({ $0 }), forKey: "PVNameList")
    }
    
    
    //********* Notification *************
    private func catchEventNotification(notification:Notification) -> Void {
        
        DispatchQueue.main.async {
            if(!self.monitoringTableView.isEditing && !self.monitoringTableView.isDragging) {
                let state = UIApplication.shared.applicationState
                if( state == .active ) {
                    self.monitoringTableView.reloadData()
                }
            }
        }
    }
    
    private func catchConnectionNotification(notification:Notification) -> Void {
        
        DispatchQueue.main.async {
            if(!self.monitoringTableView.isEditing && !self.monitoringTableView.isDragging) {
                let state = UIApplication.shared.applicationState
                if( state == .active ) {
                    self.monitoringTableView.reloadData()
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
        print("DidEnterBackground")
        //        self.viewWillDisappear(false)
        //        self.viewDidDisappear(false)
        
        caObject.channelAccessAllClear()
        pvNameDicKeyCopyArray.removeAll()
        
        caObject.channelAccessContexDestroy()
    }
    
    private func applicationWillEnterForeground(notification:Notification) -> Void {
        print("WillenterForeground")
        //        self.viewWillAppear(false)
        //        self.viewDidAppear(false)
        
        caObject.channelAccessContextCreate()
        
        loadPVListFromFile()
    }
    
//    private func savePVListToFile(notification:Notification) -> Void {
//        savePVListFromTable()
//    }
    
    // ********* Segue ********
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newElementViewController" {
            let newElementView: NewElementViewController = segue.destination as! NewElementViewController
            newElementView.delegate = self
            newElementView.lastPVName = pvNameDicKeyCopyArray.first ?? ""
        }
        
        if segue.identifier == "dataBrowser" {
            let dataBrowserView: DataBrowserViewController = segue.destination as! DataBrowserViewController
            let pvName = sender as! String
            
            dataBrowserView.pv = pvName
            
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        }
        
        if segue.identifier == "arrayTableViewController" {
            let arrayTableView: ArrayTableViewController = segue.destination as! ArrayTableViewController
            //                                pvDataArray = myData.value as NSMutableArray
            let myData = sender as! ChannelAccessData
//            let array = myData.value as NSMutableArray
            let processVariableName = myData.name as String
            
//            arrayTableView.pvDataArray = array
            arrayTableView.pvName = processVariableName
            
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        }
        
        if segue.identifier == "changeElementViewController" {
            let changeElementView: ChangeElementViewController = segue.destination as! ChangeElementViewController
            changeElementView.delegate = self
            
            let currentPVName: String? = sender as! String?
            changeElementView.currentPVName = currentPVName
        }
    }
    
    @IBAction func longPressGestureRecognizer(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            let touchPoint = sender.location(in: monitoringTableView)
            
            if let indexPath = monitoringTableView.indexPathForRow(at: touchPoint) {
                if let cell = monitoringTableView.cellForRow(at: indexPath) as? ParentMonitoringTableViewCell {
                    self.performSegue(withIdentifier: "changeElementViewController", sender: cell.pvNameLabel.text)
                }
            }
            
        case .changed:
            break
            
        case .ended:
            break
            
        default:
            break
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }
}
