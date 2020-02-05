//
//  ViewController.swift
//  FuelTrip
//
//  Created by Tim Riedesel on 1/26/20.
//  Copyright © 2020 Tim Riedesel. All rights reserved.
//

import UIKit
import CoreLocation

class InputViewController: UIViewController {
    
    @IBOutlet weak var destinationTextField: UITextField!
    
    let locationManager = CLLocationManager()
    var mapsManager = MapsManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        locationManager.requestWhenInUseAuthorization()
        destinationTextField.delegate = self
        
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}



//MARK: - UITextField Delegate

extension InputViewController: UITextFieldDelegate {
    
    func performAction() {
        destinationTextField.endEditing(true)
        performSegue(withIdentifier: "goToTarget", sender: self)
    }
    
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        performAction()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performAction()
        destinationTextField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.text = ""
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if destinationTextField.text != nil {
            MapsManager.destinationName = destinationTextField.text!
            
        }
        destinationTextField.text = ""
    }
}




