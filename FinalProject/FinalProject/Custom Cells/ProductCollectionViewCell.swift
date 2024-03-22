//
//  ProductCollectionViewCell.swift
//  FinalProject
//
//  Created by CDMStudent on 3/16/24.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var PImage: UIImageView!
    
    @IBOutlet weak var PName: UILabel!
    
    
    @IBOutlet weak var PPrice: UILabel!
    
    func generateCell(_ product:Product){
        PName.text = product.productname
        PPrice.text = "$\(String(product.productprice))" // "Total: $\(calculateTotal())"
        //PImage.image = UIImage(product.productImageLinks!)
      // PImage.image = product.prodImage
        
    
//        if product.productImageLinks != nil && product.productImageLinks!.count > 0 {
//            downloadImages(imageUrls: [product.productImageLinks?.first! ]){ (images) in
//                self.PImage.image = images.first as? UIImage
//                
//            }
//        }
        
        if let firstImageUrl = product.productImageLinks?.first {
            downloadImages(imageUrls: [firstImageUrl]) { (images) in
                if let firstImage = images.first as? UIImage {
                    self.PImage.image = firstImage
                } else {
                    // Handle case where the downloaded image is not valid
                    print("Failed to load image")
                }
            }
        }
    }
    
}
 
