//
//  ProductCollectionViewController.swift
//  FinalProject
//
//  Created by CDMStudent on 3/16/24.
//

import UIKit



class ProductCollectionViewController: UICollectionViewController {

    var productarray:[Product] = []
     
    private let sectionInsets = UIEdgeInsets(top:20, left: 10, bottom: 20, right: 10)
    
    private let itemsPerRow: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //createProduct()
        self.title = "Products"
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadProducts()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

  


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productarray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionViewCell
        // Configure the cell
        cell.generateCell(productarray[indexPath.row])
    
        return cell
    }
//Download Categories
    
    private func loadProducts(){
        
        downloadProductfromFirebase { productArray in
    
            self.productarray = productArray
            self.collectionView.reloadData()
        }
    }
   
}

extension ProductCollectionViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectioViewLayout: UICollectionViewLayout ,sizeForUtemAt indexPath: IndexPath ) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availablewidth = view.frame.width - paddingSpace
        let withPerItem = availablewidth / itemsPerRow
        let heightPerItem = withPerItem * 1.5
        return CGSize(width: withPerItem, height: withPerItem + 50
    )
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectioViewLayout: UICollectionViewLayout ,insetForSectionAt section:Int ) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectioViewLayout: UICollectionViewLayout , minimumLineSpacingForSectionAt section:Int ) -> CGFloat {
        return sectionInsets.left
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        guard let productdetailViewController = segue.destination as? ProductDetailPageViewController else { return }
        guard let cell = sender as? UICollectionViewCell else { return }
        guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
        productdetailViewController.product = productarray[indexPath.row]
    }
}
