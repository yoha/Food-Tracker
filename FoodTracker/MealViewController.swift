//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Yohannes Wijaya on 6/18/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
    This value is either passed by `MealListTableViewController` in `prepareForSegue(_:sender:)`
    or constructed as part of adding a new meal. In addition, this declares a property on MealViewController that is an optional Meal, which means that at any point, it may be nil.
    */
    var meal = Meal?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field's user input through delegate callbacks
        nameTextField.delegate = self
        
        // Set up views if editing an existing meal (which the meal property has to be non-nil)
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.ratingIndex = meal.rating
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        checkValidMealName()
        
    }
    
    // MARK: - UITextFieldDelegate
    
    func checkValidMealName() {
        // Disable the Save button if the text field is empty
        let textEntry = nameTextField.text ?? ""
        saveButton.enabled = !textEntry.isEmpty
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing
        saveButton.enabled = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidMealName()
        navigationItem.title = textField.text
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard and text field resigns its first responder status
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dimiss the picker if user cancels
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dict. contains multiple representations of the image, and
        // this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set selectedImage to photoImageView 
        photoImageView.image = selectedImage
        
        // Dismiss the picker
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        // Ensure keyboard is hidden first.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets user picks a media from their photo library
        let imagePickerController = UIImagePickerController()
        
        // Only allows photo to be picked. Since imagePickerController.sourceType
        // is an enumeration of UIImagePickerControllerSourceType, you don't have
        // to state UIImagePickerControllerSourceType.PhotoLibrary. Just the 
        // abbreviated form; .PhotoLibrary
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure the ViewController is notified when user picks an image
        imagePickerController.delegate = self
        
        // This method is executed on an implicit self object (ViewController).
        // It asks ViewController to present the view controller defined by 
        // imagePickerController
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        // Depending on style of presentation (modal via add btn or push presentation via table view cell), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        if isPresentingInAddMealMode {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    // This method lets you configure a view controller before it's presented
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            /*
            This is the nil coalescing operator (??) placed between two values, a ?? b, that unwraps an optional 'a' if it contains a value, or returns a default value 'b' if 'a' is nil.
            */
            let name = nameTextField.text ?? ""
            let photo = photoImageView.image
            let rating = ratingControl.ratingIndex
            
            // Set the meal to be passed to MealListTableViewController after the unwind seque
            meal = Meal(name: name, photo: photo, rating: rating)
        }
    }

}

