//
//  RetrievedViewController.swift
//  iEPICS
//
//  Created by ctrl user on 16/05/2018.
//  Copyright © 2018 scwook. All rights reserved.
//

import UIKit

class RetrievedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, retrieveDataDelegate {
    @IBOutlet weak var retrievedTableViewNavigationItem: UINavigationItem!
    @IBOutlet weak var upLoadButton: UIBarButtonItem!
    @IBOutlet weak var calendarButton: UIBarButtonItem!
    @IBOutlet weak var retrievedTableView: UITableView!
    @IBOutlet weak var archiveActivityIndicator: UIActivityIndicatorView!
    
    var pvName: String?
    var fromDate: Date?
    var toDate: Date?
    
    var archiveServerURL: String?
    let archiveURLSessionConfig = URLSessionConfiguration.default
    var archiveURLSeesion: URLSession?
    
    let getData = "/retrieval/data/getData.json"
    let getUploadData = "/retrieval/data/getData.txt"
    
    var retrievedData = [Dictionary<String, Any>]()
    
    @IBAction func upLoadButtonAction(_ sender: UIBarButtonItem) {
        upLoadArchiveData(pvName: pvName!, from: fromDate!, to: toDate!)
    }
    
    @IBAction func calendarButtonAction(_ sender: UIBarButtonItem) {
        createDatePopUpView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        retrievedTableViewNavigationItem.title = pvName
        
        archiveURLSessionConfig.timeoutIntervalForResource = 5
        archiveURLSessionConfig.timeoutIntervalForRequest = 5
        archiveURLSeesion = URLSession(configuration: archiveURLSessionConfig)
        
        archiveServerURL = UserDefaults.standard.string(forKey: "ArchiveServerURL")
        
        if let pvName = pvName, let from = fromDate, let to = toDate {
            retrieveArchiveData(pvName: pvName, from: from, to: to)
        }
    }

    private func createDatePopUpView() {
        let archiveDatePopUp: ArchiveDatePopUpView = UINib(nibName: "ArchiveDatePopUpView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! ArchiveDatePopUpView
        archiveDatePopUp.delegate = self
        
        // Init date pop up view
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
    
    private func retrieveArchiveData(pvName: String, from: Date, to: Date) {
        if let serverURL = archiveServerURL {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:00.000Z"
            
            let getDataFrom = dateFormatter.string(from: from)
            let getDataTo = dateFormatter.string(from: to)
            
            let getDataFromURLEncode = getDataFrom.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserve)
            let getDataToURLEncode = getDataTo.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserve)
            
            let pvNameEncode = pvName.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserve)
            
            let searchingName = serverURL + getData + "?pv=" + pvNameEncode! + "&from=" + getDataFromURLEncode! + "&to=" + getDataToURLEncode!
            
            if let getDataURL = URL(string: searchingName) {
                //                archiveActivityIndicator.startAnimating()
                
                let archiveURLTask = archiveURLSeesion?.dataTask(with: getDataURL) {
                    (data, response, error) in
                    guard let archiveData = data, error == nil else {
                        DispatchQueue.main.async {
                            self.errorMessage(message: "Can not connect to server")
                            //                            self.archiveActivityIndicator.stopAnimating()
                        }
                        
                        return
                    }
                    
                    do {
                        let jsonRawData = try JSONSerialization.jsonObject(with: data! , options: .allowFragments) as! [Dictionary<String, Any>]
                        let jsonParsing = jsonRawData[0]
                        let dictionaryDataFromJson = jsonParsing["data"] as! [[String : Any]]
                        self.retrievedData = dictionaryDataFromJson
                        
                        DispatchQueue.main.async {
                            self.retrievedTableView.reloadData()
                        }
                    } catch {
                        //
                    }
                }
                archiveURLTask?.resume()
            }
        }
    }

    private func upLoadArchiveData(pvName: String, from: Date, to: Date) {
        if let serverURL = archiveServerURL {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:00.000Z"
            
            let getDataFrom = dateFormatter.string(from: from)
            let getDataTo = dateFormatter.string(from: to)
            
            let getDataFromURLEncode = getDataFrom.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserve)
            let getDataToURLEncode = getDataTo.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserve)
            
            let pvNameEncode = pvName.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserve)
            
            let searchingName = serverURL + getUploadData + "?pv=" + pvNameEncode! + "&from=" + getDataFromURLEncode! + "&to=" + getDataToURLEncode!
            
            if let getDataURL = URL(string: searchingName) {
                archiveActivityIndicator.startAnimating()
                
                let archiveURLTask = archiveURLSeesion?.dataTask(with: getDataURL) {
                    (data, response, error) in
                    guard let archiveData = data, error == nil else {
                        DispatchQueue.main.async {
                            self.errorMessage(message: "Can not connect to server")
                            self.archiveActivityIndicator.stopAnimating()
                        }
                        
                        return
                    }
                    
                    let fileName = pvName + "_" + getDataFrom + "-" + getDataTo + ".txt"
                    let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName, isDirectory: false)
                    
                    do {
                        try data?.write(to: path)
                        
                        let activeityVC = UIActivityViewController(activityItems: [path], applicationActivities: nil)

                        if let popoverController = activeityVC.popoverPresentationController {
                            popoverController.sourceView = self.view
                            popoverController.sourceRect = self.view.bounds
                        }
                        
                        self.present(activeityVC, animated: true, completion: nil)
                        
                    } catch {
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.archiveActivityIndicator.stopAnimating()
                    }
                }
                
                archiveURLTask?.resume()
            }
        }

