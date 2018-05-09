//
//  ViewController.swift
//  Lesson 7
//
//  Created by Debash on 09.05.2018.
//  Copyright © 2018 swiftbook.ru. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var secondNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameLabel.isHidden = true
    }
    
    func wrongFormatAlert() {
        let alert = UIAlertController(title: "Wrong format!", message: "Please enter your name", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func donePressed(_ sender: UIButton) {
        
        guard firstNameTextField.text?.isEmpty == false else {
            wrongFormatAlert()
            return
        }
        guard secondNameTextField.text?.isEmpty == false else {
            wrongFormatAlert()
            return
        }
        
        if let _ = Double(firstNameTextField.text!) {
            wrongFormatAlert()
        } else if let _ = Double(secondNameTextField.text!) {
            wrongFormatAlert()
        } else {
            userNameLabel.isHidden = false
            self.userNameLabel.text = firstNameTextField.text! + " " + secondNameTextField.text!
        }
        
        firstNameTextField.text = nil
        secondNameTextField.text = nil
    }
    
}

