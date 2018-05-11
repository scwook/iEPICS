//
//  ArchiverViewController.swift
//  iEPICS
//
//  Created by ctrl user on 03/05/2018.
//  Copyright © 2018 scwook. All rights reserved.
//

import UIKit

class ArchiveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var archiveTableView: UITableView!
    @IBOutlet weak var archiveSearchBar: UISearchBar!
    @IBOutlet weak var archiveActivityIndicator: UIActivityIndicatorView!
    
    var archivePVList = [String]()
//    var isArchiveEnabled = false
    
    let getData = "http://192.168.3.231:17665/retrieval/data/getData.csv?pv=scwookHost2:aiExample1&from=2018-04-29T15%3A00%3A00.000Z&to=2018-05-01T15%3A00%3A00.000Z"
    let getAllPVs = "/mgmt/bpl/getAllPVs"
    let getPVState = "/mgmt/bpl/getPVStatus"
    
    var archiveServerURL: String?
    
    let getAppliaceInfo = "getApplianceInfo"
    
    let archiveURLSessionConfig = URLSessionConfiguration.default
    var archiveURLSeesion: URLSession?
    
    
    
    
//    if let serverURL = archiveServerURL {
//        let getDataFrom = dateFormatter.string(from: Date().addingTimeInterval(from))
//        let getDataTo = dateFormatter.string(from: Date().addingTimeInterval(to))
//
//        let getDataFromURLEncode = getDataFrom.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserved)
//        let getDataToURLEncode = getDataTo.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserved)
//
//        let pvNameURLEncode = pvName.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserved)
//
//        let searchingName = serverURL + getData + ".csv" + "?pv=" + pvNameURLEncode! + "&from=" + getDataFromURLEncode! + "&to=" + getDataToURLEncode!
//        //            var time = [Int]()
//        //            var value = [Double]()
//
//        if let url = URL(string: searchingName) {
//            do {
//                let rawData = try String(contentsOf: url)
//
//                if let drawView = dataDrawView {
//                    drawView.data.removeAll()
//                    drawView.time.removeAll()
//                }
//
//                let split = rawData.split(separator: "\n")
//                for i in 0 ..< split.count {
//                    let spliteData = split[i].split(separator: ",")
//                    if Int(spliteData[0]) != dataDrawView.time.last {
//                        dataDrawView.time.append(Int(spliteData[0])!)
//                        dataDrawView.data.append(Double(spliteData[1])!)
//                    }
//                }
//            } catch {
//                print("Cannot load contents")
//            }
//        }
//    }
//}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        archiveSearchBar.delegate = self
        archiveSearchBar.backgroundImage = UIImage()
        // Do any additional setup after loading the view.
        
        archiveURLSessionConfig.timeoutIntervalForResource = 5
        archiveURLSessionConfig.timeoutIntervalForRequest = 5
        archiveURLSeesion = URLSession(configuration: archiveURLSessionConfig)
        
        archiveServerURL = UserDefaults.standard.string(forKey: "ArchiveServerURL")
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let pvName = searchBar.text, let serverURL = archiveServerURL {
            let searchingName = serverURL + getAllPVs + "?pv=" + pvName
            
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
                    
                    let resultData = String(data: archiveData, encoding: String.Encoding.utf8) ?? "Error Decoding"
                    let filter = resultData.replacingOccurrences(of: "[\\{\\}\\[\\]\"\\n]", with: "", options: .regularExpression, range: nil).split(separator: ",").map{ String($0) }
                    
                    DispatchQueue.main.async {
                        self.archivePVList = filter
                        self.archiveTableView.reloadData()
                        self.archiveActivityIndicator.stopAnimating()
                    }
                }
                
                archiveURLTask?.resume()
      
//                do {
//                    let data = try String(contentsOf: url)
//                    let filter = data.replacingOccurrences(of: "[\\{\\}\\[\\]\"\\n]", with: "", options: .regularExpression, range: nil).split(separator: ",").map{ String($0) }
//                    archivePVList = filter
//
//                    archiveTableView.reloadData()
//
//                } catch {
//                    errorMessage(message: "Data Retrieval Error")
//                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return archivePVList.count
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
        
        return rowHeight
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ArchiveTableCell", for: indexPath) as? ArchiveTableViewCell {
            let pvName = archivePVList[indexPath.row]
            cell.pvNameTextLabel.text = pvName
            
//            let getURL = archiveServerURL! + getPVState + "?pv=" + pvName
//            if let url = URL(string: getURL) {
//                do {
//                    let data = try String(contentsOf: url)
//                    let filter = data.replacingOccurrences(of: "[\\{\\}\\[\\]\"\\n]", with: "", options: .regularExpression, range: nil).split(separator: ",")
//                    let pvStatus = filter.last?.split(separator: ":").map{ $0 }
//
//                    if pvStatus?.last == "Being archived" {
//                        cell.archivingImageView.image = UIImage(named: "Clock")
//                    }
//                    else if pvStatus?.last == "Paused" {
//                        cell.archivingImageView.image = UIImage()
//                    }
//                    else {
//                        cell.archivingImageView.image = UIImage()
//                    }
//
//                } catch {
//                    print("Cannot load contents")
//                }
//            }

            return cell
        }
        
        return UITableViewCell()
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
