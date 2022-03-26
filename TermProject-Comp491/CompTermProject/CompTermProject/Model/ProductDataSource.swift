//
//  ProductDataSource.swift
//  CompTermProject
//
//  Created by Eren Ege Özol on 11.03.2022.
//

import Foundation
import CoreLocation


struct ProductDataSource {
    private var productArray: [Product] = []
    //static var productDataSource = ProductDataSource()
    
    init(){
        
        productArray.append(Product(prodName: "Sebamed", imageName: "sebamed", usage: "Usage Description1"))
        productArray.append(Product(prodName: "Avene", imageName: "avene", usage: "Usage Description"))
                          
    }
    
    func getProductWithIndex(index: Int) -> Product {
            return productArray[index]
    }
    
    func getNumberOfProducts()-> Int{
        return productArray.count
    }
    
    
    func createProduct(event: Product? ){

    }
    
}

