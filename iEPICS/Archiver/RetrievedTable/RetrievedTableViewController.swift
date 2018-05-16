//
//  RetrievedTableViewController.swift
//  iEPICS
//
//  Created by ctrl user on 14/05/2018.
//  Copyright © 2018 scwook. All rights reserved.
//

//import UIKit
//
//class RetrievedTableViewController: UITableViewController, retrieveDataDelegate {
//
//    @IBOutlet weak var retrievedTableViewNavigationItem: UINavigationItem!
//    @IBOutlet weak var upLoadButton: UIBarButtonItem!
//    @IBOutlet weak var calendarButton: UIBarButtonItem!
//
//    var pvName: String?
//    var fromDate: Date?
//    var toDate: Date?
//
//    var archiveServerURL: String?
//    let archiveURLSessionConfig = URLSessionConfiguration.default
//    var archiveURLSeesion: URLSession?
//
//    let getData = "/retrieval/data/getData.json"
//
//    var retrievedData = [Dictionary<String, Any>]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//
//        retrievedTableViewNavigationItem.title = pvName
//
//        archiveURLSessionConfig.timeoutIntervalForResource = 5
//        archiveURLSessionConfig.timeoutIntervalForRequest = 5
//        archiveURLSeesion = URLSession(configuration: archiveURLSessionConfig)
//
//        archiveServerURL = UserDefaults.standard.string(forKey: "ArchiveServerURL")
//
//        if let pvName = pvName, let from = fromDate, let to = toDate {
//            retrieveArchiveData(pvName: pvName, from: from, to: to)
//        }
//        //
//        //        print(dateformatter.string(from: from!), to)
//    }
//    @IBAction func upLoadButtonAction(_ sender: UIBarButtonItem) {
//
//    }
//
//    @IBAction func calendarButtonAction(_ sender: UIBarButtonItem) {
//        createDatePopUpView()
//    }
//
//    private func createDatePopUpView() {
//        let archiveDatePopUp: ArchiveDatePopUpView = UINib(nibName: "ArchiveDatePopUpView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! ArchiveDatePopUpView
//        archiveDatePopUp.delegate = self
//
//        // Init date pop up view
//        archiveDatePopUp.backgroundColor = UIColor.black.withAlphaComponent(0.0)
//        archiveDatePopUp.frame = self.view.frame
//        archiveDatePopUp.center.y = self.view.frame.height + 100
//
//        archiveDatePopUp.childView.backgroundColor = UIColor.white
//        archiveDatePopUp.childView.layer.cornerRadius = 12.0
//
//        // Init date
//        archiveDatePopUp.fromDate = fromDate
//        archiveDatePopUp.toDate = toDate
//
//        archiveDatePopUp.datePicker.date = Date()
//
//        self.view.addSubview(archiveDatePopUp)
//
//        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 5.0, initialSpringVelocity: 10.0, options: UIViewAnimationOptions.curveEaseOut, animations: ({
//            archiveDatePopUp.center.y = self.view.frame.height / 2
//
//        }), completion: nil)
//    }
//
//    private func retrieveArchiveData(pvName: String, from: Date, to: Date) {
//        if let serverURL = archiveServerURL {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//
//            let getDataFrom = dateFormatter.string(from: from)
//            let getDataTo = dateFormatter.string(from: to)
//
//            let getDataFromURLEncode = getDataFrom.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserve)
//            let getDataToURLEncode = getDataTo.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserve)
//
//            let pvNameEncode = pvName.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserve)
//
//            let searchingName = serverURL + getData + "?pv=" + pvNameEncode! + "&from=" + getDataFromURLEncode! + "&to=" + getDataToURLEncode!
//
//            if let getDataURL = URL(string: searchingName) {
//                //                archiveActivityIndicator.startAnimating()
//
//                let archiveURLTask = archiveURLSeesion?.dataTask(with: getDataURL) {
//                    (data, response, error) in
//                    guard let archiveData = data, error == nil else {
//                        DispatchQueue.main.async {
//                            self.errorMessage(message: "Can not connect to server")
////                            self.archiveActivityIndicator.stopAnimating()
//                        }
//
//                        return
//                    }
//
//                    do {
//                        let jsonRawData = try JSONSerialization.jsonObject(with: data! , options: .allowFragments) as! [Dictionary<String, Any>]
//                        let jsonParsing = jsonRawData[0]
//                        let dictionaryDataFromJson = jsonParsing["data"] as! [[String : Any]]
//                        self.retrievedData = dictionaryDataFromJson
//
//                        DispatchQueue.main.async {
//                            self.tableView.reloadData()
//                        }
//                    } catch {
//                        //
//                    }
//                }
//                archiveURLTask?.resume()
//            }
//        }
//    }
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return retrievedData.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "RetrievedTableViewCell", for: indexPath) as? RetrievedTableViewCell {
//
//            let data = retrievedData[indexPath.row]
//            let date = Date().addingTimeInterval(data["secs"] as! TimeInterval)
//
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//            let stringDate = dateFormatter.string(from: date)
//            cell.dateTextLabel.text = stringDate
//
//            return cell
//        }
//
//        return UITableViewCell()
//    }
//
//    /*
//    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//    */
//
//    /*
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
//    */
//
//    /*
//    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//    }
//    */
//
//    /*
//    // Override to support conditional rearranging of the table view.
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
//    */
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//    func retrieveDataFromDate(from: Date?, to: Date?) {
//        if let pvName = pvName, let fromDate = from, let toDate = to {
//            retrieveArchiveData(pvName: pvName, from: fromDate, to: toDate)
//        }
//    }
//
//    private func errorMessage(message: String) -> Void {
//        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//
//        present(alert, animated: true)
//    }
//}
//
//extension CharacterSet {
//    static let rfc3986Unreserve = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
//}
