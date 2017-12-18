//
//  ViewController.swift
//  Targets
//
//  Created by Sandeep Chowdhury on 18/12/2017.
//  Copyright © 2017 Sandeep Chowdhury. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var targetNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Actions
    
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
        targetNameLabel.text = "Default text"
    }
    
}

