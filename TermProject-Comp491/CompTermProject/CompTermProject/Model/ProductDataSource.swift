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


struct ProductDataSource {
    let db = Firestore.firestore()
    private var productArray: [Product] = []
    //static var productDataSource = ProductDataSource()
    
    init(){
        
        //Burda da productArray i doluruyoruz ancak 2 tane array de yapılabilir sabah akşam diye. 
        productArray.append(contentsOf: getAksamDocument())
        productArray.append(contentsOf: AppendSabahDocument())
                          
    }
    
    func getProductWithIndex(index: Int) -> Product {
            return productArray[index]
    }
    
    func getNumberOfProducts()-> Int{
        return productArray.count
    }
    
    
    func createProduct(event: Product? ){

    }
    //fireBase deki akşam rutininde olan bütün productları çekiyor sanırım tam test edemedim hata olabilir
    private func getAksamDocument()-> [Product] {
        var aksamArr:[Product] = []
        //Get specific document from current user
        let userID = Auth.auth().currentUser?.uid ?? ""
        let docRef = db.collection("users").document(userID).collection("routines").document("routine").collection("aksam").document("products")

        // Get data
        docRef.getDocument { document, error in
            if let document = document {
                do{
                    let data = document.data()
                    let docKeys = data!.keys
                    for key in docKeys{
                        aksamArr.append(fetchProduct(key: key, number: data?[key] as! String))
                    }
                    //Success
                }
            }
            else{
                
            }
        }
        return aksamArr
    }
    //fireBase deki sabah rutininde olan bütün productları çekiyor sanırım tam test edemedim hata olabilir
    private func AppendSabahDocument()->[Product] {
        var sabahArr:[Product] = []
        //Get specific document from current user
        let userID = Auth.auth().currentUser?.uid ?? ""
        let docRef = db.collection("users").document(userID).collection("routines").document("routine").collection("sabah").document("products")

        // Get data
        docRef.getDocument { (document, error) in
            if let document = document {
                do{
                    let data = document.data()
                    let docKeys = data!.keys
                    for key in docKeys{
                        sabahArr.append(fetchProduct(key: key, number: data?[key] as! String))
                    }
                    //Success
                }
            }
        }
        return sabahArr
    }
    //içine bir key(yüz maskes) ve numarası(0....300...) verildiğinde o product ı database den çekiyo
    private func fetchProduct(key: String,number:String)->Product {
        var prod:Product = Product(kullanım_sekli: "",ozet_Bilgi: "",urun_bilgi: "",urun_bileseni: [""],urun_boyutu: "",urun_faydalari: "",urun_markasi: "");
        let docRef = db.collection("product").document("product_list")
            .collection(key).document(number)
        docRef.getDocument { document, error in
            if let error = error as NSError? {
                print(error)
            }
            else {
              if let document = document {
                do {
                    let data = document.data()
                    let kullanım_sekli: String = data?["Kullanım Şekli:"] as? String ?? ""
                    let ozet_Bilgi: String = data?["Özet Bilgi:"] as? String ?? ""
                    let urun_bilgi: String = data?["Ürün Adı:"] as? String ?? ""
                    let urun_bileseni: [String] = data?["Ürün Bileşimi:"] as? [String] ?? [""]
                    let urun_boyutu:String = data?["Ürün Boyutu:"] as? String ?? ""
                    let urun_faydalari: String = data?["Ürün Faydaları:"] as? String ?? ""
                    let urun_markasi: String = data?["Ürün Markası:"] as? String ?? ""
                    prod = Product(kullanım_sekli: kullanım_sekli, ozet_Bilgi: ozet_Bilgi, urun_bilgi: urun_bilgi, urun_bileseni: urun_bileseni, urun_boyutu: urun_boyutu, urun_faydalari: urun_faydalari, urun_markasi: urun_markasi)
                }
              }
            }
        }
        return prod
    }
}