//                do {
//                    let data = try String(contentsOf: url)
//
//                    //                let split = data.split(separator: "\n")
//                    //                let aa = [String](data)
//                    //                print(split)
//                    let fileName = "test.txt"
//                    let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName, isDirectory: false)
//
//                    do {
//                        try data.write(to: path, atomically: true, encoding: String.Encoding.utf8)
//
//                        let activeityVC = UIActivityViewController(activityItems: [path], applicationActivities: nil)
//
//                        if let popoverController = activeityVC.popoverPresentationController {
//                            popoverController.sourceView = self.view
//                            popoverController.sourceRect = self.view.bounds
//                        }
//                        self.present(activeityVC, animated: true, completion: nil)
//
//                    } catch {
//
//                    }
//
//                    //                activeityVC.excludedActivityTypes = [ UIActivityType.airDrop ]
//
//                } catch {
//                    print("Cannot load contents")
//                }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return retrievedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RetrievedTableViewCell", for: indexPath) as? RetrievedTableViewCell {
            
            let data = retrievedData[indexPath.row]
//            let date = Date().addingTimeInterval(data["secs"] as! TimeInterval)
            let date = Date(timeIntervalSince1970: data["secs"] as! TimeInterval)

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let stringDate = dateFormatter.string(from: date)
            cell.dateTextLabel.text = stringDate

            var value: String?
            switch data["val"] {
            case 0 as Int:
                value = "0"
                
            case 0 as Double:
                value = "0.0"
                
            case let someInt as Int:
                value = String(someInt)
                
            case let someDouble as Double:
                value = String(someDouble)
                
            case let someString as String:
                value = someString
                
            case let (x, y) as (Double, Double):
                print("an (x, y) point at \(x), \(y)")

            default:
                value = ""
            }
            
            cell.valueTextLabel.text = value
            
            return cell
        }
        return UITableViewCell()
    }
    
    func retrieveDataFromDate(from: Date?, to: Date?) {
        if let pvName = pvName, let fromDate = from, let toDate = to {
            retrieveArchiveData(pvName: pvName, from: fromDate, to: toDate)
        }
    }
    
    private func errorMessage(message: String) -> Void {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }
}

extension CharacterSet {
    static let rfc3986Unreserve = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
}
