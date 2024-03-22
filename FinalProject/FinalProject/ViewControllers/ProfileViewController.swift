//
//  ProfileViewController.swift
//  FinalProject
//
//  Created by CDMStudent on 3/18/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfileData()
        self.title = "My Profile"
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var ProfileEmail: UILabel!
    
    @IBOutlet weak var profileName: UILabel!
    

    
    //    func loadProfileData(){
    //        if Auth.auth().currentUser !=  nil {
    //            guard let uid = Auth.auth().currentUser?.uid else{
    //                return
    //            }
    //        }
    //    }
    
    func loadProfileData() {
        if let currentUser = Auth.auth().currentUser {
            let uid = currentUser.uid
            print("User ID:", uid)
            let db = Firestore.firestore()
            let userDocRef = db.collection("users").document(uid)
            userDocRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    // Document found, parse data
                    if let userData = document.data() {
                        // Here you can parse userData and do whatever you need with it
                        
                        
                        print("User data:", userData)
                        if let firstName = userData["first_name"] as? String,
                           let lastName = userData["last_name"] as? String {
                            // Update profileName label
                            print(firstName+lastName)
                            DispatchQueue.main.async {
                                self.profileName.text = "\(firstName) \(lastName)"
                                
                                self.ProfileEmail.text = currentUser.email
                                
                            }
                        }
                    } else {
                        print("Document does not exist or error fetching document:", error?.localizedDescription ?? "Unknown error")
                    }
                }
                else {
                    print("No user is currently signed in.")
                }
            }
        }
    }
}
