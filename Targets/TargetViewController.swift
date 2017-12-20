//
//  TargetViewController.swift
//  Targets
//
//  Created by Sandeep Chowdhury on 18/12/2017.
//  Copyright © 2017 Sandeep Chowdhury. All rights reserved.
//

import UIKit
import os.log

class TargetViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var daysRemainLabel: UILabel!
    
    
    //This value is either passed by TargetTableViewController or created when adding a new Target
    var targetvariable: Target?
    var targetDaysRemaining: Int?
    // Establish a date picker variable to be used for the date field
    let picker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Initialise the date picker
        createDatePicker()
        //Set days remaining to nothing
        daysRemainLabel.text = ""
        //Handle the text field's user input through delegate callbacks.
        nameTextField.delegate = self
        
        //Set up views if editing an existing Target
        if let Target = targetvariable {
            navigationItem.title = Target.name
            nameTextField.text = Target.name
            descriptionTextField.text = Target.desc
            photoImageView.image = Target.photo
            dateTextField.text = Target.dueDate
        }
        
        //Enable save button only if text field has valid target name
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Disable Save button
        saveButton.isEnabled = false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //Disable Save button (again)
        saveButton.isEnabled = false
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        updateSaveButtonState()
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }

        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        //Depending on presentation style, view controller will be dismissed in two different ways
        let isPresentingInAddTargetMode = presentingViewController is UINavigationController
        if isPresentingInAddTargetMode {
        dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The TargetViewController is not inside a navigation controller.")
        }
    }
    
    // Configure a view controller before presenting
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        super.prepare(for: segue, sender: sender)
        //Configure destination view controller only when save button is pressed
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
            let name = nameTextField.text ?? ""
            let desc = descriptionTextField.text ?? ""
            let dueDate = dateTextField.text ?? ""
            let photo = photoImageView.image
            //Set the target to be passed to TargetTableViewController after unwind segue
        targetvariable = Target(name: name, desc: desc, dueDate: dueDate, photo: photo)
            
    }

    //MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    func createDatePicker(){
        //Create picker toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //Create done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = picker
        
        //Format picker to show date
        picker.datePickerMode = .date
    }
    
    //@objc is needed to call an objective-c derived command
    @objc func donePressed() {
        //Format the date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "dd-MM-yyyy"
        let dateString = formatter.string(from: picker.date)
        dateTextField.text = "\(dateString)"
        self.view.endEditing(true)
        
      // Update Days Remaining
        let currentDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let StringDate = dateFormatter.string(from: currentDate as Date)
        print(StringDate)
        
        //String to NSDate
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateFromString = dateFormatter.date(from: dateString)
        print(dateFromString!)
        //Work out amount of days
        let days = Calendar.current.dateComponents([.day], from: dateFromString!, to: Date()).day
        targetDaysRemaining = abs(days!)
        daysRemainLabel.text = " \(abs(days!)) days remaining"
    }

    
    //MARK: Private Methods
    private func updateSaveButtonState(){
        //Disable save button if text field is empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}

