//
//  Products.swift
//  FinalProject
//
//  Created by CDMStudent on 3/16/24.
//

import Foundation
import UIKit
import FirebaseFirestore


class Product : Equatable {
    static func == (lhs: Product, rhs: Product) -> Bool {
            return lhs.productid == rhs.productid
        }
    
    var productid:String!
    var productname:String!
    var productshortDescription:String!
    var productprice: Double!
    var description : String!
    var productimageName : String!
    var prodImage :UIImage?
    var productImageLinks : [String]?
   // var image: UIImage
    
    init(){
        
    }
    init(_productname :String , _productprice :Double, _productImage: [String], _imageName: String){
        productid=""
        productname = _productname
        productprice = _productprice
        productimageName = _imageName
        prodImage = UIImage(named: _imageName)
       
    }
    init(_dictonary: NSDictionary){
        productid = _dictonary[Kobjectid] as? String
        productname = _dictonary[KName] as? String
        productprice = _dictonary[KPrice] as? Double
        description = _dictonary[Kdescription] as? String
        productimageName = _dictonary[KImageName] as? String
        prodImage = UIImage(named: _dictonary["imageName"] as? String ?? "")
        productImageLinks = _dictonary[KImageLinks] as? [String]
        
        
    }
    //SaveItem to FireStore
    

    
}

//Downloding Products

func downloadProductfromFirebase(completion: @escaping (_ productArray : [Product])-> Void){
    
    var  productArray: [Product] = []
    FirebaseReference(.Products).getDocuments{
        (snapshot,error) in
        
        guard let snapshot = snapshot else{
            completion(productArray)
            return
        }
        
        if !snapshot.isEmpty{
            for productDict in snapshot.documents{
                print("Ceeated Product")
                productArray.append(Product(_dictonary: productDict.data() as NSDictionary))
            }
        }
        completion(productArray)
    }
}

func saveProductToFireStore(_ Product: Product){
    let id = UUID().uuidString
    Product.productid = id
    FirebaseReference(.Products).document(id ).setData(productDictionaryfrom(Product) as!  [String:Any])
}

//Mark : HelperFuctions
func productDictionaryfrom(_ Product:Product) -> NSDictionary {
    return NSDictionary(objects: [Product.productid, Product.productname, Product.productprice, Product.description , Product.productimageName, Product.productImageLinks], forKeys:[ Kobjectid as NSCopying,KName as NSCopying, KPrice as NSCopying, Kdescription as NSCopying, KImageName as NSCopying, KImageLinks as NSCopying])
}

//func createProduct(){
//    
//    let table = Product(_productname:"Wooden Table", _productprice: 50, _productImage: ["Woodentable"], _imageName: "woodentable")
//    let chair = Product(_productname:"Wooden Chair", _productprice: 50, _productImage: ["woodenchair"], _imageName: "woodenchair")
//    
//    let arrayofProducts =  [table,chair]
//    
//    for  product in arrayofProducts{
//        saveProductToFireStore(product)
//    }
//    
//}
