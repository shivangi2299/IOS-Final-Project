//
//  SignInTableViewController.swift
//  FinalProject
//
//  Created by CDMStudent on 3/12/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class SignInTableViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
               // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        setUpElements()
       

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogoImageView.image = UIImage(named: "logo")
    }
    
    // MARK: - Table view data source
    
    
    @IBOutlet weak var Error: UILabel!
    
    
    @IBOutlet weak var UseranameLabel: UITextField!
    
    @IBOutlet weak var PasswordLabel: UITextField!
    
    
    
    @IBOutlet weak var newUserSignIn: UIButton!
    
    
    @IBOutlet weak var LogoImageView: UIImageView!
    
    @IBOutlet weak var SignInLabel: UIButton!
    
    func setUpElements(){
        Error.alpha = 0
    }
    
    // MARK: - Navigation
    
    
    @IBAction func didTapOutside(_ sender: UIGestureRecognizer) {
        dimissKeyboard()
    }
    
    private func dimissKeyboard(){
        self.view.endEditing(false)
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
    
    func validateFields() -> String? {
        
        if UseranameLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || PasswordLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  {
            
            return " Please fill all the fields. "
            
            let cleanedUname = UseranameLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanedPassword = PasswordLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if Utilities.isValidEmail(testStr: cleanedUname) == false ||
                Utilities.isPasswordValid(cleanedPassword) == false {
                return "Please enter Valid Email ID or Password"
            }
        }
        return nil
    }
    
    
    
    
        @IBAction func SigninTapped(_ sender: UIButton) {
            let error = validateFields()
          
        
                if error != nil{
                    self.showerrorMessage(error!)
                }else{
                    let  cleanedUname = UseranameLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let  cleanedPassword = PasswordLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    Auth.auth().signIn(withEmail: cleanedUname , password: cleanedPassword) { result,err in
                        
                        if err != nil{
                            self.Error.text = "Incorrect Username or Password"
                            self.Error.alpha = 1
                        }else{
                            self.transitionHome()
                        }
                        
                        
                        
                }
            }
            
        }
        
    func transitionHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? UITabBarController
            
            view.window?.rootViewController = homeViewController
            view.window?.makeKeyAndVisible()
        }
        
        
    func showerrorMessage(_ message:String){
        Error.text = message
        Error.alpha = 1
    }

}
