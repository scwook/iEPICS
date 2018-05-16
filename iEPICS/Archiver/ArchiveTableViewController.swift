////
////  ArchiverTableViewController.swift
////  iEPICS
////
////  Created by ctrl user on 03/05/2018.
////  Copyright © 2018 scwook. All rights reserved.
////
//
//import UIKit
//
//class ArchiveTableViewController: UITableViewController, UISearchBarDelegate {
//
//    var archivePVList = [String]()
//    let getData = "http://192.168.3.231:17665/retrieval/data/getData.csv?pv=scwookHost2:aiExample1&from=2018-04-29T15%3A00%3A00.000Z&to=2018-05-01T15%3A00%3A00.000Z"
//    let getAllPVs = "http://192.168.2.251:17665/mgmt/bpl/getAllPVs"
//    let getPVState = "http://192.168.3.231:17665/mgmt/bpl/getPVStatus?pv=scwookHost2:aiExample4"
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        var time = [Int]()
//        var value = [String]()
//
//        if let url = URL(string: getAllPVs) {
//            do {
//                let data = try String(contentsOf: url)
//                let filter = data.replacingOccurrences(of: "[\\{\\}\\[\\]\"\\n]", with: "", options: .regularExpression, range: nil).split(separator: ",").map{ String($0) }
//                //                let pvList = filter.split(separator: ",")
////                let pvStatus = filter.last?.split(separator: ":").map{ String($0) }
//                archivePVList = filter
////                for i in 0 ..< filter.count {
////                    print(filter[i])
////                }
//
//                ////                let filter = data.filter{(!"\n".contains($0))}
//                //                let split = data.split(separator: "\n")
//                //                for i in 0 ..< split.count {
//                //                    let spliteData = split[i].split(separator: ",")
//                //                    time.append(Int(spliteData[0])!)
//                //                    value.append(String(spliteData[1]))
//                //                }
//                //
//                //                print(time, value)
//                ////                print(value.count)
//                // //
//                ////                let time = split.split(separator: ",")
//                ////                print(split)
//            } catch {
//                print("Cannot load contents")
//            }
//        }
//
////        pvListSearchBar.delegate = self
//
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        if let pvName = searchBar.text {
//            let searchingName = getAllPVs + "?pv=" + pvName
//
//            if let url = URL(string: searchingName) {
//                do {
//                    let data = try String(contentsOf: url)
//                    let filter = data.replacingOccurrences(of: "[\\{\\}\\[\\]\"\\n]", with: "", options: .regularExpression, range: nil).split(separator: ",").map{ String($0) }
//                    archivePVList = filter
//                    self.tableView.reloadData()
//
//                } catch {
//                    print("Cannot load contents")
//                }
//            }
//        }
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return archivePVList.count
//    }
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        var rowHeight: CGFloat = 40.0
//        let height = UIScreen.main.bounds.height
//        switch height {
//        case 568.0:
//            rowHeight = 35.0
//        default:
//            rowHeight = 40.0
//            break
//        }
//
//        return rowHeight
//
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "ArchiveTableCell", for: indexPath) as? ArchiveTableViewCell {
//
////            cell.pvNameTextLabel.text = archivePVList[indexPath.row]
//
//            return cell
//        }
//
//        // Configure the cell...
//
//        return UITableViewCell()
//    }
//
//    override var shouldAutorotate: Bool {
//        return true
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return [.portrait]
//    }
//
//}
