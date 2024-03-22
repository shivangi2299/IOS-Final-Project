//
//  CartManager.swift
//  FinalProject
//
//  Created by CDMStudent on 3/18/24.
//

import Foundation


class CartManager {
    static let shared = CartManager()
    //private init() {}

    var cartProducts = [Product]()

    func addToCart(product: Product) {
        cartProducts.append(product)
    }

    func fetchCartProducts() -> [Product] {
        return cartProducts
    }
}
