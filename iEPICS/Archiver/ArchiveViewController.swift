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
    
    var archivePVList = [String]()
    
    let getData = "http://192.168.3.231:17665/retrieval/data/getData.csv?pv=scwookHost2:aiExample1&from=2018-04-29T15%3A00%3A00.000Z&to=2018-05-01T15%3A00%3A00.000Z"
    let getAllPVs = "http://192.168.2.251:17665/mgmt/bpl/getAllPVs"
    let getPVState = "http://192.168.3.231:17665/mgmt/bpl/getPVStatus?pv=scwookHost2:aiExample4"

    override func viewDidLoad() {
        super.viewDidLoad()

        archiveSearchBar.delegate = self
        // Do any additional setup after loading the view.
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let pvName = searchBar.text {
            let searchingName = getAllPVs + "?pv=" + pvName
            
            if let url = URL(string: searchingName) {
                do {
                    let data = try String(contentsOf: url)
                    let filter = data.replacingOccurrences(of: "[\\{\\}\\[\\]\"\\n]", with: "", options: .regularExpression, range: nil).split(separator: ",").map{ String($0) }
                    archivePVList = filter

                    archiveTableView.reloadData()
                    
                } catch {
                    print("Cannot load contents")
                }
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
            
            cell.pvNameTextLabel.text = archivePVList[indexPath.row]
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }
}
