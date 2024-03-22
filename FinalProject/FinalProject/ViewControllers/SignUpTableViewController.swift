//
//  SignUpTableViewController.swift
//  FinalProject
//
//  Created by CDMStudent on 3/12/24.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore


class SignUpTableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ImageLogo.image = UIImage(named: "logo")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        setUpElements()
        
    }

    // MARK: - Table view data source

    @IBOutlet weak var ImageLogo: UIImageView!
    

    @IBOutlet weak var FirstName: UITextField!
    
    
    @IBOutlet weak var LastName: UITextField!
    
    
    @IBOutlet weak var Email: UITextField!
    
    
    @IBOutlet weak var Password: UITextField!
    
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    
    @IBOutlet weak var SignupButton: UIButton!
    
    func setUpElements(){
        ErrorLabel.alpha = 0
    }
   
    
   
    @IBAction func backgroundClick(_ sender: UITapGestureRecognizer) {
        dimissKeyboard()
    }
    private func dimissKeyboard(){
        self.view.endEditing(false)
    }
    func validateFields() -> String? {
        
        if FirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || LastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || Email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || Password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || Password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return " Please fill all the fields. "
        }
        // Validate the Password
        let cleanedEmail = Email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isValidEmail(testStr: cleanedEmail) == false {
            self.showerrorMessage("Please enter Valid Email ID")
        }
        let cleanedPassword = Password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false {
            return " Please make sure password is atleast 8 chacters long, which should contain a special characters and a number."
        }
        
        return nil
    }
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            showerrorMessage(error!)
        }else {
            
            let firstName = FirstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = LastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = Email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = Password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            Auth.auth().createUser(withEmail: email, password: password) {(result,err) in

                if err != nil {
                    self.showerrorMessage("Error Creating user")
                }else if let user = result?.user {
                    let uid = user.uid
                    let db = Firestore.firestore()
                    
                   
                    db.collection("users").document(uid).setData([
                                "first_name": firstName,
                                "last_name": lastName,
                                "uid": uid,
                            ]) { (error) in
                        if error != nil {
                            self.showerrorMessage("Data not stored in Database")
                        }
                    }
                    
                    self.dismissViewController()
                    
                    
                }
            }
        }
        
    }
    
    func dismissViewController() {
        // Check if the presenting view controller is a navigation controller
        FirstName.text =  ""
        LastName.text = ""
        Email.text = ""
        Password.text = ""
        if let navigationController = self.navigationController {
            // If it is, dismiss the top view controller in the navigation stack
            navigationController.popViewController(animated: true)
        } else {
            // If not, dismiss the current view controller
            self.dismiss(animated: true, completion: nil)
        }
    }
     
    func showerrorMessage(_ message:String){
        ErrorLabel.text = message
        ErrorLabel.alpha = 1
    }

}
