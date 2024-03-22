//
//  ProductDetailPageViewController.swift
//  FinalProject
//
//  Created by CDMStudent on 3/17/24.
//

import UIKit


class ProductDetailPageViewController: UIViewController {

    let placeHolderText = "description"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        updateUI()
    }
    func updateUI() {
            if let product = product {
                itemName.text = product.productname
                itemPrice.text = "\(product.productprice ?? 0.0)"
                // Set other UI elements accordingly
            }
        }
    

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var ItemImage: UIImageView!
    @IBOutlet weak var ItemDescription: UITextView!
    @IBOutlet weak var ButNowButton: UIButton!
    @IBOutlet weak var AddToCartButton: UIButton!
    
    var product : Product?
    /*
     @IBOutlet weak var itemPrice: UILabel!
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewDidAppear(_ animated: Bool) {
        if let p = product {
            itemName.text = p.productname
            itemPrice.text = "$\(String(p.productprice!))" //"\(p.productprice!)" 
            ItemDescription.text = p.description

            if let firstImageUrl = product?.productImageLinks?.first {
                downloadImages(imageUrls: [firstImageUrl]) { (images) in
                    if let firstImage = images.first as? UIImage {
                        self.ItemImage.image = firstImage
                    } else {
                        // Handle case where the downloaded image is not valid
                        print("Failed to load image")
                    }
                }
            }
        }
    }
  
   
    @IBAction func AddtoCartButtonPressed(_ sender: Any) {
        
        guard let product = product else {
                // Handle the case where product is nil
                return
            }

            let cartManager = CartManager.shared
            let existingProducts = cartManager.fetchCartProducts()

            // Check if the product is already in the cart
            if existingProducts.contains(where: { $0.productid == product.productid }) {
                // Product is already in the cart, you can provide feedback to the user if needed
                showAlert(message: "Product is already in the cart!")
            } else {
                // Product is not in the cart, so add it
                cartManager.addToCart(product: product)
                // Optionally, you can provide feedback to the user
                showAlert(message: "Product added to cart!")
            }
        func showAlert(message: String) {
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    

}
