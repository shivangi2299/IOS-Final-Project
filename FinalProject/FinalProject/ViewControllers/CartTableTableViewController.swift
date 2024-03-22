//
//  CartTableTableViewController.swift
//  FinalProject
//
//  Created by CDMStudent on 3/18/24.
//

import UIKit
import Foundation

struct CartProduct {
    var id: String
    var product: Product
    
}

extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

class CartTableTableViewController: UITableViewController {
  //  var cartProducts = [CartProduct]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Cart"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.reloadData()
               // Fetch cart products when view loads
               fetchCart()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.reloadData()
               // Fetch cart products when view loads
               fetchCart()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartManager.shared.cartProducts.count

    
    }
    
    func fetchCart() {
            // Implement your function to fetch cart products
            // For example:
            // cartProducts = fetchCartProducts()
        }
    func calculateTotal() -> Double {
            var total = 0.0
            for cartProduct in CartManager.shared.cartProducts {
                total += cartProduct.productprice
            }
            return total
        }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cartProd = CartManager.shared.cartProducts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell" , for: indexPath)

    

        cell.textLabel?.text = "\(cartProd.productname!)                      $\(cartProd.productprice!)"
//        if let originalImage = UIImage(named: "originalImage") {
//            let newSize = CGSize(width: 100, height: 100) // Set your desired size here
//            let resizedImage = originalImage.resized(to: newSize)
//            
//            // Use the resizedImage as needed
//        }
//
//        if let firstImageUrl = cartProd.productImageLinks?.first {
//            downloadImages(imageUrls: [firstImageUrl]) { (images) in
//                if let firstImage = images.first as? UIImage {
//                    cell.imageView?.image = firstImage
//                } else {
//                    // Handle case where the downloaded image is not valid
//                    print("Failed to load image")
//                }
//            }
//        }
//    
        if let firstImageUrl = cartProd.productImageLinks?.first {
            downloadImages(imageUrls: [firstImageUrl]) { (images) in
                if let firstImage = images.first as? UIImage {
                    let newSize = CGSize(width: 100, height: 150) // Set your desired size here
                    if let resizedImage = firstImage.resized(to: newSize) {
                        cell.imageView?.image = resizedImage
                    }
                } else {
                    // Handle case where the downloaded image is not valid
                    print("Failed to load image")
                }
            }
        }

        return cell
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
           let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
           let totalLabel = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.width - 32, height: 50))
           totalLabel.textAlignment = .right
           totalLabel.text = "Total: $\(calculateTotal())"
           footerView.addSubview(totalLabel)
           return footerView
       }

       override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
           return 50 // Adjust the height as needed
       }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
