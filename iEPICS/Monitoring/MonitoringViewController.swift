//
//  MonitoringViewController.swift
//  iEPICS
//
//  Created by ctrl user on 01/11/2017.
//  Copyright © 2017 scwook. All rights reserved.
//

import UIKit

class MonitoringViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewElementDataDelegate {
    
    @IBOutlet weak var monitoringTableView: UITableView!
    
    let caObject = ChannelAccessClient.sharedObject()!
    
    let caEventNotification = Notification.Name("EventCallbackNotification")
    let caErrorNotification = Notification.Name("ErrorCallbackNotification")
    
    var pvNameDictionary = NSMutableDictionary()
    var pvNameDictionaryIndex = NSMutableDictionary()
    var pvNameDicKeyCopyArray = [String?]()
    var pvDataArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(forName: caEventNotification, object: nil, queue: nil, using: catchEventNotification)
        NotificationCenter.default.addObserver(forName: caErrorNotification, object: nil, queue: nil, using: catchErrorNotification)
        NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationWillTerminate, object: nil, queue: OperationQueue.main, using: savePVListToFile)
        
        caObject.channelAccessContextCreate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //UserDefaults.standard.set(pvNameDicKeyCopyArray.flatMap({ $0 }), forKey: "PVNameList")
        //NotificationCenter.default.post(name: Notification.Name.UIApplicationWillTerminate, object: nil)
        savePVListFromTable()
        //viewWillSwitch()
        
//        for i in 0 ..< pvNameDicKeyCopyArray.count {
//            removeProcessVariable(pvName: pvNameDicKeyCopyArray[i]!)
//        }
//
        caObject.channelAccessAllClear()
        pvNameDicKeyCopyArray.removeAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //caObject.channelAccessSetDictionary(pvNameDictionary)
        //caObject.channelAccessSetDictionaryIndex(pvNameDictionaryIndex)
    
        //loadPVListFromFile()
        
        for i in 1 ... 100 {
            let name = "PI1:ai" + String(i)
            addNewProcessVariable(pvName: name)
        }

        monitoringTableView.reloadData()
    }
    
    
    //******** Table View *************
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pvNameDicKeyCopyArray.count
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
                        cell.pvValueLabel.text = "Empty"
                        
                        if( value.count != 0 ) {
                            cell.pvValueLabel.text = String(describing: value[0])
                        }
                       
                        let elementCount = myData.elementCount
                        if(elementCount > 1) {
                            cell.arrayImageView.image = UIImage(named: "Array")
                        }
                        else {
                            cell.arrayImageView.image = nil
                        }
                    
                        let currentDate = Date()
                        let currentTimeOffset = Int32(currentDate.timeIntervalSince1970) - myData.timeStampSince1990 - 631152000
                        if( currentTimeOffset > 1 ) {
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
                            else {
                                cell.detailElementValueLabel.textColor = UIColor.black
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
        if let data = pvNameDicKeyCopyArray[indexPath.row] {
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
            if let rowData = pvNameDicKeyCopyArray[parentCellIndex] {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "ChildCell", for: indexPath) as? ChildMonitoringTableViewCell
                {
                    if let pvNameDictionary = caObject.channelAccessGetDictionary() {
                        let title = rowData
                        let myData = pvNameDictionary[title] as! ChannelAccessData
                        let cellIndex = indexPath.row - parentCellIndex
                        
                        switch cellIndex {
                        case 1:
                            break;
                        case 2:
                            let elementNumber = myData.elementCount
                            if( elementNumber > 1 ) {
                                //pvDataArray = caObject.channelAccessGetArrayData()
                                pvDataArray = myData.value as NSMutableArray
                                self.performSegue(withIdentifier: "arrayTableViewController", sender: pvDataArray)
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
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete", handler: { (action: UIContextualAction, view: UIView, success:(Bool) -> Void) in
            
            if let rowData = self.pvNameDicKeyCopyArray[indexPath.row] {
                
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
        for i in 1...5 {
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
        }
        
        monitoringTableView.reloadData()
    }
    
    private func removeProcessVariable(pvName: String) {
        caObject.channelAccessRemoveProcessVariable(pvName)
        deletePVNameFromKeyArray(pvName: pvName)
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
        UserDefaults.standard.set(pvNameDicKeyCopyArray.flatMap({ $0 }), forKey: "PVNameList")
    }
    
    
    //********* Notification *************
    private func catchEventNotification(notification:Notification) -> Void {
        
        DispatchQueue.main.async {
            if(!self.monitoringTableView.isEditing && !self.monitoringTableView.isDragging) {
                self.monitoringTableView.reloadData()
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
    
    private func savePVListToFile(notification:Notification) -> Void {
        savePVListFromTable()
    }
    
    // ********* Segue ********
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newElementViewController" {
            let newElementView: NewElementViewController = segue.destination as! NewElementViewController
            newElementView.delegate = self
        }
        
        if segue.identifier == "dataBrowser" {
            let dataBrowserView: DataBrowserViewController = segue.destination as! DataBrowserViewController
            let pvName = sender as! String
            
            dataBrowserView.pv = pvName
        }
        
        if segue.identifier == "arrayTableViewController" {
            let arrayTableView: ArrayTableViewController = segue.destination as! ArrayTableViewController
            let array = sender as! NSMutableArray
            
            arrayTableView.pvDataArray = array
        }
    }
}
