//
//  ProductDataSource.swift
//  CompTermProject
//
//  Created by Eren Ege Özol on 11.03.2022.
//

import Foundation
import CoreLocation
import Firebase
import FirebaseFirestore


class ProductDataSource {
    
    
    private let baseURL = "https://europe-west3-skinmate-2aab0.cloudfunctions.net"
    private let detailURL = ""
    public var productArray: [Product] = []
    static var productDataSource = ProductDataSource()
    var delegate: ProductDataSourceDelegate?
    
    init(){
        
    }
    
    func loadProductList() {
        guard let userID = Auth.auth().currentUser?.uid else{
            print("UserId Not found")
            return
        }
        let body = ["user_id": userID, "query": "routine"]
            
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body
        )
        let urlSession = URLSession.shared
        if let url = URL(string: "\(baseURL)/get_last-1") {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = bodyData
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
                let decoder = JSONDecoder()
                if let data = data {
                    if let productArrayFromNetwork = try? decoder.decode([Product].self, from: data){
                        self.productArray = productArrayFromNetwork
                        DispatchQueue.main.async {
                            self.delegate?.productListLoaded()
                        }
                    }
                    else{
                        print("DataSource not created as it doesnt exist before analysis")
                    }

                    
                }
            }
            dataTask.resume()
        }
    }
    
    func loadProductDetail(productId: Int) {
//        let urlSession = URLSession.shared
//        if let url = URL(string: "\(baseURL)/product/\(productId)") {
//            var urlRequest = URLRequest(url: url)
//            urlRequest.httpMethod = "POST"
//            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            let dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
//                let decoder = JSONDecoder()
//                if let data = data {
//                    let ProductFromNetwork = try! decoder.decode(Product.self, from: data)
//                    DispatchQueue.main.async {
//                        self.delegate?.productDetailLoaded(product: ProductFromNetwork)
//                    }
//                }
//            }
//            dataTask.resume()
//        }
    }
    
    func getProductWithIndex(index: Int) -> Product {
            return productArray[index]
    }
    
    func getNumberOfProducts()-> Int{
        return productArray.count
    }
    
}
