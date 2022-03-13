//
//  ProductDataSource.swift
//  CompTermProject
//
//  Created by Eren Ege Özol on 11.03.2022.
//

import Foundation
import CoreLocation


class ProductDataSource: ObservableObject {
    private var productArray: [product?] = []
    static var productDataSource = ProductDataSource()
    
    init(){
        
        productArray.append(product(prodName: "prodName1", imageName: "Image1", usage: "Usage Description1"))
        productArray.append(product(prodName: "prodName", imageName: "Image", usage: "Usage Description"))
                          
    }
    
    func getProductWithIndex(index: Int) -> product? {
            return productArray[index]
    }
    
    func getNumberOfProducts()-> Int{
        return productArray.count
    }
    
    
    func createProduct(event: product? ){

    }
    
}

