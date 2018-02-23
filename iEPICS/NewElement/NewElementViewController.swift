//
//  NewElementViewController.swift
//  iEPICS
//
//  Created by ctrl user on 01/11/2017.
//  Copyright © 2017 scwook. All rights reserved.
//

import UIKit
protocol NewElementDataDelegate {
    func addNewProcessVariable(pvName:String)
}

class NewElementViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var addNewPVLabel: UITextField!
    @IBOutlet weak var newPVTextField: UITextField! {
        didSet {
            newPVTextField.delegate = self
        }
    }
    
    let caErrorNotification = Notification.Name("NewElementCallbackNotification")

    var delegate:NewElementDataDelegate? = nil
    
    @IBAction func okButton(_ sender: UIButton) {
        if (delegate != nil) {

            let pvNameString: String? = newPVTextField.text
            let removeWhiteSpaceString = pvNameString?.trimmingCharacters(in: .whitespaces)
            
            if ( !(removeWhiteSpaceString?.isEmpty)! ) {
                dismiss(animated: true, completion: nil)
                delegate!.addNewProcessVariable(pvName: newPVTextField.text!)
            }
            else {
                NotificationCenter.default.post(name: caErrorNotification, object:"Enter New Process Variable")
            }
            //let pvNameString: String = newPVTextField.text!
        }
    }
    
    @IBAction func cancleButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        
        NotificationCenter.default.addObserver(forName: caErrorNotification, object: nil, queue: nil, using: catchErrorNotification)

        // Do any additional setup after loading the view.
    }
    
    private func catchErrorNotification(notification:Notification) -> Void {
        
        if let caMessage = notification.object as? String {
            let alert = UIAlertController(title: "Error", message: caMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(alert, animated: true)
        }
    }
}
