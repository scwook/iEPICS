//
//  ArrayTableViewController.swift
//  iEPICS
//
//  Created by ctrl user on 30/11/2017.
//  Copyright © 2017 scwook. All rights reserved.
//

import UIKit

class ArrayTableViewController: UITableViewController {

    var pvDataArray = NSMutableArray()
    var pvName: String? = "Array Data Element"
    
    let caObject = ChannelAccessClient.sharedObject()!
    
    @IBAction func refreshControlTableView(_ sender: UIRefreshControl) {
        if pvName != nil {
            pvDataArray = caObject.channelAccessGetArray()
            tableView.reloadData()
        }
        
        self.refreshControl?.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//
//        let backgroundImage = UIImage(named: "background")
//        let imageView = UIImageView(image: backgroundImage)
//        imageView.addSubview(blurEffectView)
//
//        tableView.backgroundView = imageView
        
        self.title = pvName
//        tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        caObject.channelAccessContextCreate()

        if let arrayPVName = pvName {
            caObject.channelAccessCreateChannel(arrayPVName)
            pvDataArray = caObject.channelAccessGetArray()
            tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        caObject.channelAccessClearChannel()
        caObject.channelAccessContexDestroy()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pvDataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ArrayTableCell", for: indexPath) as? ArrayTableViewCell {

            cell.arrayIndexLabel.text = String(indexPath.row + 1)
            cell.arrayValueLabel.text = String(describing: pvDataArray[indexPath.row])
            
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
