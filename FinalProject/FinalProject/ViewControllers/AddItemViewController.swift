//
//  AddItemViewController.swift
//  FinalProject
//
//  Created by CDMStudent on 3/17/24.
//

import UIKit
import Photos
import PhotosUI
import ActivityKit
import AVFoundation

class AddItemViewController: UIViewController,PHPickerViewControllerDelegate , UITextViewDelegate{

//    let captureSession =  AVCaptureSession()
//    var previewLayer:CALayer!
//    
//    var captureDevice:AVCaptureDevice!
    
    let placeHolderText = "description"
    override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2 - 30 , y: self.view.frame.height/2 - 30, width: 60, height: 60))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Item"
        productDescriptionTextField.delegate = self
        productDescriptionTextField.text = placeHolderText
        productDescriptionTextField.textColor = .lightGray
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var productTitleTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var productDescriptionTextField: UITextView!
    
    var activityIndicator : UIActivityIndicatorView?
    var itemImages:[UIImage?] = []
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if productDescriptionTextField.textColor == .lightGray{
            productDescriptionTextField.text = ""
            productDescriptionTextField.textColor = .black
        }
    }
    
    
   
    @IBAction func UploadImage(_ sender: Any) {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc,animated: true)
    }
    
    func didCaptureImage(_ image: UIImage) {
            // Add the captured image to itemImages
            itemImages.append(image)
        
            // Reload UI or update as needed
        }
    @IBAction func clicKPictureToUpload(_ sender: Any) {
       
        
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
                guard let self = self, error == nil else { return }
                guard let image = reading as? UIImage else { return }
                
                // Append the selected image to the itemImages array
                self.itemImages.append(image)
            }
        }
    }
    @IBAction func AddItemButtonPressedToDone(_ sender: Any) {
        
        dimissKeyboard()
        if fieldsAreCompleted(){
           saveToFirebase()
            showAlert(message: "Product added!")
            itemImages = []
        
        }
        else{
            print("Error")
        }
    }
    
    func showAlert(message: String) {
        productPriceTextField.text = ""
        productTitleTextField.text = ""
        productDescriptionTextField.text = placeHolderText
        productDescriptionTextField.textColor = .lightGray
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func backgroudClicked(_ sender: UIGestureRecognizer) {
       dimissKeyboard()
    }
  
//    
//    @IBAction func didEditEnds(_ sender: UITextField){
//        sender.resignFirstResponder()
//    }
    private func dimissKeyboard(){
        self.view.endEditing(false)
    }
    
    
    private func popTheView(){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func fieldsAreCompleted() -> Bool {
        
        return (productTitleTextField.text != "" && productPriceTextField.text != "" && productDescriptionTextField.text != "")
    }
    
    private func saveToFirebase(){
        showLoadingIndicator()
        let prod = Product()
         prod.productid = UUID().uuidString
        prod.productname = productTitleTextField.text!
        prod.productprice = Double(productPriceTextField.text!)
        prod.description = productDescriptionTextField.text
        if itemImages.count > 0 {
            uploadImage(Images : itemImages, productId: prod.productid){
                imageLikeArray in
                prod.productImageLinks = imageLikeArray
                
                saveProductToFireStore(prod)
                self.hideLoadingIndicator()
                self.popTheView()
            }
        }else {
            saveProductToFireStore(prod)
            popTheView()
        }
    }

    
    // Activity Indicator
    
    private func showLoadingIndicator(){
        if activityIndicator != nil{
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    private func hideLoadingIndicator(){
        if activityIndicator != nil{
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
}

protocol AddItemDelegate: AnyObject {
    func didAddImages(_ images: [UIImage])
}
