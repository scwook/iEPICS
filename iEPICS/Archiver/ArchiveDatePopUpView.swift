//
//  ArchiveDatePopUpView.swift
//  iEPICS
//
//  Created by ctrl user on 14/05/2018.
//  Copyright © 2018 scwook. All rights reserved.
//

import UIKit

protocol retrieveDataDelegate {
    func retrieveDataFromDate(from: Date?, to: Date?)
}

class ArchiveDatePopUpView: UIView {
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var dateSegmentControl: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate: retrieveDataDelegate?
    
    var fromDate: Date?
    var toDate: Date?
    @IBAction func dateSegmentValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0, let from = fromDate {
            datePicker.date = from
        }
        else if sender.selectedSegmentIndex == 1, let to = toDate {
            datePicker.date = to
        }
    }
    
    @IBAction func dateValueChanged(_ sender: UIDatePicker) {
        if dateSegmentControl.selectedSegmentIndex == 0 {
            fromDate = sender.date
        }
        else if dateSegmentControl.selectedSegmentIndex == 1 {
            toDate = sender.date
        }
    }
    
    @IBAction func okButton(_ sender: UIButton) {
        if delegate != nil {
            delegate!.retrieveDataFromDate(from: fromDate, to: toDate)
            disAppearViewAnimation()
            
        }
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        disAppearViewAnimation()
    }
    
    func disAppearViewAnimation() {
        UIView.animate(withDuration: 0.5, animations: ({
            self.center.y = self.frame.height * 2
            
        }), completion: { finished in self.removeFromSuperview()})
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
