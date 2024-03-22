//
//  PhotoViewController.swift
//  FinalProject
//
//  Created by CDMStudent on 3/18/24.
//

import UIKit

class PhotoViewController:UIViewController {

    var takenPhoto:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        if let availableImage = takenPhoto{
            imageView.image = availableImage
        }
    }
    

    @IBOutlet weak var imageView: UIImageView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
