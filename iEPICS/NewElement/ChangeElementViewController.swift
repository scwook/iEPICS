//
//  ChangeElementViewController.swift
//  iEPICS
//
//  Created by ctrl user on 23/03/2018.
//  Copyright © 2018 scwook. All rights reserved.
//

import UIKit
protocol ChangeElementDataDelegate {
    func changeProcessVariable(oldPVName: String?, newPVName: String?)
}

class ChangeElementViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var changePVTextLabel: UILabel!
    @IBOutlet weak var changePVTextField: UITextField! {
        didSet {
            changePVTextField.delegate = self
        }
    }
    
    let caErrorNotification = Notification.Name("ChangeElementCallbackNotification")
    var delegate:ChangeElementDataDelegate? = nil
    var currentPVName: String? = nil
    var changePVTitle: String? = "Change Process Variable"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        
        NotificationCenter.default.addObserver(forName: caErrorNotification, object: nil, queue: nil, using: catchErrorNotification)
        
        changePVTextField.text = currentPVName
        changePVTextLabel.text = changePVTitle
    }
    
    @IBAction func okButton(_ sender: UIButton) {
        if (delegate != nil) {
            
            let pvNameString: String? = changePVTextField.text
            let removeWhiteSpaceString = pvNameString?.trimmingCharacters(in: .whitespaces)
            
            if ( !(removeWhiteSpaceString?.isEmpty)! ) {
                dismiss(animated: true, completion: nil)
                delegate!.changeProcessVariable(oldPVName: currentPVName, newPVName: changePVTextField.text)
            }
            else {
                NotificationCenter.default.post(name: caErrorNotification, object:"Enter Process Variable")
            }
            //let pvNameString: String = newPVTextField.text!
        }
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    private func catchErrorNotification(notification:Notification) -> Void {
        
        if let caMessage = notification.object as? String {
            let alert = UIAlertController(title: "Error", message: caMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(alert, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
