//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by 진형탁 on 2017. 1. 27..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: Property
    @IBOutlet weak var memeNavigationBar: UINavigationBar!
    @IBOutlet weak var memeToolbar: UIToolbar!
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var shareActionButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextfieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTextfieldConstraint: NSLayoutConstraint!
    
    let imagePicker = UIImagePickerController()
    var currentMemeImage: UIImage!
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
        ] as [String : Any]

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        configure(textfield: topTextField)
        configure(textfield: bottomTextField)
        
        shareActionButton.isEnabled = false
        
        // Add observer for device rotation move the textfield farther apart in landscape
        NotificationCenter.default.addObserver(self, selector: #selector(rotated(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Subscribe to keyboard notifications
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: View interface
    @IBAction func actionButtonPressed(_ sender: AnyObject) {
        currentMemeImage = generateMemedImage()
        let activityVC = UIActivityViewController.init(activityItems: [currentMemeImage], applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {
            (activityType, completion, returnedItems, error) in
            if completion {
                self.saveMeme()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(activityVC, animated: true)
    }
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        clearMemeEditor()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cameraButtonPressed(_ sender: AnyObject) {
        presentPicker(sourceType: .camera)
    }
    @IBAction func albumButtonPressed(_ sender: AnyObject) {
        presentPicker(sourceType: .photoLibrary)
    }
    
    // MARK: Image helper functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImageView.image = image
        }
        shareActionButton.isEnabled = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func presentPicker(sourceType:UIImagePickerControllerSourceType){
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: Text style and helper functions
    func configure(textfield: UITextField ){
        textfield.defaultTextAttributes = memeTextAttributes
        textfield.textAlignment = NSTextAlignment.center
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Keyboard helper functions
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: NSNotification) {
        if bottomTextField.isFirstResponder{
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        if bottomTextField.isFirstResponder{
            view.frame.origin.y = 0
        }
    }

    func getKeyboardHeight(_ notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: Create Meme object functions
    func saveMeme() {
        //Create the meme
        let meme = MemeData(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeImageView.image!, memeImage: currentMemeImage)
        
        // Add to the memeDatas array in the Application Delegate
        (UIApplication.shared.delegate as! AppDelegate).memeDatas.append(meme)
    }
    
    // Create a UIImage that combines the Image View and the Textfields
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        configureBars(hidden: true)
        
        // render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        configureBars(hidden: false)
        
        return memedImage
    }
    
    func configureBars(hidden: Bool){
        memeNavigationBar.isHidden = hidden
        memeToolbar.isHidden = hidden
    }
    
    // MARK: Clear editor helper function
    func clearMemeEditor(){
        shareActionButton.isEnabled = false
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        memeImageView.image = nil
        currentMemeImage = nil
    }
    
    // MARK: Adjust the textfields on landscape
    func rotated(_ notification: NSNotification){
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation))
        {
            print("landscape")
            topTextfieldConstraint.constant = 5
            bottomTextfieldConstraint.constant = 5
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation))
        {
            print("Portrait")
            topTextfieldConstraint.constant = 28
            bottomTextfieldConstraint.constant = 40
        }
    }
    
}

